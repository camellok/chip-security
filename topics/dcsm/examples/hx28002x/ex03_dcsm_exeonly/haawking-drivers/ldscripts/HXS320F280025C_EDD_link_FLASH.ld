/*#############################################################################*/
/*                                                                             */
/* $Copyright:                                                                 */
/* Copyright (C) 2019-2024 Beijing Haawking Technology Co.,Ltd                 */
/* http://www.haawking.com/ All rights reserved.                               */
/*                                                                             */
/* Redistribution and use in source and binary forms, with or without          */
/* modification, are permitted provided that the following conditions          */
/* are met:                                                                    */
/*                                                                             */
/*   Redistributions of source code must retain the above copyright            */
/*   notice, this list of conditions and the following disclaimer.             */
/*                                                                             */
/*   Redistributions in binary form must reproduce the above copyright         */
/*   notice, this list of conditions and the following disclaimer in the       */
/*   documentation and/or other materials provided with the                    */
/*   distribution.                                                             */
/*                                                                             */
/*   Neither the name of Beijing Haawking Technology Co.,Ltd nor the names of  */
/*   its contributors may be used to endorse or promote products derived       */
/*   from this software without specific prior written permission.             */
/*                                                                             */
/* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS         */
/* "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT           */
/* LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR       */
/* A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT        */
/* OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,       */
/* SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT            */
/* LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,       */
/* DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY       */
/* THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT         */
/* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE       */
/* OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.        */
/*                                                                             */
/*#############################################################################*/
/*                                                                             */
/* Release for HXS320F280025CEDD, Flash Linker, 1.0.1                          */
/*                                                                             */
/* Release time: 2024-12-16 13:12:54.821062                                    */
/*                                                                             */
/*#############################################################################*/

OUTPUT_ARCH("riscv")
ENTRY(_start)
INCLUDE "Peripheral.ld" 
INCLUDE "BootROM.ld" 
INCLUDE "DCSM.ld"

/*----------------------------------------------------------------------*/
/* Memories                                                             */
/*----------------------------------------------------------------------*/
MEMORY
{
    RAMM0M1(rwx):                  ORIGIN = 0x00000000, LENGTH = 0x00001000     /* Internal RAM M0 to M1 */
    RAMLS5TO7(rwx):                ORIGIN = 0x00012000, LENGTH = 0x00006000     /* LS4 reserved for shared ex04 profile */
    RAMGS0(rwx):                   ORIGIN = 0x00018000, LENGTH = 0x00002000     /* Internal RAM GS0 */
    BEGIN(rwx):                    ORIGIN = 0x00600000, LENGTH = 0x00000010     /* Code Entry */
    FLASH(rwx):                    ORIGIN = 0x00600010, LENGTH = 0x0000FFF0     /* APP Flash ends before sector4 */
    FLASH_ZONE1_CODE(rwx):         ORIGIN = 0x00610000, LENGTH = 0x00004000     /* Zone1 module code: sector4 */
    FLASH_ZONE1_PARAMS(r):         ORIGIN = 0x00614000, LENGTH = 0x00004000     /* Zone1 parameters: sector5 */
    USEROTP(rwx):                  ORIGIN = 0x007A0000, LENGTH = 0x00000800     /* User Otp for DCSM configuration */
    IER_REGISTER_FILE(rw):         ORIGIN = 0x00100C10, LENGTH = 0x00000004     /* IER Regitser */
    IFR_REGISTER_FILE(rw):         ORIGIN = 0x00100D10, LENGTH = 0x00000004     /* IFR Regitser */
}

/*----------------------------------------------------------------------*/
/* Sections                                                             */
/*----------------------------------------------------------------------*/
SECTIONS
{
    . = 0x00000000;
    /* Stack usage memory */
    stack(NOLOAD): ALIGN(0x10)
    {
        __global_sp$ = . + 0xFE8;
    } > RAMM0M1

    . = 0x00012000;
    /* Data segment */
    data ALIGN(0x10): AT(__FLASH_DATA_START)
    {
        __DATA_START = .;
        __global_pointer$ = . + 0x800;
        *(.data)
        *(.data.*)
        *(.sdata)
        *(.sdata.*)
        *(.gnu.linkonce.s.*)
        __DATA_END = ALIGN(0x10);
    } > RAMLS5TO7

    /* RAM-executed functions are loaded from unsecured APP Flash. */
    ramfunc ALIGN(0x10): AT(__FLASH_RAMFUNC_START)
    {
        __RAMFUNC_START = .;
        *(ramconsts)
        *(ramfuncs)
        __RAMFUNC_END = ALIGN(0x10);
    } > RAMLS5TO7

    /* Bss segment */
    bss ALIGN(0x10):
    {
        __BSS_START = .;
        *(.sbss)
        *(.sbss.*)
        *(.scommon)
        *(.gnu.linkonce.sb.*)
        *(.bss)
        *(.bss.*)
        *(COMMON)
        __BSS_END = ALIGN(0x10);
    } > RAMLS5TO7

    . = 0x00018000;
    /* Data in ramgs0 */
    ramgs0 ALIGN(0x10): AT(__FLASH_RAMGS0_START)
    {
        __RAMGS0_START = .;
        *(ramgs0)
        __RAMGS0_END = ALIGN(0x10);
    } > RAMGS0

    . = 0x00600000;
    /* Code start vector */
    codestart ALIGN(0x10):
    {
        *(codestart)
    } > BEGIN

    . = 0x00600010;
    /* Text segment */
    text ALIGN(0x10):
    {
        *(.text.init)
        *(.text)
        *(.text*)
        *(.IQmath.*)
        *(.srodata)
        *(.srodata*)
        *(.rodata)
        *(.rodata*)
    } > FLASH

    /* RAM initialization images must be readable before Zone1 unlock. */
    FLASH_DATA ALIGN(0x10):
    {
        __FLASH_DATA_START = .;
        __FLASH_DATA_END = __FLASH_DATA_START + (__DATA_END - __DATA_START);
    } > FLASH

    FLASH_RAMFUNC ALIGN(0x10):
    {
        __FLASH_RAMFUNC_START = __FLASH_DATA_END;
        __FLASH_RAMFUNC_END = __FLASH_RAMFUNC_START + (__RAMFUNC_END - __RAMFUNC_START);
    } > FLASH

    FLASH_RAMGS0 ALIGN(0x10):
    {
        __FLASH_RAMGS0_START = __FLASH_RAMFUNC_END;
        __FLASH_RAMGS0_END = __FLASH_RAMGS0_START + (__RAMGS0_END - __RAMGS0_START);
    } > FLASH

    . = 0x00610000;
    module_code ALIGN(0x10):
    {
        *(module_code)
    } > FLASH_ZONE1_CODE

    . = 0x00614000;
    module_params ALIGN(0x10):
    {
        *(module_params)
    } > FLASH_ZONE1_PARAMS

    module_probe ALIGN(0x10):
    {
        *(module_probe)
    } > FLASH_ZONE1_PARAMS

    ASSERT(SIZEOF(module_code) >= 4, "Probe target must contain module code")

    . = 0x00100C10;
    /* IER csr register */
    ier_register(NOLOAD): ALIGN(0x10)
    {
        *(.ier_register)
    } > IER_REGISTER_FILE

    . = 0x00100D10;
    /* IFR csr register */
    ifr_register(NOLOAD): ALIGN(0x10)
    {
        *(.ifr_register)
    } > IFR_REGISTER_FILE

    /* End */
    _end = .;
}
