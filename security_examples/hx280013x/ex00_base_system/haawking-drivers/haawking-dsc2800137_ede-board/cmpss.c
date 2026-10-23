//###########################################################################
//
// FILE:   cmpss.c
//
// TITLE:  H28x CMPSS driver.
//
//###########################################################################

#include "cmpss.h"

//*****************************************************************************
//
// CMPSS_configFilterHigh
//
//*****************************************************************************
void
CMPSS_configFilterHigh(uint32_t base, uint32_t samplePrescale,
                       uint32_t sampleWindow, uint32_t threshold)
{
    uint32_t regValue;
    uint32_t ctriphfilctlOffset;
    uint32_t ctriphfilclkctlOffset;

    //
    // Check the arguments.
    //
    ASSERT(CMPSS_isBaseValid(base));
    ASSERT(samplePrescale <= 65535U);
    ASSERT((sampleWindow >= 1U) && (sampleWindow <= 32U));
    ASSERT((threshold - 1U) >= ((sampleWindow - 1U) / 2U));

    //
    // Check cmpss or cmpss_lite
    //
    if(!CMPSS_isLiteBaseValid(base))
    {
    	// cmpss
    	ctriphfilctlOffset = CMPSS_O_CTRIPHFILCTL;
    	ctriphfilclkctlOffset = CMPSS_O_CTRIPHFILCLKCTL;
    }
    else
    {
    	// cmpss_lite
    	ctriphfilctlOffset = CMPSSLITE_O_CTRIPHFILCTL;
    	ctriphfilclkctlOffset = CMPSSLITE_O_CTRIPHFILCLKCTL;
    }

    //
    // Shift the sample window and threshold values into the correct positions
    // and write them to the appropriate register.
    //
    regValue = ((sampleWindow - 1U) << CMPSS_CTRIPHFILCTL_SAMPWIN_S) |
               ((threshold - 1U) << CMPSS_CTRIPHFILCTL_THRESH_S);

    EALLOW;

    HWREG(base + ctriphfilctlOffset) =
        (HWREG(base + ctriphfilctlOffset) &
         ~(CMPSS_CTRIPHFILCTL_SAMPWIN_M | CMPSS_CTRIPHFILCTL_THRESH_M)) |
        regValue;

    //
    // Set the filter sample clock prescale for the high comparator.
    //
    HWREG(base + ctriphfilclkctlOffset) = samplePrescale;

    EDIS;
}

//*****************************************************************************
//
// CMPSS_configFilterLow
//
//*****************************************************************************
void
CMPSS_configFilterLow(uint32_t base, uint32_t samplePrescale,
                      uint32_t sampleWindow, uint32_t threshold)
{
    uint32_t regValue;
    uint32_t ctriplfilctlOffset;
    uint32_t ctriplfilclkctlOffset;

    //
    // Check the arguments.
    //
    ASSERT(CMPSS_isBaseValid(base));
    ASSERT(samplePrescale <= 65535U);
    ASSERT((sampleWindow >= 1U) && (sampleWindow <= 32U));
    ASSERT((threshold - 1U) >= ((sampleWindow - 1U) / 2U));

    //
	// Check cmpss or cmpss_lite
	//
	if(!CMPSS_isLiteBaseValid(base))
	{
		// cmpss
		ctriplfilctlOffset = CMPSS_O_CTRIPLFILCTL;
		ctriplfilclkctlOffset = CMPSS_O_CTRIPLFILCLKCTL;
	}
	else
	{
		// cmpss_lite
		ctriplfilctlOffset = CMPSSLITE_O_CTRIPLFILCTL;
		ctriplfilclkctlOffset = CMPSSLITE_O_CTRIPLFILCLKCTL;
	}

    //
    // Shift the sample window and threshold values into the correct positions
    // and write them to the appropriate register.
    //
    regValue = ((sampleWindow - 1U) << CMPSS_CTRIPLFILCTL_SAMPWIN_S) |
               ((threshold - 1U) << CMPSS_CTRIPLFILCTL_THRESH_S);

    EALLOW;

    HWREG(base + ctriplfilctlOffset) =
        (HWREG(base + ctriplfilctlOffset) &
         ~(CMPSS_CTRIPLFILCTL_SAMPWIN_M | CMPSS_CTRIPLFILCTL_THRESH_M)) |
        regValue;

    //
    // Set the filter sample clock prescale for the low comparator.
    //
    HWREG(base + ctriplfilclkctlOffset) = samplePrescale;

    EDIS;
}

//*****************************************************************************
//
// CMPSS_configLatchOnPWMSYNC
//
//*****************************************************************************
void
CMPSS_configLatchOnPWMSYNC(uint32_t base, bool highEnable, bool lowEnable)
{
    //
    // Check the arguments.
    //
    ASSERT(CMPSS_isBaseValid(base));

    //
    // If the highEnable is true, set the bit that will enable PWMSYNC to reset
    // the high comparator digital filter latch. If not, clear the bit.
    //
    EALLOW;

    if(highEnable)
    {
        HWREG(base + CMPSS_O_COMPSTSCLR) |= CMPSS_COMPSTSCLR_HSYNCCLREN;
    }
    else
    {
        HWREG(base + CMPSS_O_COMPSTSCLR) &= ~CMPSS_COMPSTSCLR_HSYNCCLREN;
    }

    //
    // If the lowEnable is true, set the bit that will enable PWMSYNC to reset
    // the low comparator digital filter latch. If not, clear the bit.
    //
    if(lowEnable)
    {
        HWREG(base + CMPSS_O_COMPSTSCLR) |= CMPSS_COMPSTSCLR_LSYNCCLREN;
    }
    else
    {
        HWREG(base + CMPSS_O_COMPSTSCLR) &= ~CMPSS_COMPSTSCLR_LSYNCCLREN;
    }

    EDIS;
}

//*****************************************************************************
//
// CMPSS_configRamp
//
//*****************************************************************************
void
CMPSS_configRamp(uint32_t base, uint32_t maxRampVal, uint32_t decrementVal,
                 uint32_t delayVal, uint32_t pwmSyncSrc, bool useRampValShdw)
{
    //
    // Check the arguments.
    //
    ASSERT(CMPSS_isBaseValid(base));
    ASSERT(!CMPSS_isLiteBaseValid(base));
    ASSERT(delayVal <= CMPSS_RAMPHDLYS_DELAY_M);
    ASSERT((pwmSyncSrc >= 1U) && (pwmSyncSrc <= 7U));

    EALLOW;

    //
    // Write the ramp generator source to the register
    //
    HWREG(base + CMPSS_O_COMPDACHCTL) =
        (HWREG(base + CMPSS_O_COMPDACHCTL) &
         ~CMPSS_COMPDACHCTL_RAMPSOURCE_M) |
        ((uint32_t)(pwmSyncSrc - 1U) << CMPSS_COMPDACHCTL_RAMPSOURCE_S);

    //
    // Set or clear the bit that determines from where the max ramp value
    // should be loaded.
    //
    if(useRampValShdw)
    {
        HWREG(base + CMPSS_O_COMPDACHCTL) |= CMPSS_COMPDACHCTL_RAMPLOADSEL;
    }
    else
    {
        HWREG(base + CMPSS_O_COMPDACHCTL) &= ~CMPSS_COMPDACHCTL_RAMPLOADSEL;
    }

    EDIS;

    //
    // Write the maximum ramp value to the shadow register.
    //
    HWREG(base + CMPSS_O_RAMPHREFS) = maxRampVal;

    //
    // Write the ramp decrement value to the shadow register.
    //
    HWREG(base + CMPSS_O_RAMPHSTEPVALS) = decrementVal;

    //
    // Write the ramp delay value to the shadow register.
    //
    HWREG(base + CMPSS_O_RAMPHDLYS) = delayVal;
}

