/***************************************************************
 * Copyright (c) 2019-2026, Beijing Haawking Technology Co., Ltd 
 *
 * Author: Silin Luo 
 * Email : silin.luo@mail.haawking.com 
 * File  : spwm.h 
 * Description: 
 ***************************************************************/

#ifndef __SPWM_H_
#define __SPWM_H_

//**************************************************************
// Includes 
//**************************************************************
#include "hx_fintdiv.h"

//**************************************************************
// Macro 
//**************************************************************
#define SPWM_STEP	1

//**************************************************************
// Function declarations 
//**************************************************************

/**
 * @description: Calculating the duty of the spwm.
 * @return {float} Duty of the spwm 
 */
float spwm_duty_calc();

#endif
