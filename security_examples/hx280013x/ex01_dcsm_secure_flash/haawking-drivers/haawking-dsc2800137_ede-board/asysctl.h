//###########################################################################
//
// FILE:   asysctl.h
//
// TITLE:  H28x driver for Analog System Control.
//
//###########################################################################

#ifndef ASYSCTL_H
#define ASYSCTL_H

//*****************************************************************************
//
// If building with a C++ compiler, make all of the definitions in this header
// have a C binding.
//
//*****************************************************************************
#ifdef __cplusplus
extern "C"
{
#endif

//*****************************************************************************
//
//! \addtogroup asysctl_api ASysCtl
//! @{
//
//*****************************************************************************

#include <stdint.h>
#include <stdbool.h>
#include "inc/hw_asysctl.h"
#include "inc/hw_adc.h"
#include "inc/hw_memmap.h"
#include "inc/hw_types.h"
#include "debug.h"
#include "cpu.h"

//*****************************************************************************
//
// Defines used for setting AnalogReference functions.
// ASysCtl_setAnalogReferenceExternal()
// ASysCtl_setAnalogReference2P5()
// ASysCtl_setAnalogReferenceVdda()
//
//*****************************************************************************
#define ASYSCTL_VREFHIA  0x1U //!< VREFHIA
#define ASYSCTL_VREFHIC  0x4U //!< VREFHIC

//*****************************************************************************
//
// ASysCtl_CMPHNMuxSelect used for function ASysCtl_selectCMPHNMuxValue().
//
//*****************************************************************************
typedef enum
{
	ASYSCTL_CMPHNMUX_SELECT_1 = 0U, //!< CMPHNMUX select 1
	ASYSCTL_CMPHNMUX_SELECT_3 = 6U, //!< CMPHNMUX select 3
} ASysCtl_CMPHNMuxSelect;

//*****************************************************************************
//
// ASysCtl_CMPLNMuxSelect used for function ASysCtl_selectCMPLNMuxValue().
//
//*****************************************************************************
typedef enum
{
	ASYSCTL_CMPLNMUX_SELECT_1 = 0U, //!< CMPLNMUX select 1
	ASYSCTL_CMPLNMUX_SELECT_3 = 6U, //!< CMPLNMUX select 3
} ASysCtl_CMPLNMuxSelect;

//*****************************************************************************
//
//! ASysCtl_CMPHPMuxSelect used for function ASysCtl_selectCMPHPMux().
//
//*****************************************************************************
typedef enum
{
    ASYSCTL_CMPHPMUX_SELECT_1 = 0U, //!< CMPHPMUX select 1
    ASYSCTL_CMPHPMUX_SELECT_3 = 8U, //!< CMPHPMUX select 3
} ASysCtl_CMPHPMuxSelect;

//*****************************************************************************
//
//! ASysCtl_CMPLPMuxSelect used for function ASysCtl_selectCMPLPMux().
//
//*****************************************************************************
typedef enum
{
    ASYSCTL_CMPLPMUX_SELECT_1 = 0U, //!< CMPLPMUX select 1
    ASYSCTL_CMPLPMUX_SELECT_3 = 8U, //!< CMPLPMUX select 3
} ASysCtl_CMPLPMuxSelect;

//*****************************************************************************
//
// Prototypes for the APIs.
//
//*****************************************************************************

//*****************************************************************************
//
//! Enable temperature sensor.
//!
//! This function enables the temperature sensor output to the ADC.
//!
//! \return None.
//
//*****************************************************************************
static __always_inline void
ASysCtl_enableTemperatureSensor(void)
{
    EALLOW;

    //
    // Set the temperature sensor enable bit.
    //
    HWREG(ANALOGSUBSYS_BASE + ASYSCTL_O_TSNSCTL) |= ASYSCTL_TSNSCTL_TSNSCEN;

    EDIS;
}

//*****************************************************************************
//
//! Disable temperature sensor.
//!
//! This function disables the temperature sensor output to the ADC.
//!
//! \return None.
//
//*****************************************************************************
static __always_inline void
ASysCtl_disableTemperatureSensor(void)
{
    EALLOW;

    //
    // Clear the temperature sensor enable bit.
    //
    HWREG(ANALOGSUBSYS_BASE + ASYSCTL_O_TSNSCTL) &= ~(ASYSCTL_TSNSCTL_TSNSCEN);

    EDIS;
}

//*****************************************************************************
//
//! Set the analog voltage reference selection to internal.
//!
//! \param reference is the analog reference.
//!
//! The parameter \e reference can be a combination of the following values:
//!
//! - \b ASYSCTL_VREFHI
//!
//! \note Internal reference mode is not available for packages lacking VREFHI
//! and VREFLO pins. Please see device datasheet for packages with VREFHI and
//! VREFLO pins available.
//!
//! \return None.
//
//*****************************************************************************
static __always_inline void
ASysCtl_setAnalogReferenceInternal(uint32_t reference)
{
    ASSERT((reference & (
	                         ASYSCTL_VREFHIA |
							 ASYSCTL_VREFHIC
	                        )) == reference);

	EALLOW;

	//
	// Write selection to the Analog Internal 2.5V Reference Select bit.
	//
	HWREG(ANALOGSUBSYS_BASE + ASYSCTL_O_PMULDOCTL) = 0;
	HWREG(ANALOGSUBSYS_BASE + ASYSCTL_O_ANAREFCTL) = ASYSCTL_ANAREFCTL_ADCAVREFHIEN \
													| ASYSCTL_ANAREFCTL_ADCCVREFHIEN;
	HWREG(ADCACTL3_BASE + ADC_O_CTL3) |= ADC_CTL3_EN_VREFBI;
	HWREG(ADCACTL3_BASE + ADC_O_CTL3) = ((HWREG(ADCACTL3_BASE + ADC_O_CTL3) & ~ADC_CTL3_SEL_VREFBI_M) \
													| (0x2 << ADC_CTL3_SEL_VREFBI_S));
	HWREG(ADCCCTL3_BASE + ADC_O_CTL3) |= ADC_CTL3_EN_VREFBI;
	HWREG(ADCCCTL3_BASE + ADC_O_CTL3) = ((HWREG(ADCCCTL3_BASE + ADC_O_CTL3) & ~ADC_CTL3_SEL_VREFBI_M) \
													| (0x2 << ADC_CTL3_SEL_VREFBI_S));

	EDIS;
}

//*****************************************************************************
//
//! Set the analog voltage reference selection to external.
//!
//! \param reference is the analog reference.
//!
//! The parameter \e reference can be a combination of the following values:
//!
//! - \b ASYSCTL_VREFHI
//!
//! \return None.
//
//*****************************************************************************
static __always_inline void
ASysCtl_setAnalogReferenceExternal(uint32_t reference)
{
    ASSERT((reference & (
                         ASYSCTL_VREFHIA |
						 ASYSCTL_VREFHIC
                        )) == reference);

    EALLOW;

    //
	// Write selection to the Analog External Reference Select bit.
	//
    HWREG(ANALOGSUBSYS_BASE + ASYSCTL_O_PMULDOCTL) = 0;
    HWREG(ANALOGSUBSYS_BASE + ASYSCTL_O_ANAREFCTL) = 0;
    HWREG(ADCACTL3_BASE + ADC_O_CTL3) |= ADC_CTL3_EN_VREFBI;
	HWREG(ADCCCTL3_BASE + ADC_O_CTL3) |= ADC_CTL3_EN_VREFBI;

    EDIS;
}
//*****************************************************************************
//
//! Set the internal analog voltage reference selection to 2.5V.
//!
//! \param reference is the analog reference.
//!
//! The parameter \e reference can be a combination of the following values:
//!
//! - \b ASYSCTL_VREFHI
//!
//! \return None.
//
//*****************************************************************************
static __always_inline void ASysCtl_setAnalogReference2P5(uint32_t reference)
{
	ASSERT((reference & (
	                         ASYSCTL_VREFHIA |
							 ASYSCTL_VREFHIC
	                        )) == reference);

	EALLOW;

	//
	// Write selection to the Analog Internal 2.5V Reference Select bit.
	//
	HWREG(ANALOGSUBSYS_BASE + ASYSCTL_O_PMULDOCTL) = 0;
	HWREG(ANALOGSUBSYS_BASE + ASYSCTL_O_ANAREFCTL) = ASYSCTL_ANAREFCTL_ADCAVREFHIEN \
													| ASYSCTL_ANAREFCTL_ADCCVREFHIEN;
	HWREG(ADCACTL3_BASE + ADC_O_CTL3) |= ADC_CTL3_EN_VREFBI;
	HWREG(ADCACTL3_BASE + ADC_O_CTL3) = ((HWREG(ADCACTL3_BASE + ADC_O_CTL3) & ~ADC_CTL3_SEL_VREFBI_M) \
													| (0x2 << ADC_CTL3_SEL_VREFBI_S));
	HWREG(ADCCCTL3_BASE + ADC_O_CTL3) |= ADC_CTL3_EN_VREFBI;
	HWREG(ADCCCTL3_BASE + ADC_O_CTL3) = ((HWREG(ADCCCTL3_BASE + ADC_O_CTL3) & ~ADC_CTL3_SEL_VREFBI_M) \
													| (0x2 << ADC_CTL3_SEL_VREFBI_S));

	EDIS;
}

//*****************************************************************************
//
//! Set the internal analog voltage reference selection to VDDA.
//!
//! \param reference is the analog reference.
//!
//! The parameter \e reference can be a combination of the following values:
//!
//! - \b ASYSCTL_VREFHI
//!
//! \return None.
//
//*****************************************************************************
static __always_inline void ASysCtl_setAnalogReferenceVdda(uint32_t reference)
{
    ASSERT((reference & (
                         ASYSCTL_VREFHIA |
						 ASYSCTL_VREFHIC
                        )) == reference);

    EALLOW;

    //
    // Write selection to the Analog Voltage Reference Select bit.
    //
	HWREG(ANALOGSUBSYS_BASE + ASYSCTL_O_PMULDOCTL) = 0;
	HWREG(ANALOGSUBSYS_BASE + ASYSCTL_O_ANAREFCTL) = ASYSCTL_ANAREFCTL_ANAREFAVDDSEL \
												| ASYSCTL_ANAREFCTL_ANAREFCVDDSEL;

    EDIS;
}

//*****************************************************************************
//
//! Select the value for CMPHNMXSEL.
//!
//! \param select is a combination of CMPHNMXSEL values.
//!
//! \return None.
//
//*****************************************************************************
static __always_inline void ASysCtl_selectCMPHNMux(uint32_t select)
{
    ASSERT(((select >> 6U) & 0x7U) <= 5U);
	ASSERT((select & 0x7U) <= 5U);

    EALLOW;

    //
    // Write a select to the mux select.
    //
    HWREG(ANALOGSUBSYS_BASE + ASYSCTL_O_CMPHNMXSEL) = select;

    EDIS;
}

//*****************************************************************************
//
//! Select the value for individual CMPxHNMXSEL.
//!
//! \param select is the CMPxHNMXSEL to be set.
//! \param value is 0, 1, 2, 3, 4, 5.
//!
//! The parameter \e select can be one of the below values:
//!
//! - \b ASYSCTL_CMPHNMUX_SELECT_1
//! - \b ASYSCTL_CMPHNMUX_SELECT_3
//!
//! \return None.
//
//*****************************************************************************
static __always_inline void ASysCtl_selectCMPHNMuxValue(ASysCtl_CMPHNMuxSelect select, uint32_t value)
{
    ASSERT(value <= 5U);

    EALLOW;

    //
    // Write a select to the mux select.
    //
	HWREG(ANALOGSUBSYS_BASE + ASYSCTL_O_CMPHNMXSEL) =
			(HWREG(ANALOGSUBSYS_BASE + ASYSCTL_O_CMPHNMXSEL) &
			~((uint32_t)ASYSCTL_CMPHNMXSEL_CMP1HNMXSEL_M << (uint32_t)select)) |
			(value << (uint32_t)select);

    EDIS;
}

//*****************************************************************************
//
//! Select the value for individual CMPxLNMXSEL.
//!
//! \param select is a combination of CMPLNMXSEL values.
//!
//! \return None.
//
//*****************************************************************************
static __always_inline void ASysCtl_selectCMPLNMux(uint32_t select)
{
    ASSERT(((select >> 6U) & 0x7U) <= 5U);
	ASSERT((select & 0x7U) <= 5U);

    EALLOW;

    //
    // Write a select to the mux select.
    //
    HWREG(ANALOGSUBSYS_BASE + ASYSCTL_O_CMPLNMXSEL) = select;

    EDIS;
}

//*****************************************************************************
//
//! Select the value for CMPLNMXSEL.
//!
//! \param select is the CMPxHNMXSEL to be set.
//! \param value is 0, 1, 2, 3, 4, 5.
//!
//! The parameter \e select can be one of the below values:
//!
//! - \b ASYSCTL_CMPLNMUX_SELECT_1
//! - \b ASYSCTL_CMPLNMUX_SELECT_3
//!
//! \return None.
//
//*****************************************************************************
static __always_inline void ASysCtl_selectCMPLNMuxValue(ASysCtl_CMPLNMuxSelect select, uint32_t value)
{
    ASSERT(value <= 5U);

    EALLOW;

    //
    // Write a select to the mux select.
    //
    HWREG(ANALOGSUBSYS_BASE + ASYSCTL_O_CMPLNMXSEL) =
			(HWREG(ANALOGSUBSYS_BASE + ASYSCTL_O_CMPLNMXSEL) &
			~((uint32_t)ASYSCTL_CMPLNMXSEL_CMP1LNMXSEL_M << (uint32_t)select)) |
			(value << (uint32_t)select);

    EDIS;
}

//*****************************************************************************
//
//! Select the value for CMPHPMXSEL.
//!
//! \param select is of type ASysCtl_CMPHPMuxSelect.
//! \param value is 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10.
//!
//! This function is used to write a value to one mux select at a time.
//! The parameter \e select can be one of the following values:
//!
//! - \b ASYSCTL_CMPHPMUX_SELECT_1
//! - \b ASYSCTL_CMPHPMUX_SELECT_3
//!
//! \return None.
//
//*****************************************************************************
static __always_inline void
ASysCtl_selectCMPHPMux(ASysCtl_CMPHPMuxSelect select, uint32_t value)
{
    ASSERT(value <= 10U);

    EALLOW;

    //
    // Set the value for the appropriate Mux Select.
    //
    HWREG(ANALOGSUBSYS_BASE + ASYSCTL_O_CMPHPMXSEL) =
        (HWREG(ANALOGSUBSYS_BASE + ASYSCTL_O_CMPHPMXSEL) &
        ~((uint32_t)ASYSCTL_CMPHPMXSEL_CMP1HPMXSEL_M << (uint32_t)select)) |
        (value << (uint32_t)select);

    EDIS;
}

//*****************************************************************************
//
//! Select the value for CMPLPMXSEL.
//!
//! \param select is of type ASysCtl_CMPLPMuxSelect.
//! \param value is 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10.
//!
//! This function is used to write a value to one mux select at a time.
//! The parameter \e select can be one of the following values:
//!
//! - \b ASYSCTL_CMPLPMUX_SELECT_1
//! - \b ASYSCTL_CMPLPMUX_SELECT_3
//!
//! \return None.
//
//*****************************************************************************
static __always_inline void
ASysCtl_selectCMPLPMux(ASysCtl_CMPLPMuxSelect select, uint32_t value)
{
    ASSERT(value <= 10U);

    EALLOW;

    //
    // Set the value for the appropriate Mux Select.
    //
    HWREG(ANALOGSUBSYS_BASE + ASYSCTL_O_CMPLPMXSEL) =
        (HWREG(ANALOGSUBSYS_BASE + ASYSCTL_O_CMPLPMXSEL) &
        ~((uint32_t)ASYSCTL_CMPLPMXSEL_CMP1LPMXSEL_M << (uint32_t)select)) |
        (value << (uint32_t)select);

    EDIS;
}

//*****************************************************************************
//
//! Locks the temperature sensor control register.
//!
//! \return None.
//
//*****************************************************************************
static __always_inline void ASysCtl_lockTemperatureSensor(void)
{
    EALLOW;

    //
    // Write a 1 to the lock bit in the LOCK register.
    //
    HWREG(ANALOGSUBSYS_BASE + ASYSCTL_O_LOCK) |= ASYSCTL_LOCK_TSNSCTL;

    EDIS;
}

//*****************************************************************************
//
//! Locks the analog reference control register.
//!
//! \return None.
//
//*****************************************************************************
static __always_inline void ASysCtl_lockANAREF(void)
{
    EALLOW;

    //
    // Write a 1 to the lock bit in the LOCK register.
    //
    HWREG(ANALOGSUBSYS_BASE + ASYSCTL_O_LOCK) |= ASYSCTL_LOCK_ANAREFCTL;

    EDIS;
}

//*****************************************************************************
//
//! Locks the voltage monitor control register.
//!
//! \return None.
//
//*****************************************************************************
static __always_inline void ASysCtl_lockVMON(void)
{
    EALLOW;

    //
    // Write a 1 to the lock bit in the LOCK register.
    //
    HWREG(ANALOGSUBSYS_BASE + ASYSCTL_O_LOCK) |= ASYSCTL_LOCK_VMONCTL;

    EDIS;
}

//*****************************************************************************
//
//! Locks the CMPHPMXSEL control register.
//!
//! \return None.
//
//*****************************************************************************
static __always_inline void ASysCtl_lockCMPHPMux(void)
{
    EALLOW;

    //
    // Write a 1 to the lock bit in the LOCK register.
    //
    HWREG(ANALOGSUBSYS_BASE + ASYSCTL_O_LOCK) |= ASYSCTL_LOCK_CMPHPMXSEL;

    EDIS;
}

//*****************************************************************************
//
//! Locks the CMPLPMXSEL control register.
//!
//! \return None.
//
//*****************************************************************************
static __always_inline void ASysCtl_lockCMPLPMux(void)
{
    EALLOW;

    //
    // Write a 1 to the lock bit in the LOCK register.
    //
    HWREG(ANALOGSUBSYS_BASE + ASYSCTL_O_LOCK) |= ASYSCTL_LOCK_CMPLPMXSEL;

    EDIS;
}

//*****************************************************************************
//
//! Locks the CMPHNMXSEL control register.
//!
//! \return None.
//
//*****************************************************************************
static __always_inline void ASysCtl_lockCMPHNMux(void)
{
    EALLOW;

    //
    // Write a 1 to the lock bit in the LOCK register.
    //
    HWREG(ANALOGSUBSYS_BASE + ASYSCTL_O_LOCK) |= ASYSCTL_LOCK_CMPHNMXSEL;

    EDIS;
}

//*****************************************************************************
//
//! Locks the CMPLNMXSEL control register.
//!
//! \return None.
//
//*****************************************************************************
static __always_inline void ASysCtl_lockCMPLNMux(void)
{
    EALLOW;

    //
    // Write a 1 to the lock bit in the LOCK register.
    //
    HWREG(ANALOGSUBSYS_BASE + ASYSCTL_O_LOCK) |= ASYSCTL_LOCK_CMPLNMXSEL;

    EDIS;
}

//*****************************************************************************
//
//! Locks the VREG control register.
//!
//! \return None.
//
//*****************************************************************************
static __always_inline void ASysCtl_lockVREG(void)
{
    EALLOW;

    //
    // Write a 1 to the lock bit in the LOCK register.
    //
    HWREG(ANALOGSUBSYS_BASE + ASYSCTL_O_LOCK) |= ASYSCTL_LOCK_VREGCTL;

    EDIS;
}

//*****************************************************************************
//
// Close the Doxygen group.
//! @}
//
//*****************************************************************************

//*****************************************************************************
//
// Mark the end of the C bindings section for C++ compilers.
//
//*****************************************************************************
#ifdef __cplusplus
}
#endif

#endif // ASYSCTL_H
