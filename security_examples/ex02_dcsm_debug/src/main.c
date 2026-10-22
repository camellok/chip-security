/***************************************************************
 * Copyright (c) 2019-2026, Beijing Haawking Technology Co., Ltd
 *
 * Author: Silin Luo
 * Email : silin.luo@mail.haawking.com
 * File  : main.c
 * Description:
 ***************************************************************/

 //**************************************************************
 // Includes
 //**************************************************************
#include <syscalls.h>
#include "IQmathLib.h"
#include "hx_intrinsics.h"
#include "driverlib.h"
#include "device.h"
#include "hx_fintdiv.h"
// Sysconfig:
#include "board.h"
// Drivers:
#include "Drv_Led.h"
#include "Drv_Key.h"
#include "Drv_Sci_Log.h"
// algorithms:
#include "spwm.h"
// security:
#include "password.h"

//**************************************************************
// Function definitions
//**************************************************************
/**
 * @description: delay fixed milliseconds.
 * @param {Uint32} delay N ms
 * @return {*}
 */
void Delay_Ms(Uint32 delay_ms)
{
	Uint32 i;
	for(i = 0; i < delay_ms; i++){
		DEVICE_DELAY_US(1000);
	}
}

//
// Main
//
volatile Uint16 g_epwm_cmp_value = 0;

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

    //
    // Initialize device clock and peripherals
    //
    Device_init();

    //
    // Disable pin locks and enable internal pull-ups.
    //
    Device_initGPIO();

    //
    // Initialize PIE and clear PIE registers. Disables CPU interrupts.
    //
    Interrupt_initModule();

    //
    // Initialize the PIE vector table with pointers to the shell Interrupt
    // Service Routines (ISR).
    //
    Interrupt_initVectorTable();

    //
    // PinMux and Peripheral Initialization
    //
    Board_init();

    //
    // Driver Initialization
    //

    //
    // Enable Global Interrupt (INTM) and real time interrupt (DBGM)
    //
    EINT;
    ERTM;

    //
    // Log status of the zone1.
    //
    Drv_Sci_Log_Print("[ex02] KEY toggles Zone1 lock/unlock.\r\n");
    Print_Zone1_Status();


    while (1) {
        // APP heartbeat remains active in both security states.
        Delay_Ms(250);
        Drv_Led_Toggle();

        // Stay in unsecured APP code while locked for the debug comparison.
        if (DCSM_getZone1CSMSecurityStatus() == DCSM_STATUS_UNSECURE) {
            g_epwm_cmp_value = (Uint16)(spwm_duty_calc() * 1600);
        }

        // Debounce and perform one operation after the key is released.
        if (Drv_Get_Key_Value() == 0) {
            Delay_Ms(20);
            if (Drv_Get_Key_Value() == 0) {
                while (Drv_Get_Key_Value() == 0) {
                }
                Delay_Ms(20);

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

    return 0;
}

//
// End of File
//

