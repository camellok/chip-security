//#############################################################################
//
// $Copyright:
// Copyright (C) 2019-2025 Beijing Haawking Technology Co.,Ltd
// http://www.haawking.com/ All rights reserved.
//
// Redistribution and use in source and binary forms, with or without 
// modification, are permitted provided that the following conditions 
// are met:
// 
//   Redistributions of source code must retain the above copyright 
//   notice, this list of conditions and the following disclaimer.
// 
//   Redistributions in binary form must reproduce the above copyright
//   notice, this list of conditions and the following disclaimer in the 
//   documentation and/or other materials provided with the   
//   distribution.
// 
//   Neither the name of Beijing Haawking Technology Co.,Ltd nor the names of
//   its contributors may be used to endorse or promote products derived
//   from this software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
// OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// 
//#############################################################################


#ifndef HW_MEMCONFIG_H
#define HW_MEMCONFIG_H

//*************************************************************************************************
//
// The following are defines for the MEMCFG register offsets
//
//*************************************************************************************************
#define MEMCFG_O_DXLOCK        0x0U    // Dedicated RAM Config Lock Register
#define MEMCFG_O_DXCOMMIT      0x4U    // Dedicated RAM Config Lock Commit Register
#define MEMCFG_O_DXACCPROT0    0x8U    // Dedicated RAM Config Register
#define MEMCFG_O_DXACCPROT1    0xCU    // Dedicated RAM Config Register
#define MEMCFG_O_DXINIT        0x10U   // Dedicated RAM Init Register
#define MEMCFG_O_DXINITDONE    0x14U   // Dedicated RAM InitDone Status Register
#define MEMCFG_O_LSXLOCK       0x18U   // Local Shared RAM Config Lock Register
#define MEMCFG_O_LSXCOMMIT     0x1CU   // Local Shared RAM Config Lock Commit Register
#define MEMCFG_O_LSXACCPROT0   0x20U   // Local Shared RAM Config Register 0
#define MEMCFG_O_LSXINIT       0x24U   // Local Shared RAM Init Register
#define MEMCFG_O_LSXINITDONE   0x28U   // Local Shared RAM InitDone Status Register

#define MEMCFG_O_MAVFLG         0x0U    // Master Access Violation Flag Register
#define MEMCFG_O_MAVSET         0x4U    // Master Access Violation Flag Set Register
#define MEMCFG_O_MAVCLR         0x8U    // Master Access Violation Flag Clear Register
#define MEMCFG_O_MAVINTEN       0xCU    // Master Access Violation Interrupt Enable Register
#define MEMCFG_O_MCPUFAVADDR    0x10U   // Master CPU Fetch Access Violation Address
#define MEMCFG_O_MCPUWRAVADDR   0x14U   // Master CPU Write Access Violation Address

#define MEMCFG_O_BISTCFG      0x0U   // Bist Enable Configuration Register
#define MEMCFG_O_BISTREN      0x4U   // Bist Run Enable Register
#define MEMCFG_O_BISTSTS      0x8U   // Bist Status Register
#define MEMCFG_O_BISTRESULT   0xCU   // Bist Result Register


//*************************************************************************************************
//
// The following are defines for the bit fields in the DxLOCK register
//
//*************************************************************************************************
#define MEMCFG_DXLOCK_LOCK_M0        0x1U    // M0 RAM Lock bits
#define MEMCFG_DXLOCK_LOCK_PIEVECT   0x10U   // PIEVECT RAM Lock bits

//*************************************************************************************************
//
// The following are defines for the bit fields in the DxCOMMIT register
//
//*************************************************************************************************
#define MEMCFG_DXCOMMIT_COMMIT_M0        0x1U    // M0 RAM Permanent Lock bits
#define MEMCFG_DXCOMMIT_COMMIT_PIEVECT   0x10U   // PIEVECT RAM Permanent Lock bits

//*************************************************************************************************
//
// The following are defines for the bit fields in the DxACCPROT0 register
//
//*************************************************************************************************
#define MEMCFG_DXACCPROT0_FETCHPROT_M0   0x1U   // Fetch Protection For M0 RAM
#define MEMCFG_DXACCPROT0_CPUWRPROT_M0   0x2U   // CPU WR Protection For M0 RAM

//*************************************************************************************************
//
// The following are defines for the bit fields in the DxACCPROT1 register
//
//*************************************************************************************************
#define MEMCFG_DXACCPROT1_CPUWRPROT_PIEVECT   0x2U   // CPU WR Protection For PIEVECT RAM

//*************************************************************************************************
//
// The following are defines for the bit fields in the DxINIT register
//
//*************************************************************************************************
#define MEMCFG_DXINIT_INIT_M0        0x1U    // RAM Initialization control for M0 RAM.
#define MEMCFG_DXINIT_INIT_PIEVECT   0x10U   // RAM Initialization control for PIEVECT RAM.

//*************************************************************************************************
//
// The following are defines for the bit fields in the DxINITDONE register
//
//*************************************************************************************************
#define MEMCFG_DXINITDONE_INITDONE_M0        0x1U    // RAM Initialization status for M0 RAM.
#define MEMCFG_DXINITDONE_INITDONE_PIEVECT   0x10U   // RAM Initialization status for PIEVECT RAM.

//*************************************************************************************************
//
// The following are defines for the bit fields in the LSxLOCK register
//
//*************************************************************************************************
#define MEMCFG_LSXLOCK_LOCK_LS0   0x1U   // LS0 RAM Lock bits

//*************************************************************************************************
//
// The following are defines for the bit fields in the LSxCOMMIT register
//
//*************************************************************************************************
#define MEMCFG_LSXCOMMIT_COMMIT_LS0   0x1U   // LS0 RAM Permanent Lock bits

//*************************************************************************************************
//
// The following are defines for the bit fields in the LSxACCPROT0 register
//
//*************************************************************************************************
#define MEMCFG_LSXACCPROT0_FETCHPROT_LS0   0x1U   // Fetch Protection For LS0 RAM
#define MEMCFG_LSXACCPROT0_CPUWRPROT_LS0   0x2U   // CPU WR Protection For LS0 RAM

//*************************************************************************************************
//
// The following are defines for the bit fields in the LSxINIT register
//
//*************************************************************************************************
#define MEMCFG_LSXINIT_INIT_LS0   0x1U   // RAM Initialization control for LS0 RAM.

//*************************************************************************************************
//
// The following are defines for the bit fields in the LSxINITDONE register
//
//*************************************************************************************************
#define MEMCFG_LSXINITDONE_INITDONE_LS0   0x1U   // RAM Initialization status for LS0 RAM.

//*************************************************************************************************
//
// The following are defines for the bit fields in the MAVFLG register
//
//*************************************************************************************************
#define MEMCFG_MAVFLG_CPUFETCH   0x1U   // Master CPU Fetch Access Violation Flag
#define MEMCFG_MAVFLG_CPUWRITE   0x2U   // Master CPU Write Access Violation Flag

//*************************************************************************************************
//
// The following are defines for the bit fields in the MAVSET register
//
//*************************************************************************************************
#define MEMCFG_MAVSET_CPUFETCH   0x1U   // Master CPU Fetch Access Violation Flag Set
#define MEMCFG_MAVSET_CPUWRITE   0x2U   // Master CPU Write Access Violation Flag Set

//*************************************************************************************************
//
// The following are defines for the bit fields in the MAVCLR register
//
//*************************************************************************************************
#define MEMCFG_MAVCLR_CPUFETCH   0x1U   // Master CPU Fetch Access Violation Flag Clear
#define MEMCFG_MAVCLR_CPUWRITE   0x2U   // Master CPU Write Access Violation Flag Clear

//*************************************************************************************************
//
// The following are defines for the bit fields in the MAVINTEN register
//
//*************************************************************************************************
#define MEMCFG_MAVINTEN_CPUFETCH   0x1U   // Master CPU Fetch Access Violation Interrupt Enable
#define MEMCFG_MAVINTEN_CPUWRITE   0x2U   // Master CPU Write Access Violation Interrupt Enable

//*************************************************************************************************
//
// The following are defines for the bit fields in the BISTCFG register
//
//*************************************************************************************************
#define MEMCFG_BISTCFG_M0          0x1U          // M0 RAM Bist Enable
#define MEMCFG_BISTCFG_L0          0x100U        // L0 RAM Bist Enable
#define MEMCFG_BISTCFG_BOOTROM     0x400000U     // BootROM Bist Enable
#define MEMCFG_BISTCFG_SECUREROM   0x800000U     // SecureROM Bist Enable
#define MEMCFG_BISTCFG_PIESRAM     0x10000000U   // PIE SRAM Bist Enable

//*************************************************************************************************
//
// The following are defines for the bit fields in the BISTREN register
//
//*************************************************************************************************
#define MEMCFG_BISTREN_RUN   0x1U   // Bist Run Enable Configuration

//*************************************************************************************************
//
// The following are defines for the bit fields in the BISTSTS register
//
//*************************************************************************************************
#define MEMCFG_BISTSTS_M0          0x1U          // M0 RAM Bist Finish Status
#define MEMCFG_BISTSTS_L0          0x100U        // L0 RAM Bist Finish Status
#define MEMCFG_BISTSTS_BOOTROM     0x400000U     // BootROM Bist Finish Status
#define MEMCFG_BISTSTS_SECUREROM   0x800000U     // SecureROM Bist Finish Status
#define MEMCFG_BISTSTS_PIESRAM     0x10000000U   // PIE SRAM Bist Finish Status

//*************************************************************************************************
//
// The following are defines for the bit fields in the BISTRESULT register
//
//*************************************************************************************************
#define MEMCFG_BISTRESULT_M0          0x1U          // M0 RAM Bist Result
#define MEMCFG_BISTRESULT_L0          0x100U        // L0 RAM Bist Result
#define MEMCFG_BISTRESULT_BOOTROM     0x400000U     // BootROM Bist Result
#define MEMCFG_BISTRESULT_SECUREROM   0x800000U     // SecureROM Bist Result
#define MEMCFG_BISTRESULT_PIESRAM     0x10000000U   // PIE SRAM Bist Result



#endif
