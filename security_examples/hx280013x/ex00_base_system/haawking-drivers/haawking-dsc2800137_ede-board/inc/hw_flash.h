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


#ifndef HW_FLASH_H
#define HW_FLASH_H

//*************************************************************************************************
//
// The following are defines for the FLASH register offsets
//
//*************************************************************************************************
#define FLASH_O_INIT            0x0U     // flash init Register
#define FLASH_O_FRDCNTL         0x4U     // Flash Read Control Register
#define FLASH_O_FMSTAT          0x10U    // Flash Status Register
#define FLASH_O_FRD_INTF_CTRL   0x14U    // Flash Read Interface Control Register
#define FLASH_O_FLPROT          0x18U    // Flash Write Erase Protection Register
#define FLASH_O_FT9U            0x8CU    // Flash 9us Timing Register
#define FLASH_O_FT20U           0x90U    // Flash 20us Timing Register
#define FLASH_O_FT50U           0x98U    // Flash 50us Timing Register
#define FLASH_O_FT3P6M          0xA0U    // Flash 3.6ms Timing Register
#define FLASH_O_FT9M            0xA4U    // Flash 9ms Timing Register


//*************************************************************************************************
//
// The following are defines for the bit fields in the FRDCNTL register
//
//*************************************************************************************************
#define FLASH_FRDCNTL_RWAIT_S   0U
#define FLASH_FRDCNTL_RWAIT_M   0xFU   // Flash Read Wait Configuration

//*************************************************************************************************
//
// The following are defines for the bit fields in the FMSTAT register
//
//*************************************************************************************************
#define FLASH_FMSTAT_STAT_S        0U
#define FLASH_FMSTAT_STAT_M        0x3FU   // Flash Status
#define FLASH_FMSTAT_INIT_FINISH   0x40U   // Flash Init Finish Flag
#define FLASH_FMSTAT_FLASH_MODE    0x80U   // Flash CP-Test Mode

//*************************************************************************************************
//
// The following are defines for the bit fields in the FRD_INTF_CTRL register
//
//*************************************************************************************************
#define FLASH_FRD_INTF_CTRL_PREFETCH_EN     0x1U   // Flash Prefetch Enable Flag
#define FLASH_FRD_INTF_CTRL_DATA_CACHE_EN   0x2U   // Flash Data Cache Enable Flag

//*************************************************************************************************
//
// The following are defines for the bit fields in the FLPROT register
//
//*************************************************************************************************
#define FLASH_FLPROT_FLWEPROT   0x1U   // Flash Write Erase Protect Configuration



#endif
