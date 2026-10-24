/***************************************************************
 * Copyright (c) 2019-2026, Beijing Haawking Technology Co., Ltd 
 *
 * Author: Silin Luo 
 * Email : silin.luo@mail.haawking.com 
 * File  : password.h 
 * Description: 
 ***************************************************************/

#ifndef __PASSWORD_H_
#define __PASSWORD_H_

#include "driverlib.h"

// Note1: Demo password is for training only.
//        Production password should not be stored as plaintext in bootloader or application firmware.
static const DCSM_CSMPasswordKey s_z1_demo_key =
{
    .csmKey0 = 0x11111111UL,
    .csmKey1 = 0x02222222UL,
    .csmKey2 = 0x33333333UL,
    .csmKey3 = 0x44444444UL
};

#endif
