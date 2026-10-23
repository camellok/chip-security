/*#############################################################################*/
/*                                                                             */
/* $Copyright:                                                                 */
/* Copyright (C) 2019-2025 Beijing Haawking Technology Co.,Ltd               */
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
/* Release for HXS320F2800137EDE, FlashLinker, 1.0.0                           */
/*                                                                             */
/* Release time: 2025-01-08 19:23:58.328428                                    */
/*                                                                             */
/*#############################################################################*/

OUTPUT_ARCH( "riscv" )
ENTRY(_start)
INCLUDE "Peripheral.ld" 
INCLUDE "BootROM.ld" 

/*----------------------------------------------------------------------*/
/* Memories                                                             */
/*----------------------------------------------------------------------*/
MEMORY
{
    RAMSTACK(rwx):                 ORIGIN = 0x00000000, LENGTH = 0x00000800     /* Internal RAM For Stack */
    RAMM0(rwx):                    ORIGIN = 0x00000800, LENGTH = 0x00003800     /* Internal RAM M0 */
    RAMLS0(rwx):                   ORIGIN = 0x00010000, LENGTH = 0x00004000     /* Internal RAM LS0 */
    BEGIN(rwx):                    ORIGIN = 0x00600000, LENGTH = 0x00000010     /* Code Entry */
    FLASH(rwx):                    ORIGIN = 0x00600010, LENGTH = 0x0000FFF0     /* Internal Flash Bank0 */
    MODULE_CODE(rx):               ORIGIN = 0x00610000, LENGTH = 0x00004000
    MODULE_PARAMS(r):              ORIGIN = 0x00614000, LENGTH = 0x00004000
    IER_REGISTER_FILE(rw):         ORIGIN = 0x00400C10, LENGTH = 0x00000004     /* IER Regitser */
    IFR_REGISTER_FILE(rw):         ORIGIN = 0x00400D10, LENGTH = 0x00000004     /* IFR Regitser */
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
        __global_sp$ = . + 0x7F8;
    } > RAMSTACK

    . = 0x00000800;
    /* Ram function segment */
    ramfunc ALIGN(0x10): AT(__FLASH_RAMFUNC_START)
    {
        __RAMFUNC_START = .;
        *(ramconsts)
        *(ramfuncs)
        __RAMFUNC_END = ALIGN(0x10);
    } > RAMM0

    . = 0x00010000;
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
    } > RAMLS0

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
    } > RAMLS0

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

    FLASH_RAMFUNC ALIGN(0x10):
    {
        __FLASH_RAMFUNC_START = .;
        __FLASH_RAMFUNC_END = __FLASH_RAMFUNC_START + (__RAMFUNC_END - __RAMFUNC_START);
    } > FLASH

    FLASH_DATA ALIGN(0x10):
    {
        __FLASH_DATA_START = __FLASH_RAMFUNC_END;
        __FLASH_DATA_END = __FLASH_DATA_START + (__DATA_END - __DATA_START);
    } > FLASH

    . = 0x00400C10;
    /* IER csr register */
    ier_register(NOLOAD): ALIGN(0x10)
    {
        *(.ier_register)
    } > IER_REGISTER_FILE

    . = 0x00400D10;
    /* IFR csr register */
    ifr_register(NOLOAD): ALIGN(0x10)
    {
        *(.ifr_register)
    } > IFR_REGISTER_FILE

    module_code 0x00610000 : ALIGN(0x10)
    {
        KEEP(*(module_code))
    } > MODULE_CODE
    module_params 0x00614000 : ALIGN(0x10)
    {
        KEEP(*(module_params))
    } > MODULE_PARAMS
    ASSERT(SIZEOF(module_code) <= 0x4000, "Module code overflows sector32-39")
    ASSERT(SIZEOF(module_params) == 8, "Demo parameters must be two uint32_t words")
    ASSERT(__FLASH_DATA_END <= 0x00610000, "APP load image reaches secure Flash")
    /* End */
    _end = .;
}
