/*
 * Copyright (c) 2019-2026, Beijing Haawking Technology Co., Ltd.
 * Minimal product-module demonstration. See the example README.
 */
#include <syscalls.h>
#include "driverlib.h"
#include "device.h"
#include "board.h"
#include "Drv_Led.h"
#include "Drv_Key.h"
#include "Drv_Sci_Log.h"
#include "product_module.h"
#include "password.h"

volatile uint32_t g_module_input = 0U;
volatile uint32_t g_module_output = 0U;

static void Delay_Ms(uint32_t delay_ms)
{
    while (delay_ms-- != 0U) {
        DEVICE_DELAY_US(1000);
    }
}

static bool Key_Released(void)
{
    if (Drv_Get_Key_Value() != 0U) {
        return false;
    }
    Delay_Ms(20U);
    if (Drv_Get_Key_Value() != 0U) {
        return false;
    }
    while (Drv_Get_Key_Value() == 0U) {
    }
    Delay_Ms(20U);
    return true;
}

static void Print_Module_Result(void)
{
    char line[64];

    snprintf(line, sizeof(line), "[MODULE] input=%lu output=%lu\r\n",
             (unsigned long)g_module_input, (unsigned long)g_module_output);
    Drv_Sci_Log_Print(line);
}

// Application-level preload experiment adapted from 28002x; see DCSM-002.
// Read-only Zone1 preparation, not a replacement for BootROM initialization.
static void Prepare_Zone1_Unlock(void)
{
    uint32_t linkPointer;
    uint32_t zsbBase = DCSM_Z1OTP_BASE + 0x40U;
    int32_t bitPos;

    // Follow the 280013x Zone1 header order; DriverLib has no preload API.
    (void)HWREG(DCSM_Z1OTP_BASE + DCSM_O_Z1OTP_LINKPOINTER1);
    (void)HWREG(DCSM_Z1OTP_BASE + DCSM_O_Z1OTP_LINKPOINTER2);
    (void)HWREG(DCSM_Z1OTP_BASE + DCSM_O_Z1OTP_LINKPOINTER3);
    (void)HWREG(DCSM_Z1OTP_BASE + DCSM_O_Z1OTP_JLM_ENABLE);
    (void)HWREG(DCSM_Z1OTP_BASE + DCSM_O_Z1OTP_GPREG1);
    (void)HWREG(DCSM_Z1OTP_BASE + DCSM_O_Z1OTP_GPREG2);
    (void)HWREG(DCSM_Z1OTP_BASE + DCSM_O_Z1OTP_GPREG3);
    (void)HWREG(DCSM_Z1OTP_BASE + DCSM_O_Z1OTP_GPREG4);
    (void)HWREG(DCSM_Z1OTP_BASE + DCSM_O_Z1OTP_PSWDLOCK);
    (void)HWREG(DCSM_Z1OTP_BASE + 0x24U); // CRCLOCK: TRM; no SDK offset macro.
    (void)HWREG(DCSM_Z1OTP_BASE + DCSM_O_Z1OTP_JTAGPSWDH0);
    (void)HWREG(DCSM_Z1OTP_BASE + DCSM_O_Z1OTP_JTAGPSWDH1);

    // Match this platform's DriverLib: low14 pointer bits, 0x40-byte ZSBs.
    linkPointer = HWREG(DCSM_Z1_BASE + DCSM_O_Z1_LINKPOINTER);
    for (bitPos = 13; bitPos >= 0; bitPos--) {
        if ((linkPointer & (1UL << bitPos)) == 0U) {
            zsbBase = DCSM_Z1OTP_BASE + ((uint32_t)bitPos + 2U) * 0x40U;
            break;
        }
    }

    // Active ZSB configuration only; skip reserved offsets and password words.
    (void)HWREG(zsbBase + 0x10U); // GRABSECT1
    (void)HWREG(zsbBase + 0x14U); // GRABSECT2
    (void)HWREG(zsbBase + 0x18U); // GRABSECT3: accepted experimental layout.
    (void)HWREG(zsbBase + 0x1CU); // GRABRAM1
    (void)HWREG(zsbBase + 0x28U); // EXEONLYSECT1
    (void)HWREG(zsbBase + 0x2CU); // EXEONLYSECT2: inferred layout, read only.
    (void)HWREG(zsbBase + 0x30U); // EXEONLYRAM1
    (void)HWREG(zsbBase + 0x38U); // JTAGPSWDL0
    (void)HWREG(zsbBase + 0x3CU); // JTAGPSWDL1
}

static void Print_Zone1_Status(void)
{
    char line[96];
    DCSM_SecurityStatus status = DCSM_getZone1CSMSecurityStatus();
    const char *state = "secure";

    if (status == DCSM_STATUS_UNSECURE) {
        state = "unlocked";
    } else if (status == DCSM_STATUS_LOCKED) {
        state = "locked (ALLZERO)";
    } else if (status == DCSM_STATUS_BLOCKED) {
        state = "blocked (ALLONE)";
    }
    // DriverLib returns CR shifted right by 16; log it explicitly as such.
    snprintf(line, sizeof(line), "[DCSM] Zone1 %s; CR>>16=0x%08lx\r\n",
             state, (unsigned long)DCSM_getZone1ControlStatus());
    Drv_Sci_Log_Print(line);
}

int main(void)
{
    Device_init();
    Device_initGPIO();
    Interrupt_initModule();
    Interrupt_initVectorTable();
    Board_init();
    EINT;
    ERTM;

    Drv_Sci_Log_Print("[ex02] KEY toggles Zone1 lock/unlock.\r\n");
    Print_Zone1_Status();

    while (1) {
        Delay_Ms(250U);
        Drv_Led_Toggle();

        // Pause protected calls while locked to keep debug observation in APP.
        if (DCSM_getZone1CSMSecurityStatus() == DCSM_STATUS_UNSECURE) {
            g_module_input = (g_module_input % 9U) + 1U;
            g_module_output = ProductModule_Process(g_module_input);
            Print_Module_Result();
        }

        if (Key_Released()) {
            if (DCSM_getZone1CSMSecurityStatus() == DCSM_STATUS_UNSECURE) {
                Drv_Sci_Log_Print("[DCSM] Request lock.\r\n");
                DCSM_secureZone1();
            } else {
                Drv_Sci_Log_Print("[DCSM] Request unlock.\r\n");
                Prepare_Zone1_Unlock();
                DCSM_unlockZone1CSM(&s_z1_demo_key);
            }
            Print_Zone1_Status();
        }
    }
}

