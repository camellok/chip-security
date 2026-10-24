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
void Drv_Led_On(void);

/**
 * @description: Turn off the led.
 * @return {none}
 */
void Drv_Led_Off(void);

/**
 * @description: Toggle the led state.
 * @return {none}
 */
void Drv_Led_Toggle(void);

#endif