//###########################################################################
//
// FILE:   memcfg.c
//
// TITLE:  H28x RAM config driver.
//
//###########################################################################

#include "memcfg.h"

//*****************************************************************************
//
// MemCfg_lockConfig
//
//*****************************************************************************
void
MemCfg_lockConfig(uint32_t memSections)
{
    //
    // Check the arguments.
    //
    ASSERT(((memSections & MEMCFG_SECT_TYPE_MASK) == MEMCFG_SECT_TYPE_D)   ||
           ((memSections & MEMCFG_SECT_TYPE_MASK) == MEMCFG_SECT_TYPE_LS)  ||
           (memSections == MEMCFG_SECT_ALL));

    //
    // Set the bit that blocks writes to the sections' configuration registers.
    //
    EALLOW;

    switch(memSections & MEMCFG_SECT_TYPE_MASK)
    {
        case MEMCFG_SECT_TYPE_D:
            HWREG(MEMCFG_BASE + MEMCFG_O_DXLOCK)  |= MEMCFG_SECT_NUM_MASK &
                                                     memSections;
            break;

        case MEMCFG_SECT_TYPE_LS:
            HWREG(MEMCFG_BASE + MEMCFG_O_LSXLOCK) |= MEMCFG_SECT_NUM_MASK &
                                                     memSections;
            break;

        case MEMCFG_SECT_TYPE_MASK:
            //
            // Lock configuration for all sections.
            //
            HWREG(MEMCFG_BASE + MEMCFG_O_DXLOCK)   |= MEMCFG_SECT_NUM_MASK &
                                                      MEMCFG_SECT_DX_ALL;
            HWREG(MEMCFG_BASE + MEMCFG_O_LSXLOCK)  |= MEMCFG_SECT_NUM_MASK &
                                                      MEMCFG_SECT_LSX_ALL;
            break;

        default:
            //
            // Do nothing. Invalid memSections. Make sure you aren't OR-ing
            // values for two different types of memory sections.
            //
            break;
    }

    EDIS;
}

//*****************************************************************************
//
// MemCfg_unlockConfig
//
//*****************************************************************************
void
MemCfg_unlockConfig(uint32_t memSections)
{
    //
    // Check the arguments.
    //
    ASSERT(((memSections & MEMCFG_SECT_TYPE_MASK) == MEMCFG_SECT_TYPE_D)   ||
           ((memSections & MEMCFG_SECT_TYPE_MASK) == MEMCFG_SECT_TYPE_LS)  ||
           (memSections == MEMCFG_SECT_ALL));

    //
    // Clear the bit that blocks writes to the sections' configuration
    // registers.
    //
    EALLOW;

    switch(memSections & MEMCFG_SECT_TYPE_MASK)
    {
        case MEMCFG_SECT_TYPE_D:
            HWREG(MEMCFG_BASE + MEMCFG_O_DXLOCK)  &= ~(MEMCFG_SECT_NUM_MASK &
                                                       memSections);
            break;

        case MEMCFG_SECT_TYPE_LS:
            HWREG(MEMCFG_BASE + MEMCFG_O_LSXLOCK) &= ~(MEMCFG_SECT_NUM_MASK &
                                                       memSections);
            break;


        case MEMCFG_SECT_TYPE_MASK:
            //
            // Unlock configuration for all sections.
            //
            HWREG(MEMCFG_BASE + MEMCFG_O_DXLOCK) &=
                ~((uint32_t)(MEMCFG_SECT_NUM_MASK & MEMCFG_SECT_DX_ALL));
            HWREG(MEMCFG_BASE + MEMCFG_O_LSXLOCK) &=
                ~((uint32_t)(MEMCFG_SECT_NUM_MASK & MEMCFG_SECT_LSX_ALL));
            break;

        default:
            //
            // Do nothing. Invalid memSections. Make sure you aren't OR-ing
            // values for two different types of memory sections.
            //
            break;
    }

    EDIS;
}

//*****************************************************************************
//
// MemCfg_commitConfig
//
//*****************************************************************************
void
MemCfg_commitConfig(uint32_t memSections)
{
    //
    // Check the arguments.
    //
    ASSERT(((memSections & MEMCFG_SECT_TYPE_MASK) == MEMCFG_SECT_TYPE_D)   ||
           ((memSections & MEMCFG_SECT_TYPE_MASK) == MEMCFG_SECT_TYPE_LS)  ||
           (memSections == MEMCFG_SECT_ALL));

    //
    // Set the bit that permanently blocks writes to the sections'
    // configuration registers.
    //
    EALLOW;

    switch(memSections & MEMCFG_SECT_TYPE_MASK)
    {
        case MEMCFG_SECT_TYPE_D:
            HWREG(MEMCFG_BASE + MEMCFG_O_DXCOMMIT)  |= MEMCFG_SECT_NUM_MASK &
                                                       memSections;
            break;

        case MEMCFG_SECT_TYPE_LS:
            HWREG(MEMCFG_BASE + MEMCFG_O_LSXCOMMIT) |= MEMCFG_SECT_NUM_MASK &
                                                       memSections;
            break;


        case MEMCFG_SECT_TYPE_MASK:
            //
            // Commit configuration for all sections.
            //
            HWREG(MEMCFG_BASE + MEMCFG_O_DXCOMMIT)   |= MEMCFG_SECT_NUM_MASK &
                                                        MEMCFG_SECT_DX_ALL;
            HWREG(MEMCFG_BASE + MEMCFG_O_LSXCOMMIT)  |= MEMCFG_SECT_NUM_MASK &
                                                        MEMCFG_SECT_LSX_ALL;
            break;

        default:
            //
            // Do nothing. Invalid memSections. Make sure you aren't OR-ing
            // values for two different types of RAM.
            //
            break;
    }

    EDIS;
}

//*****************************************************************************
//
// MemCfg_setProtection
//
//*****************************************************************************
void
MemCfg_setProtection(uint32_t memSection, uint32_t protectMode)
{
    uint32_t shiftVal = 0U;
    uint32_t maskVal;
    uint32_t regVal;
    uint32_t sectionNum;
    uint32_t regOffset;

    //
    // Check the arguments.
    //
    ASSERT(((memSection & MEMCFG_SECT_TYPE_MASK) == MEMCFG_SECT_TYPE_LS)   ||
           ((memSection & MEMCFG_SECT_TYPE_MASK) == MEMCFG_SECT_TYPE_D));

    //
    // Calculate how far the protect mode value needs to be shifted. Each
    // section number is represented by a bit in the lower word of memSection
    // and 8 bits in the corresponding ACCPROT register.
    //
    sectionNum = memSection & MEMCFG_SECT_NUM_MASK;

    while(sectionNum != 1U)
    {
        sectionNum = sectionNum >> 1U;
        shiftVal += 8U;
    }

    //
    // Calculate register offset. Also, make sure the shift value is no greater
    // than 31.
    //
    regOffset = (shiftVal & ~(0x1FU)) >> 3U;
    shiftVal &= 0x0001FU;
    maskVal = (uint32_t)MEMCFG_XACCPROTX_M << shiftVal;
    regVal = protectMode << shiftVal;

    //
    // Write the access protection mode into the appropriate field
    //
    EALLOW;

    switch(memSection & MEMCFG_SECT_TYPE_MASK)
    {
        case MEMCFG_SECT_TYPE_D:
            HWREG(MEMCFG_BASE + MEMCFG_O_DXACCPROT0 + regOffset) &= ~maskVal;
            HWREG(MEMCFG_BASE + MEMCFG_O_DXACCPROT0 + regOffset) |= regVal;
            break;

        case MEMCFG_SECT_TYPE_LS:
            HWREG(MEMCFG_BASE + MEMCFG_O_LSXACCPROT0 + regOffset) &= ~maskVal;
            HWREG(MEMCFG_BASE + MEMCFG_O_LSXACCPROT0 + regOffset) |= regVal;
            break;


        default:
            //
            // Do nothing. Invalid memSection.
            //
            break;
    }

    EDIS;
}

//*****************************************************************************
//
// MemCfg_initSections
//
//*****************************************************************************
void
MemCfg_initSections(uint32_t ramSections)
{
    //
    // Check the arguments.
    //
    ASSERT(((ramSections & MEMCFG_SECT_TYPE_MASK) == MEMCFG_SECT_TYPE_D)   ||
           ((ramSections & MEMCFG_SECT_TYPE_MASK) == MEMCFG_SECT_TYPE_LS)  ||
           (ramSections == MEMCFG_SECT_ALL));

    //
    // Set the bit in the various initialization registers that starts
    // initialization.
    //
    EALLOW;

    switch(ramSections & MEMCFG_SECT_TYPE_MASK)
    {
        case MEMCFG_SECT_TYPE_D:
            HWREG(MEMCFG_BASE + MEMCFG_O_DXINIT)   |= MEMCFG_SECT_NUM_MASK &
                                                      ramSections;
            break;

        case MEMCFG_SECT_TYPE_LS:
            HWREG(MEMCFG_BASE + MEMCFG_O_LSXINIT)  |= MEMCFG_SECT_NUM_MASK &
                                                      ramSections;
            break;


        case MEMCFG_SECT_TYPE_MASK:
            //
            // Initialize all sections.
            //
            HWREG(MEMCFG_BASE + MEMCFG_O_DXINIT)   |= MEMCFG_SECT_NUM_MASK &
                                                      MEMCFG_SECT_DX_ALL;
            HWREG(MEMCFG_BASE + MEMCFG_O_LSXINIT)  |= MEMCFG_SECT_NUM_MASK &
                                                      MEMCFG_SECT_LSX_ALL;
            break;

        default:
            //
            // Do nothing. Invalid ramSections. Make sure you aren't OR-ing
            // values for two different types of RAM.
            //
            break;
    }

    EDIS;
}

//*****************************************************************************
//
// MemCfg_getInitStatus
//
//*****************************************************************************
bool
MemCfg_getInitStatus(uint32_t ramSections)
{
    uint32_t status;

    //
    // Check the arguments.
    //
    ASSERT(((ramSections & MEMCFG_SECT_TYPE_MASK) == MEMCFG_SECT_TYPE_D)   ||
           ((ramSections & MEMCFG_SECT_TYPE_MASK) == MEMCFG_SECT_TYPE_LS)  ||
           (ramSections == MEMCFG_SECT_ALL));

    //
    // Read registers containing the initialization complete status.
    //
    switch(ramSections & MEMCFG_SECT_TYPE_MASK)
    {
        case MEMCFG_SECT_TYPE_D:
            status = HWREG(MEMCFG_BASE + MEMCFG_O_DXINITDONE);
            break;

        case MEMCFG_SECT_TYPE_LS:
            status = HWREG(MEMCFG_BASE + MEMCFG_O_LSXINITDONE);
            break;


        case MEMCFG_SECT_TYPE_MASK:
            //
            // Return the overall status.
            //
            if((HWREG(MEMCFG_BASE + MEMCFG_O_DXINITDONE) ==
                MEMCFG_SECT_DX_ALL) &&
               (HWREG(MEMCFG_BASE + MEMCFG_O_LSXINITDONE) ==
                MEMCFG_SECT_LSX_ALL))
            {
                status = MEMCFG_SECT_NUM_MASK;
            }
            else
            {
                status = 0U;
            }
            break;

        default:
            //
            // Invalid ramSections. Make sure you aren't OR-ing values for two
            // different types of RAM.
            //
            status = 0U;
            break;
    }

    return((ramSections & status) == (ramSections & MEMCFG_SECT_NUM_MASK));
}

//*****************************************************************************
//
// MemCfg_getViolationAddress
//
//*****************************************************************************
uint32_t
MemCfg_getViolationAddress(uint32_t intFlag)
{
    uint32_t address = 0;

    if(intFlag == MEMCFG_MVIOL_CPUFETCH)
    {
        address = HWREG(ACCESSPROTECTION_BASE + MEMCFG_O_MCPUFAVADDR);
    }
    else if(intFlag == MEMCFG_MVIOL_CPUWRITE)
    {
        address = HWREG(ACCESSPROTECTION_BASE + MEMCFG_O_MCPUWRAVADDR);
    }
    else
    {
        ASSERT((bool)false);
    }
    return(address);
}

