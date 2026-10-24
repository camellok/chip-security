/***************************************************************
 * Copyright (c) 2019-2026, Beijing Haawking Technology Co., Ltd
 *
 * Author: Silin Luo
 * Email : silin.luo@mail.haawking.com
 * File  : Drv_Sci.h
 * Description:
 ***************************************************************/
#ifndef __DRV_SCI_LOG_H_
#define __DRV_SCI_LOG_H_

//**************************************************************
// Includes
//**************************************************************
#include "driverlib.h"
#include "board.h"

//**************************************************************
// Macros
//**************************************************************
#define DRV_SCI_LOG_BASE mySCI0_BASE

//**************************************************************
// Functions declarations
//**************************************************************

/**
 * @description: Print log through SCI.
 * @param {const char*} str: Log comments.
 * @return {none}
 */
void Drv_Sci_Log_Print(const char* str);


#endif
