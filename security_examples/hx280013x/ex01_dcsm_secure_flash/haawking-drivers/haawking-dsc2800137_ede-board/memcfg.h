//###########################################################################
//
// FILE:   memcfg.h
//
// TITLE:  H28x RAM config driver.
//
//###########################################################################

#ifndef MEMCFG_H
#define MEMCFG_H

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
//! \addtogroup memcfg_api MemCfg
//! @{
//
//*****************************************************************************

#include <stdbool.h>
#include <stdint.h>
#include "inc/hw_memcfg.h"
#include "inc/hw_memmap.h"
#include "inc/hw_types.h"
#include "cpu.h"
#include "debug.h"

//*****************************************************************************
//
// Useful defines used within the driver functions. Not intended for use by
// application code.
//
//*****************************************************************************
//
// Masks to decode memory section defines.
//
#define MEMCFG_SECT_TYPE_MASK   0xFF000000U
#define MEMCFG_SECT_TYPE_D      0x00000000U
#define MEMCFG_SECT_TYPE_LS     0x01000000U
#define MEMCFG_SECT_TYPE_ROM      0x04000000U
#define MEMCFG_SECT_NUM_MASK    0x00FFFFFFU
#define MEMCFG_XACCPROTX_M      ((uint32_t)MEMCFG_DXACCPROT0_FETCHPROT_M0 |   \
                                 (uint32_t)MEMCFG_DXACCPROT0_CPUWRPROT_M0)
#define MEMCFG_XTEST_M          MEMCFG_DXTEST_TEST_M0_M

//
// Used for access violation functions.
//
#define MEMCFG_NMVIOL_MASK      0x0000FFFFU
#define MEMCFG_MVIOL_MASK       0x000F0000U
#define MEMCFG_MVIOL_SHIFT      16U

//
// Key for writing to memory test config lock registers
//
#define MEMCFG_TESTLOCK_KEY     0xA5A50000U

#ifndef DOXYGEN_PDF_IGNORE
//*****************************************************************************
//
// Values that can be passed to MemCfg_lockConfig(), MemCfg_unlockConfig(),
// MemCfg_commitConfig(), MemCfg_setProtection(), MemCfg_initSections(),
// MemCfg_setCLAMemType(), MemCfg_setLSRAMControllerSel(),
// MemCfg_getInitStatus() as the memSection(s) or ramSection(s) parameter.
//
//*****************************************************************************
//
// DxRAM - Dedicated RAM config
//
#define MEMCFG_SECT_M0              0x00000001U //!< M0 RAM
#define MEMCFG_SECT_DX_ALL          0x00000001U //!< All M and D RAM
#define MEMCFG_SECT_PIEVECT         0x00000010U //!< PIEVECT RAM

//
// LSxRAM - Local shared RAM config
//
#define MEMCFG_SECT_LS0             0x01000001U //!< LS0 RAM
#define MEMCFG_SECT_LSX_ALL         0x01000001U //!< All LS RAM

//
// GSxRAM - Global shared RAM config
//


//
// ROM memory sections
//
#define MEMCFG_SECT_ROMBOOT           0x04000001U //!< BOOT ROM
#define MEMCFG_SECT_ROM_ALL           0x04000001U //!< All ROMs

//
// All sections
//
#define MEMCFG_SECT_ALL             0xFFFFFFFFU //!< All configurable RAM

//*****************************************************************************
//
// Values that can be passed to MemCfg_setProtection() as the protectMode
// parameter.
//
//*****************************************************************************
#define MEMCFG_PROT_ALLOWCPUFETCH   0x00000000U //!< CPU fetch allowed
#define MEMCFG_PROT_BLOCKCPUFETCH   0x00000001U //!< CPU fetch blocked

#define MEMCFG_PROT_ALLOWCPUWRITE   0x00000000U //!< CPU write allowed
#define MEMCFG_PROT_BLOCKCPUWRITE   0x00000002U //!< CPU write blocked


//*****************************************************************************
//
// Values that can be passed to MemCfg_enableViolationInterrupt()
// MemCfg_disableViolationInterrupt(), MemCfg_forceViolationInterrupt(),
// MemCfg_clearViolationInterruptStatus(), and MemCfg_getViolationAddress() as
// the intFlags parameter. They also make up the return value of
// MemCfg_getViolationInterruptStatus().
//
//*****************************************************************************
#define MEMCFG_MVIOL_CPUFETCH    0x00010000U //!< Controller CPU fetch access
#define MEMCFG_MVIOL_CPUWRITE    0x00020000U //!< Controller CPU write access


#endif


//*****************************************************************************
//
// Prototypes for the APIs.
//
//*****************************************************************************

//*****************************************************************************
//
//! Enables individual RAM access violation interrupt sources.
//!
//! \param intFlags is a bit mask of the interrupt sources to be enabled.
//! Can be a logical OR any of the following values:
//!  - \b MEMCFG_MVIOL_CPUFETCH   - Controller CPU fetch access
//!  - \b MEMCFG_MVIOL_CPUWRITE   - Controller CPU write access
//! This function enables the indicated RAM access violation interrupt sources.
//! Only the sources that are enabled can be reflected to the processor
//! interrupt; disabled sources have no effect on the processor.
//!
//! \return None.
//
//*****************************************************************************
static __always_inline void
MemCfg_enableViolationInterrupt(uint32_t intFlags)
{
    //
    // Enable the specified interrupts.
    //
    EALLOW;

    HWREG(ACCESSPROTECTION_BASE + MEMCFG_O_MAVINTEN) |=
        (intFlags & MEMCFG_MVIOL_MASK) >> MEMCFG_MVIOL_SHIFT;

    EDIS;
}

//*****************************************************************************
//
//! Disables individual RAM access violation interrupt sources.
//!
//! \param intFlags is a bit mask of the interrupt sources to be disabled.
//! Can be a logical OR any of the following values:
//!  - \b MEMCFG_MVIOL_CPUFETCH   - Controller CPU fetch access
//!  - \b MEMCFG_MVIOL_CPUWRITE   - Controller CPU write access
//!
//! This function disables the indicated RAM access violation interrupt
//! sources. Only the sources that are enabled can be reflected to the
//! processor interrupt; disabled sources have no effect on the processor.
//!
//! \note Note that only non-controller violations may generate interrupts.
//!
//! \return None.
//
//*****************************************************************************
static __always_inline void
MemCfg_disableViolationInterrupt(uint32_t intFlags)
{
    //
    // Disable the specified interrupts.
    //
    EALLOW;

    HWREG(ACCESSPROTECTION_BASE + MEMCFG_O_MAVINTEN) &=
        ~((intFlags & MEMCFG_MVIOL_MASK) >> MEMCFG_MVIOL_SHIFT);

    EDIS;
}

//*****************************************************************************
//
//! Gets the current RAM access violation status.
//!
//! This function returns the RAM access violation status. This function will
//! return flags for both controller and non-controller access violations
//! although only the non-controller flags have the ability to cause the
//! generation of an interrupt.
//!
//! \return Returns the current violation status, enumerated as a bit field of
//! the values:
//!  - \b MEMCFG_MVIOL_CPUFETCH   - Controller CPU fetch access
//!  - \b MEMCFG_MVIOL_CPUWRITE   - Controller CPU write access
//*****************************************************************************
static __always_inline uint32_t
MemCfg_getViolationInterruptStatus(void)
{
    uint32_t status;

    //
    // Read and return RAM access status flags.
    //
   status = HWREG(ACCESSPROTECTION_BASE + MEMCFG_O_MAVFLG) <<
            MEMCFG_MVIOL_SHIFT;

    return(status);
}

//*****************************************************************************
//
//! Sets the RAM access violation status.
//!
//! \param intFlags is a bit mask of the access violation flags to be set.
//! Can be a logical OR any of the following values:
//!  - \b MEMCFG_MVIOL_CPUFETCH   - Controller CPU fetch access
//!  - \b MEMCFG_MVIOL_CPUWRITE   - Controller CPU write access
//!
//! This function sets the RAM access violation status. This function will
//! set flags for both controller and non-controller access violations, and an
//! interrupt will be generated if it is enabled.
//!
//! \return None.
//
//*****************************************************************************
static __always_inline void
MemCfg_forceViolationInterrupt(uint32_t intFlags)
{
    //
    // Shift and mask the flags appropriately and write them to the
    // corresponding SET register.
    //
    EALLOW;

    HWREG(ACCESSPROTECTION_BASE + MEMCFG_O_MAVSET) =
        (intFlags & MEMCFG_MVIOL_MASK) >> MEMCFG_MVIOL_SHIFT;

    EDIS;
}

//*****************************************************************************
//
//! Clears RAM access violation flags.
//!
//! \param intFlags is a bit mask of the access violation flags to be cleared.
//! Can be a logical OR any of the following values:
//!  - \b MEMCFG_MVIOL_CPUFETCH   - Controller CPU fetch access
//!  - \b MEMCFG_MVIOL_CPUWRITE   - Controller CPU write access
//!
//! \return None.
//
//*****************************************************************************
static __always_inline void
MemCfg_clearViolationInterruptStatus(uint32_t intFlags)
{
    //
    // Clear the requested access violation flags.
    //
    EALLOW;

    HWREG(ACCESSPROTECTION_BASE + MEMCFG_O_MAVCLR) |=
        (intFlags & MEMCFG_MVIOL_MASK) >> MEMCFG_MVIOL_SHIFT;

    EDIS;
}

//*****************************************************************************
//
//! Locks the writes to the configuration of specified memory sections.
//!
//! \param memSections is the logical OR of the sections to be configured.
//!
//! This function locks writes to the access protection, initialization control
//! and test mode configuration of a memory section. This means calling APIs
//! like MemCfg_setProtection() or MemCfg_initSections() for a locked memory
//! section will have no effect until MemCfg_unlockConfig() is called.
//!
//! The \e memSections parameter is an OR of one of the following sets of
//! indicators:
//! - \b MEMCFG_SECT_M0 and \b MEMCFG_SECT_M1 or \b MEMCFG_SECT_DX_ALL
//! - \b MEMCFG_SECT_LS0 through \b MEMCFG_SECT_LSx or \b MEMCFG_SECT_LSX_ALL
//! - \b OR use \b MEMCFG_SECT_ALL to configure all possible sections.
//!
//! \return None.
//
//*****************************************************************************
extern void
MemCfg_lockConfig(uint32_t memSections);

//*****************************************************************************
//
//! Unlocks the writes to the configuration of a memory section.
//!
//! \param memSections is the logical OR of the sections to be configured.
//!
//! This function unlocks writes to the access protection and controller select
//! configuration of a memory section that has been locked using
//! MemCfg_lockConfig().
//!
//! The \e memSections parameter is an OR of one of the following sets of
//! indicators:
//! - \b MEMCFG_SECT_M0 and \b MEMCFG_SECT_M1 or \b MEMCFG_SECT_DX_ALL
//! - \b MEMCFG_SECT_LS0 through \b MEMCFG_SECT_LSx or \b MEMCFG_SECT_LSX_ALL
//! - \b OR use \b MEMCFG_SECT_ALL to configure all possible sections.
//!
//! \return None.
//
//*****************************************************************************
extern void
MemCfg_unlockConfig(uint32_t memSections);

//*****************************************************************************
//
//! Permanently locks writes to the configuration of a memory section.
//!
//! \param memSections is the logical OR of the sections to be configured.
//!
//! This function permanently locks writes to the access protection and
//! controller select configuration of a memory section. That means calling
//! MemCfg_setProtection() or MemCfg_setLSRAMControllerSel() for a locked memory
//! section will have no effect. To lock the configuration in a nonpermanent
//! way, use MemCfg_lockConfig().
//!
//! The \e memSections parameter is an OR of one of the following sets of
//! indicators:
//! - \b MEMCFG_SECT_M0 and \b MEMCFG_SECT_M1 or \b MEMCFG_SECT_DX_ALL
//! - \b MEMCFG_SECT_LS0 through \b MEMCFG_SECT_LSx or \b MEMCFG_SECT_LSX_ALL
//! - \b OR use \b MEMCFG_SECT_ALL to configure all possible sections.
//!
//! \return None.
//
//*****************************************************************************
extern void
MemCfg_commitConfig(uint32_t memSections);

//*****************************************************************************
//
//! Sets the access protection mode of a single memory section.
//!
//! \param memSection is the memory section to be configured.
//! \param protectMode is the logical OR of the settings to be applied.
//!
//! This function sets the access protection mode of a specified memory section.
//! The mode is passed into the \e protectMode parameter as the logical OR of
//! the following values:
//! - \b MEMCFG_PROT_ALLOWCPUWRITE or \b MEMCFG_PROT_BLOCKCPUWRITE - CPU write
//!
//! The \e memSection parameter is one of the following indicators:
//! - \b MEMCFG_SECT_M0 or \b MEMCFG_SECT_M1
//! - \b MEMCFG_SECT_LS0 through \b MEMCFG_SECT_LSx
//!
//! This function will have no effect if the associated registers have been
//! locked by MemCfg_lockConfig() or MemCfg_commitConfig().
//!
//! \return None.
//
//*****************************************************************************
extern void
MemCfg_setProtection(uint32_t memSection, uint32_t protectMode);

//*****************************************************************************
//
//! Starts the initialization the specified RAM sections.
//!
//! \param ramSections is the logical OR of the sections to be initialized.
//!
//! This function starts the initialization of the specified RAM sections. Use
//! MemCfg_getInitStatus() to check if the initialization is done.
//!
//! The \e ramSections parameter is an OR of one of the following sets of
//! indicators:
//! - \b MEMCFG_SECT_M0, \b MEMCFG_SECT_M1, or \b MEMCFG_SECT_DX_ALL
//! - \b MEMCFG_SECT_LS0 through \b MEMCFG_SECT_LSx, or \b MEMCFG_SECT_LSX_ALL
//! - \b OR use \b MEMCFG_SECT_ALL to configure all possible sections.
//!
//! \return None.
//
//*****************************************************************************
extern void
MemCfg_initSections(uint32_t ramSections);

//*****************************************************************************
//
//! Get the status of initialized RAM sections.
//!
//! \param ramSections is the logical OR of the sections to be checked.
//!
//! This function gets the initialization status of the RAM sections specified
//! by the \e ramSections parameter.
//!
//! The \e ramSections parameter is an OR of one of the following sets of
//! indicators:
//! - \b MEMCFG_SECT_M0, \b MEMCFG_SECT_M1, or \b MEMCFG_SECT_DX_ALL
//! - \b MEMCFG_SECT_LS0 through \b MEMCFG_SECT_LSx, or \b MEMCFG_SECT_LSX_ALL
//! - \b OR use \b MEMCFG_SECT_ALL to get status of all possible sections.
//!
//! \note Use MemCfg_initSections() to start the initialization.
//!
//! \return Returns \b true if all the sections specified by \e ramSections
//! have been initialized and \b false if not.
//
//*****************************************************************************
extern bool
MemCfg_getInitStatus(uint32_t ramSections);

//*****************************************************************************
//
//! Get the violation address associated with a intFlag.
//!
//! \param intFlag is the type of access violation as indicated by ONE of
//! these values:
//!  - \b MEMCFG_MVIOL_CPUFETCH   - Controller CPU fetch access
//!  - \b MEMCFG_MVIOL_CPUWRITE   - Controller CPU write access
//!
//! \return Returns the violation address associated with the \e intFlag.
//
//*****************************************************************************
extern uint32_t
MemCfg_getViolationAddress(uint32_t intFlag);

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

#endif // MEMCFG_H
