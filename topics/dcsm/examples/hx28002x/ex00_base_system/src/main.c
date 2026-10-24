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



int main(void)
{
    Device_init();
    Device_initGPIO();
    Interrupt_initModule();
    Interrupt_initVectorTable();
    Board_init();
    EINT;
    ERTM;

    Drv_Sci_Log_Print("[ex00] Module: output = input * 3 + 7.\r\n");

    while (1) {
        Delay_Ms(250U);
        Drv_Led_Toggle();

        g_module_input = (g_module_input % 9U) + 1U;
        g_module_output = ProductModule_Process(g_module_input);
        Print_Module_Result();

        if (Key_Released()) {
            Drv_Sci_Log_Print("[KEY] released.\r\n");
        }
    }
}

