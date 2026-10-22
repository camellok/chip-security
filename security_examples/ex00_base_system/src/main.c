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
Uint32 g_delay_ms = 500;
volatile Uint16 g_epwm_cmp_value = 0;
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

    Drv_Sci_Log_Print("[DCSM] Zone1 Unsafty.\r\n");

    while (1) {
        // 1. LED blinking.
        Delay_Ms(g_delay_ms);
        Drv_Led_Toggle();
        Delay_Ms(g_delay_ms);
        Drv_Led_Toggle();

        // 2. Get algorithm result.
        g_epwm_cmp_value = (Uint16)(spwm_duty_calc() * 1600);

        // 3. Polling key state.
        if (Drv_Get_Key_Value() == 0) {
            // waiting for unpress.
            while (Drv_Get_Key_Value() == 0)
                ;

            Drv_Sci_Log_Print("[Key] Press.\r\n");

            // 4. Set the led blinking to 'fast mode'.
            g_delay_ms = 250;
        }
    }

    return 0;
}

//
// End of File
//

