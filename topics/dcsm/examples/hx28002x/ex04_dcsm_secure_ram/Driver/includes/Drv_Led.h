/***************************************************************
 * Copyright (c) 2019-2026, Beijing Haawking Technology Co., Ltd 
 *
 * Author: Silin Luo 
 * Email : silin.luo@mail.haawking.com 
 * File  : Drv_Led.h 
 * Description: 
 ***************************************************************/
#ifndef __DRV_LED_H_
#define __DRV_LED_H_

//**************************************************************
// Includes
//**************************************************************
#include "hx_fintdiv.h"
#include "driverlib.h"
#include "board.h"

//**************************************************************
// Macros
//**************************************************************
#define DRV_LED_PIN  myGPIO0

//**************************************************************
// Function declarations
//**************************************************************

/**
 * @description: Turn on the led.
 * @return {none}
 */
void Drv_Led_On();

/**
 * @description: Turn off the led.
 * @return {none}
 */
void Drv_Led_Off();

/**
 * @description: Toggle the led state.
 * @return {none}
 */
void Drv_Led_Toggle();

#endif