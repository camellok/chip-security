//###########################################################################
//
// FILE:   flash.c
//
// TITLE:  H28x Flash driver.
//
//###########################################################################

#include "flash.h"

//*****************************************************************************
//
// Flash_initModule
//
//*****************************************************************************
void CODE_SECTION("ramfuncs")
Flash_initModule(uint32_t ctrlBase, uint16_t waitstates)
{
    //
    // Check the arguments.
    //
    ASSERT(Flash_isCtrlBaseValid(ctrlBase));
    ASSERT(waitstates <= 0xFU);


    //
    // Disable cache and prefetch mechanism before changing wait states
    //
    Flash_disableCache(ctrlBase);
    Flash_disablePrefetch(ctrlBase);

    //
    // Set waitstates according to frequency.
    //
    Flash_setWaitstates(ctrlBase, waitstates);
	
	//
    // Enable cache and prefetch mechanism to improve performance of code
    // executed from flash.
    //
    Flash_enableCache(ctrlBase);
    Flash_enablePrefetch(ctrlBase);

    //
    // Force a pipeline flush to ensure that the write to the last register
    // configured occurs before returning.
    //

    FLASH_DELAY_CONFIG;
}

