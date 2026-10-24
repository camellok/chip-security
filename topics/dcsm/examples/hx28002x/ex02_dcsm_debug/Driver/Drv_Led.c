/***************************************************************
 * Copyright (c) 2019-2026, Beijing Haawking Technology Co., Ltd 
 *
 * Author: Silin Luo 
 * Email : silin.luo@mail.haawking.com 
 * File  : Drv_Led.c 
 * Description: 
 ***************************************************************/

//**************************************************************
// Includes
//**************************************************************
#include "Drv_Led.h"

//**************************************************************
// Function definitions
//**************************************************************

// Drv_Led_On
void Drv_Led_On()
{
	GPIO_writePin(DRV_LED_PIN, 0);
}

// Drv_Led_Off
void Drv_Led_Off()
{
	GPIO_writePin(DRV_LED_PIN, 1);
}

// Drv_Led_Toggle
void Drv_Led_Toggle()
{
    GPIO_togglePin(DRV_LED_PIN);
}
