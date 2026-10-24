/* Core DSC2800137PM V1.0 Beta1 resources. */
#ifndef BOARD_H
#define BOARD_H
#include "driverlib.h"
#include "device.h"
#define myGPIO0 20U
#define myGPIO1 1U
#define BOARD_LED2_GPIO 22U
#define mySCI0_BASE SCIA_BASE
#define mySCI0_BAUDRATE 9600U
void Board_init(void);
#endif
