/* Copyright (c) 2019-2026, Beijing Haawking Technology Co., Ltd. */
#include "board.h"

void Board_init(void)
{
    // Both LEDs are active low. Leave LED3 off; LED2 is the heartbeat.
    GPIO_writePin(myGPIO0, 1U);
    GPIO_writePin(BOARD_LED2_GPIO, 1U);
    GPIO_setAnalogMode(myGPIO0, GPIO_ANALOG_DISABLED);
    GPIO_setPinConfig(GPIO_20_GPIO20);
    GPIO_setPinConfig(GPIO_22_GPIO22);
    GPIO_setPadConfig(myGPIO0, GPIO_PIN_TYPE_STD);
    GPIO_setPadConfig(BOARD_LED2_GPIO, GPIO_PIN_TYPE_STD);
    GPIO_setDirectionMode(myGPIO0, GPIO_DIR_MODE_OUT);
    GPIO_setDirectionMode(BOARD_LED2_GPIO, GPIO_DIR_MODE_OUT);

    // SW2: R21 fitted to GPIO1, R20 (GPIO7) marked NC in the schematic.
    GPIO_setPinConfig(GPIO_1_GPIO1);
    GPIO_setPadConfig(myGPIO1, GPIO_PIN_TYPE_PULLUP);
    GPIO_setQualificationMode(myGPIO1, GPIO_QUAL_SYNC);
    GPIO_setDirectionMode(myGPIO1, GPIO_DIR_MODE_IN);

    GPIO_setAnalogMode(28U, GPIO_ANALOG_DISABLED);
    GPIO_setPinConfig(GPIO_28_SCIA_RX);
    GPIO_setPinConfig(GPIO_29_SCIA_TX);
    GPIO_setPadConfig(28U, GPIO_PIN_TYPE_PULLUP);
    GPIO_setPadConfig(29U, GPIO_PIN_TYPE_STD);
    GPIO_setQualificationMode(28U, GPIO_QUAL_ASYNC);
    GPIO_setQualificationMode(29U, GPIO_QUAL_ASYNC);

    SCI_disableModule(mySCI0_BASE);
    SCI_setConfig(mySCI0_BASE, DEVICE_LSPCLK_FREQ, mySCI0_BAUDRATE,
                  SCI_CONFIG_WLEN_8 | SCI_CONFIG_STOP_ONE | SCI_CONFIG_PAR_NONE);
    SCI_disableLoopback(mySCI0_BASE);
    SCI_resetChannels(mySCI0_BASE);
    SCI_resetTxFIFO(mySCI0_BASE);
    SCI_resetRxFIFO(mySCI0_BASE);
    SCI_clearOverflowStatus(mySCI0_BASE);
    SCI_clearInterruptStatus(mySCI0_BASE, SCI_INT_RXFF | SCI_INT_TXFF);
    SCI_enableFIFO(mySCI0_BASE);
    SCI_performSoftwareReset(mySCI0_BASE);
    SCI_enableModule(mySCI0_BASE);
}
