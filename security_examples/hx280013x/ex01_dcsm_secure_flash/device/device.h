//#############################################################################
//
// FILE:   device.h
//
// TITLE:  Device setup for examples.
//
//#############################################################################

#ifndef __DEVICE_H__
#define __DEVICE_H__

//
// Included Files
//
#include "driverlib.h"
#include <stddef.h>
//
// Check for invalid compile flags
//
#if defined(__HXS320C28XX_FPU64__)
#error "Invalid FPU Configuration"
#endif
#if defined(__HXS320C28XX_TMU1__)
#error "Invalid TMU Configuration"
#endif

//*****************************************************************************
//
// Defines for pin numbers
//
//*****************************************************************************
#ifdef _LAUNCHBOARD_F2800137
//
// LaunchPad
//
//
// LEDs
//
#define DEVICE_GPIO_PIN_LED1        20U             // GPIO number for LED4
#define DEVICE_GPIO_PIN_LED2        22U             // GPIO number for LED5
#define DEVICE_GPIO_CFG_LED1        GPIO_20_GPIO20  // "pinConfig" for LED4
#define DEVICE_GPIO_CFG_LED2        GPIO_22_GPIO22  // "pinConfig" for LED5

//
// SCI for USB-to-UART adapter on XDS110 chip
//
#define DEVICE_GPIO_PIN_SCIRXDA     28U             // GPIO number for SCIA RX
#define DEVICE_GPIO_PIN_SCITXDA     29U             // GPIO number for SCIA TX
#define DEVICE_GPIO_CFG_SCIRXDA     GPIO_28_SCIA_RX // "pinConfig" for SCIA RX
#define DEVICE_GPIO_CFG_SCITXDA     GPIO_29_SCIA_TX // "pinConfig" for SCIA TX

//
// I2CA
//
#define DEVICE_GPIO_PIN_SDAA        32U  // GPIO number for I2C SDAA
#define DEVICE_GPIO_PIN_SCLA        33U  // GPIO number for I2C SCLA
#define DEVICE_GPIO_CFG_SDAA        GPIO_32_I2CA_SDA  // "pinConfig" for I2C SDAA
#define DEVICE_GPIO_CFG_SCLA        GPIO_33_I2CA_SCL  // "pinConfig" for I2C SCLA

#define DEVICE_GPIO_PIN_SDAA_2      19U  // GPIO number for I2C SDAA
#define DEVICE_GPIO_PIN_SCLA_2      18U  // GPIO number for I2C SCLA
#define DEVICE_GPIO_CFG_SDAA_2      GPIO_19_I2CA_SDA  // "pinConfig" for I2C SDAA
#define DEVICE_GPIO_CFG_SCLA_2      GPIO_18_I2CA_SCL  // "pinConfig" for I2C SCLA

//
// SPIA
//
#define DEVICE_GPIO_PIN_SPICLKA     9U   // GPIO number for SPI CLKA
#define DEVICE_GPIO_PIN_SPISIMOA    8U   // GPIO number for SPI SIMOA
#define DEVICE_GPIO_PIN_SPISOMIA    17U  // GPIO number for SPI SOMIA
#define DEVICE_GPIO_PIN_SPISTEA     5U   // GPIO number for SPI STEA
#define DEVICE_GPIO_CFG_SPICLKA     GPIO_9_SPIA_CLK    // "pinConfig" for SPI CLKA
#define DEVICE_GPIO_CFG_SPISIMOA    GPIO_8_SPIA_SIMO   // "pinConfig" for SPI SIMOA
#define DEVICE_GPIO_CFG_SPISOMIA    GPIO_17_SPIA_SOMI  // "pinConfig" for SPI SOMIA
#define DEVICE_GPIO_CFG_SPISTEA     GPIO_5_SPIA_STE    // "pinConfig" for SPI STEA

//
// eQEP1
//
#define DEVICE_GPIO_PIN_EQEP1A      40U  // GPIO number for EQEP 1A
#define DEVICE_GPIO_PIN_EQEP1B      41U  // GPIO number for EQEP 1B
#define DEVICE_GPIO_PIN_EQEP1I      39U  // GPIO number for EQEP 1I
#define DEVICE_GPIO_CFG_EQEP1A      GPIO_40_EQEP1_A  // "pinConfig" for EQEP 1A
#define DEVICE_GPIO_CFG_EQEP1B      GPIO_41_EQEP1_B  // "pinConfig" for EQEP 1B
#define DEVICE_GPIO_CFG_EQEP1I      GPIO_39_EQEP1_INDEX  // "pinConfig" for EQEP 1I

#else
//
// ControlCARD
//

//
// LEDs
//
#define DEVICE_GPIO_PIN_LED1        24U             // GPIO number for LED1
#define DEVICE_GPIO_PIN_LED2        39U             // GPIO number for LED2
#define DEVICE_GPIO_CFG_LED1        GPIO_24_GPIO24  // "pinConfig" for LED1
#define DEVICE_GPIO_CFG_LED2        GPIO_39_GPIO39  // "pinConfig" for LED2

//
// SCI for USB-to-UART adapter on FTDI chip
//
#define DEVICE_GPIO_PIN_SCIRXDA     28U             // GPIO number for SCI RX
#define DEVICE_GPIO_PIN_SCITXDA     29U             // GPIO number for SCI TX
#define DEVICE_GPIO_CFG_SCIRXDA     GPIO_28_SCIA_RX // "pinConfig" for SCI RX
#define DEVICE_GPIO_CFG_SCITXDA     GPIO_29_SCIA_TX // "pinConfig" for SCI TX

//
// I2C
//
#define DEVICE_GPIO_PIN_SDAA        32U  // GPIO number for I2C SDAA
#define DEVICE_GPIO_PIN_SCLA        33U  // GPIO number for I2C SCLA
#define DEVICE_GPIO_CFG_SDAA        GPIO_32_I2CA_SDA  // "pinConfig" for I2C SDAA
#define DEVICE_GPIO_CFG_SCLA        GPIO_33_I2CA_SCL  // "pinConfig" for I2C SCLA

#endif

//*****************************************************************************
//
// Defines related to clock configuration
//
//*****************************************************************************
//
// To use INTOSC as the clock source, comment the #define USE_PLL_SRC_XTAL,
// and uncomment the #define USE_PLL_SRC_INTOSC
//
#define USE_PLL_SRC_XTAL
#define USE_PLL_SRC_INTOSC

#if defined(USE_PLL_SRC_INTOSC)
//
// 10MHz INTOSC on the device is used as the PLL source.
// For use with SysCtl_getClock().
//
#define DEVICE_OSCSRC_FREQ          10000000U
//
// Define to pass to SysCtl_setClock(). Will configure the clock as follows:
// PLLSYSCLK = 10MHz (SYSCTL_OSCSRC_OSC2) * 16 (IMULT) / (1 (REFDIV) * 1 (ODIV) * 1(SYSDIV))
//

#define DEVICE_SETCLOCK_CFG          (SYSCTL_OSCSRC_OSC2| SYSCTL_IMULT(16) | \
                                      SYSCTL_REFDIV(1) | SYSCTL_ODIV(1) |SYSCTL_VCO(2) |\
                                      SYSCTL_SYSDIV(1) | SYSCTL_PLL_ENABLE | \
                                      SYSCTL_DCC_BASE_0)

//
// 160MHz SYSCLK frequency based on the above DEVICE_SETCLOCK_CFG. Update the
// code below if a different clock configuration is used!
//
#define DEVICE_SYSCLK_FREQ          ((DEVICE_OSCSRC_FREQ * 16) / (1 * 1 * 1))

#elif defined(USE_PLL_SRC_XTAL)
//
// 20MHz XTAL on controlCARD is used as the PLL source.
// For use with SysCtl_getClock().
//
#define DEVICE_OSCSRC_FREQ          20000000U
//
// Define to pass to SysCtl_setClock(). Will configure the clock as follows:
// PLLSYSCLK = 20MHz (SYSCTL_OSCSRC_OSC2) * 32 (IMULT) / (2 (REFDIV) * 2 (ODIV) * 1(SYSDIV))
//

#define DEVICE_SETCLOCK_CFG          (SYSCTL_OSCSRC_XTAL| SYSCTL_IMULT(32) | \
                                      SYSCTL_REFDIV(2) | SYSCTL_ODIV(2) |SYSCTL_VCO(5) |\
                                      SYSCTL_SYSDIV(1) | SYSCTL_PLL_ENABLE | \
                                      SYSCTL_DCC_BASE_0)

//
// 160MHz SYSCLK frequency based on the above DEVICE_SETCLOCK_CFG. Update the
// code below if a different clock configuration is used!
//
#define DEVICE_SYSCLK_FREQ          ((DEVICE_OSCSRC_FREQ * 32) / (2 * 2 * 1))
#endif
//
// 25MHz LSPCLK frequency based on the above DEVICE_SYSCLK_FREQ and a default
// low speed peripheral clock divider of 4. Update the code below if a
// different LSPCLK divider is used!
//
#define DEVICE_LSPCLK_FREQ          (DEVICE_SYSCLK_FREQ / 4)

//*****************************************************************************
//
// Macro to call SysCtl_delay() to achieve a delay in microseconds. The macro
// will convert the desired delay in microseconds to the count value expected
// by the function. \b x is the number of microseconds to delay.
//
//*****************************************************************************
#define    DEVICE_DELAY_US(x)     SysCtl_delay((long double)(x *(long double)(DEVICE_SYSCLK_FREQ/1000000.0L)- 15.0L)) // reference range x: 16 ~ 26214

//*****************************************************************************
//
// Defines, Globals, and Header Includes related to Flash Support
//
//*****************************************************************************

#define DEVICE_FLASH_WAITSTATES 5

//*****************************************************************************
//
// Function Prototypes
//
//*****************************************************************************
//*****************************************************************************
//
//! \addtogroup device_api
//! @{
//
//*****************************************************************************

//*****************************************************************************
//
//! @brief Function to initialize the device. Primarily initializes system
//!  control to aknown state by disabling the watchdog, setting up the
//!  SYSCLKOUT frequency, and enabling the clocks to the peripherals.
//!
//! \param None.
//! \return None.
//
//*****************************************************************************
extern void Device_init(void);

//*****************************************************************************
//
// Function to verify the XTAL frequency stability
// The function return true if the the actual XTAL frequency stability status
//
// Note that this function assumes that the PLL is not already configured and
// hence uses SysClk freq = 10MHz for DCC calculation
//
//*****************************************************************************
extern void Device_verifyXTALFreqStability(void);

//*****************************************************************************
//!
//!
//! @brief Function to turn on all peripherals, enabling reads and writes to the
//! peripherals' registers.
//!
//! Note that to reduce power, unused peripherals should be disabled.
//!
//! @param None
//! @return None
//
//*****************************************************************************
extern void Device_enableAllPeripherals(void);

//*****************************************************************************
//!
//!
//! @brief Function to disable pin locks on GPIOs.
//!
//! @param None
//! @return None
//
//*****************************************************************************
extern void Device_initGPIO(void);

//*****************************************************************************
//!
//! @brief Error handling function to be called when an ASSERT is violated
//!
//! @param *filename File name in which the error has occurred
//! @param line Line number within the file
//! @return None
//
//*****************************************************************************
extern void __error__(char *filename, uint32_t line);

extern uint32_t read_reg32(uintptr_t addr);
extern uint32_t read_reg16(uintptr_t addr);
extern uint8_t read_reg8(uintptr_t addr);

extern void write_reg32(uintptr_t addr,uint32_t val);
extern void write_reg16(uintptr_t addr,uint16_t val);
extern void write_reg8(uintptr_t addr,uint8_t val);

//*****************************************************************************
//
// Close the Doxygen group.
//! @}
//
//*****************************************************************************

#endif // __DEVICE_H__
