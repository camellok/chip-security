/***************************************************************
 * Copyright (c) 2019-2026, Beijing Haawking Technology Co., Ltd 
 *
 * Author: Silin Luo 
 * Email : silin.luo@mail.haawking.com 
 * File  : Drv_Key.c 
 * Description: 
 ***************************************************************/

//**************************************************************
// Includes
//**************************************************************
#include "Drv_Key.h"

//**************************************************************
// Function definitions
//**************************************************************

// Drv_Get_Key_Value
Uint8 Drv_Get_Key_Value(void)
{
    return GPIO_readPin(DRV_KEY_PIN);
}
