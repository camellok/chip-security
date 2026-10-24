/***************************************************************
 * Copyright (c) 2019-2026, Beijing Haawking Technology Co., Ltd 
 *
 * Author: Silin Luo 
 * Email : silin.luo@mail.haawking.com 
 * File  : Drv_Key.h 
 * Description: 
 ***************************************************************/
#ifndef __DRV_KEY_H_
#define __DRV_KEY_H_

//**************************************************************
// Includes
//**************************************************************
#include "hx_fintdiv.h"
#include "driverlib.h"
#include "board.h"

//**************************************************************
// Macro 
//**************************************************************
#define DRV_KEY_PIN	myGPIO1

//**************************************************************
// Function declarations
//**************************************************************

/**
 * @description: Getting the key state.
 * @return {Uint8} Key state
 */
Uint8 Drv_Get_Key_Value(void);

#endif
