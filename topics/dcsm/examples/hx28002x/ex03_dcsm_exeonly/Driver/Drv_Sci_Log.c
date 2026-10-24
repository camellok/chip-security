/***************************************************************
 * Copyright (c) 2019-2026, Beijing Haawking Technology Co., Ltd
 *
 * Author: Silin Luo
 * Email : silin.luo@mail.haawking.com
 * File  : Drv_Sci.c
 * Description:
 ***************************************************************/

//**************************************************************
// Includes
//**************************************************************
#include "Drv_Sci_Log.h"

//**************************************************************
// Functions definitions
//**************************************************************

// Drv_Sci_Log_Print
void Drv_Sci_Log_Print(const char* str)
{
    SCI_writeCharArray(DRV_SCI_LOG_BASE, (Uint8*)str, strlen(str));
}
