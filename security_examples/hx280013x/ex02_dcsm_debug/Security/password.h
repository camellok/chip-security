/* Public training key for Zone1 ZSB1; never a production credential. */
#ifndef PASSWORD_H
#define PASSWORD_H
#include "driverlib.h"
#include "password_values.h"
#if (DEMO_Z1_KEY1 & 0x4D7FFFFFUL) != DEMO_Z1_KEY1
#error "ZSB1 key conflicts with the documented factory CSMPSWD1 bits"
#endif
static const DCSM_CSMPasswordKey s_z1_demo_key =
{
    .csmKey0 = DEMO_Z1_KEY0,
    .csmKey1 = DEMO_Z1_KEY1,
    .csmKey2 = DEMO_Z1_KEY2,
    .csmKey3 = DEMO_Z1_KEY3
};
#endif
