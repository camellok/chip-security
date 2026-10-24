//###########################################################################
//
// FILE:   flash.h
//
// TITLE:  H28x Flash driver.
//
//###########################################################################

#ifndef FLASH_H
#define FLASH_H

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
//! \addtogroup flash_api Flash
//! @{
//
//*****************************************************************************

#include <stdbool.h>
#include <stdint.h>
#include "inc/hw_flash.h"
#include "inc/hw_memmap.h"
#include "inc/hw_types.h"
#include "cpu.h"
#include "debug.h"


//*****************************************************************************
//
// Delay instruction that allows for register configuration to complete.
//
//*****************************************************************************
#define    FLASH_DELAY_CONFIG     asm volatile(".align 2;RPTI 10,4;NOP")

//*****************************************************************************
//
// Prototypes for the APIs.
//
//*****************************************************************************
//*****************************************************************************
//
//! \internal
//! Checks a flash wrapper base address for the control registers.
//!
//! \param ctrlBase is the base address of the flash wrapper control registers.
//!
//! This function determines if a flash wrapper control base address is valid.
//!
//! \return Returns \b true if the base address is valid and \b false
//! otherwise.
//
//*****************************************************************************
#ifdef DEBUG
static __always_inline bool
Flash_isCtrlBaseValid(uint32_t ctrlBase)
{
    return((ctrlBase == FLASH0CTRL_BASE));
}
#endif

//*****************************************************************************
//
//! Sets the random read wait state amount.
//!
//! \param ctrlBase is the base address of the flash wrapper control registers.
//! \param waitstates is the wait-state value.
//!
//! This function sets the number of wait states for a flash read access. The
//! \e waitstates parameter is a number between 0 and 15. It is \b important
//! to look at your device's datasheet for information about what the required
//! minimum flash wait-state is for your selected SYSCLK frequency.
//!
//! By default the wait state amount is configured to the maximum 15.
//!
//! \return None.
//
//*****************************************************************************
static __always_inline void  CODE_SECTION("ramfuncs")
Flash_setWaitstates(uint32_t ctrlBase, uint16_t waitstates)
{
    //
    // Check the arguments.
    //
    ASSERT(Flash_isCtrlBaseValid(ctrlBase));

    //
    // waitstates is 4 bits wide.
    //
    ASSERT(waitstates <= 0xFU);

    EALLOW;
    //
    // Write flash read wait-state amount to appropriate register.
    //
    HWREG(ctrlBase + FLASH_O_FRDCNTL) =
        (HWREG(ctrlBase + FLASH_O_FRDCNTL) &
         ~(uint32_t)FLASH_FRDCNTL_RWAIT_M) |
         ((uint32_t)waitstates << FLASH_FRDCNTL_RWAIT_S);
    EDIS;
}

//*****************************************************************************
//
//! Enables prefetch mechanism.
//!
//! \param ctrlBase is the base address of the flash wrapper control registers.
//!
//! \return None.
//
//*****************************************************************************
static __always_inline void  CODE_SECTION("ramfuncs")
Flash_enablePrefetch(uint32_t ctrlBase)
{
    //
    // Check the arguments.
    //
    ASSERT(Flash_isCtrlBaseValid(ctrlBase));

    EALLOW;

    //
    // Set the prefetch enable bit.
    //
    HWREG(ctrlBase + FLASH_O_FRD_INTF_CTRL) |=
            FLASH_FRD_INTF_CTRL_PREFETCH_EN;
    EDIS;
}

//*****************************************************************************
//
//! Disables prefetch mechanism.
//!
//! \param ctrlBase is the base address of the flash wrapper control registers.
//!
//! \return None.
//
//*****************************************************************************
static __always_inline void  CODE_SECTION("ramfuncs")
Flash_disablePrefetch(uint32_t ctrlBase)
{
    //
    // Check the arguments.
    //
    ASSERT(Flash_isCtrlBaseValid(ctrlBase));

    EALLOW;

    //
    // Clear the prefetch enable bit.
    //
    HWREG(ctrlBase + FLASH_O_FRD_INTF_CTRL) &=
            ~(uint32_t)FLASH_FRD_INTF_CTRL_PREFETCH_EN;
    EDIS;
}

//*****************************************************************************
//
//! Enables data cache.
//!
//! \param ctrlBase is the base address of the flash wrapper control registers.
//!
//! \return None.
//
//*****************************************************************************
static __always_inline void  CODE_SECTION("ramfuncs")
Flash_enableCache(uint32_t ctrlBase)
{
    //
    // Check the arguments.
    //
    ASSERT(Flash_isCtrlBaseValid(ctrlBase));

    EALLOW;

    //
    // Set the data cache enable bit.
    //
    HWREG(ctrlBase + FLASH_O_FRD_INTF_CTRL) |=
            FLASH_FRD_INTF_CTRL_DATA_CACHE_EN;
    EDIS;
}

//*****************************************************************************
//
//! Disables data cache.
//!
//! \param ctrlBase is the base address of the flash wrapper control registers.
//!
//! \return None.
//
//*****************************************************************************
static __always_inline void  CODE_SECTION("ramfuncs")
Flash_disableCache(uint32_t ctrlBase)
{
    //
    // Check the arguments.
    //
    ASSERT(Flash_isCtrlBaseValid(ctrlBase));

    EALLOW;

    //
    // Clear the data cache enable bit.
    //
    HWREG(ctrlBase + FLASH_O_FRD_INTF_CTRL) &=
            ~(uint32_t)FLASH_FRD_INTF_CTRL_DATA_CACHE_EN;
    EDIS;
}

//*****************************************************************************
//
//! Sets the FLWEPROT value of the FLPROT register.
//!
//! \param ctrlBase is the base address of the flash wrapper control registers.
//!
//! \return None.
//
//*****************************************************************************
static __always_inline void  CODE_SECTION("ramfuncs")
Flash_setFLWEPROT(uint32_t ctrlBase)
{
    //
    // Check the arguments.
    //
    ASSERT(Flash_isCtrlBaseValid(ctrlBase));

    EALLOW;

    //
    // Set the FLWEPROT value from the FLPROT register.
    //
    HWREG(ctrlBase + FLASH_O_FLPROT) &= ~(uint32_t)FLASH_FLPROT_FLWEPROT;
    HWREG(ctrlBase + FLASH_O_FLPROT) |= (uint32_t)FLASH_FLPROT_FLWEPROT;

    EDIS;
}

//*****************************************************************************
//
//! Initializes the flash control registers.
//!
//! \param ctrlBase is the base address of the flash wrapper control registers.
//! \param waitstates is the wait-state value.
//!
//! This function initializes the flash control registers. At reset bank and
//! pump are in sleep.  A flash access will power up the bank and pump
//! automatically. This function will power up Flash bank and pump and set the
//! fallback mode of flash and pump as active.
//!
//! This function also sets the number of wait-states for a flash access
//! (see Flash_setWaitstates() for more details), and enables cache, the
//! prefetch mechanism.
//!
//! \return None.
//
//*****************************************************************************
extern void
Flash_initModule(uint32_t ctrlBase, uint16_t waitstates);

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

#endif // FLASH_H
