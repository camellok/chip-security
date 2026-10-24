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
volatile uint32_t g_app_work_read = 0U;

static __attribute__((noinline)) uint32_t App_Read_Module_Work(void)
{
    return HWREG(LS4_RAM_BASE);
}

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
    char line[96];

    snprintf(line, sizeof(line), "[MODULE] input=%lu output=%lu app_read=%lu\r\n",
             (unsigned long)g_module_input, (unsigned long)g_module_output,
             (unsigned long)g_app_work_read);
    Drv_Sci_Log_Print(line);
}

// Example-specific OTP preload sequence under evaluation; see DCSM-001.
static void Prepare_Zone1_Unlock(void)
{
    uint32_t linkPointer;
    uint32_t zsbBase = DCSMBANK0_Z1OTP_BASE + 0x40U;
    int32_t bitPos;

    (void)HWREG(DCSMBANK0_Z1OTP_BASE + DCSM_O_B0_Z1OTP_LINKPOINTER1);
    (void)HWREG(DCSMBANK0_Z1OTP_BASE + DCSM_O_B0_Z1OTP_LINKPOINTER2);
    (void)HWREG(DCSMBANK0_Z1OTP_BASE + DCSM_O_B0_Z1OTP_LINKPOINTER3);
    (void)HWREG(DCSMBANK0_Z1OTP_BASE + DCSM_O_Z1OTP_PSWDLOCK);
    (void)HWREG(DCSMBANK0_Z1OTP_BASE + DCSM_O_Z1OTP_CRCLOCK);
    (void)HWREG(DCSMBANK0_Z1OTP_BASE + DCSM_O_Z1OTP_BOOTPIN_CONFIG);
    (void)HWREG(DCSMBANK0_Z1OTP_BASE + DCSM_O_Z1OTP_GPREG2);
    (void)HWREG(DCSMBANK0_Z1OTP_BASE + DCSM_O_Z1OTP_BOOTDEF_LOW);
    (void)HWREG(DCSMBANK0_Z1OTP_BASE + DCSM_O_Z1OTP_BOOTDEF_HIGH);

    linkPointer = HWREG(DCSMBANK0_Z1_BASE + DCSM_O_B0_Z1_LINKPOINTER);
    for (bitPos = 28; bitPos >= 0; bitPos--) {
        if ((linkPointer & (1UL << bitPos)) == 0U) {
            zsbBase = DCSMBANK0_Z1OTP_BASE + ((uint32_t)bitPos + 3U) * 0x20U;
            break;
        }
    }

    (void)HWREG(zsbBase + 0x00U); // EXEONLYRAM
    (void)HWREG(zsbBase + 0x04U); // EXEONLYSECT
    (void)HWREG(zsbBase + 0x08U); // GRABRAM
    (void)HWREG(zsbBase + 0x0CU); // GRABSECT
}

static void Print_Zone1_Status(void)
{
    if (DCSM_getZone1CSMSecurityStatus() == DCSM_STATUS_UNSECURE) {
        Drv_Sci_Log_Print("[DCSM] Zone1 unlocked.\r\n");
    } else {
        Drv_Sci_Log_Print("[DCSM] Zone1 secure.\r\n");
    }
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

    ProductModule_Init();
    Drv_Sci_Log_Print("[ex04] KEY toggles Zone1 lock/unlock; module always runs.\r\n");
    Print_Zone1_Status();

    while (1) {
        Delay_Ms(250U);
        Drv_Led_Toggle();

        g_module_input = (g_module_input % 9U) + 1U;
        g_module_output = ProductModule_Process(g_module_input);
        g_app_work_read = App_Read_Module_Work();
        Print_Module_Result();

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

