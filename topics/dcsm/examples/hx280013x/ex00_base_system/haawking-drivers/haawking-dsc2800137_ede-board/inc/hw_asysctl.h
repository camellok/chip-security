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


#ifndef HW_ANALOGSUBSYS_H
#define HW_ANALOGSUBSYS_H

//*************************************************************************************************
//
// The following are defines for the ASYSCTL register offsets
//
//*************************************************************************************************
#define ASYSCTL_O_TSNSCTL       0x4U    // Temperature Sensor Control Register
#define ASYSCTL_O_ANAREFCTL     0x8U    // Analog Reference Control Register. This register is not configurable for 32QFN package
#define ASYSCTL_O_VMONCTL       0xCU    // Voltage Monitor Control Register
#define ASYSCTL_O_CMPHPMXSEL    0x10U   // Bits to select one of the many sources on CompHP inputs. Refer to Pimux diagram for details.
#define ASYSCTL_O_CMPLPMXSEL    0x14U   // Bits to select one of the many sources on CompLP inputs. Refer to Pimux diagram for details.
#define ASYSCTL_O_CMPHNMXSEL    0x18U   // Bits to select one of the many sources on CompHN inputs. Refer to Pimux diagram for details.
#define ASYSCTL_O_CMPLNMXSEL    0x1CU   // Bits to select one of the many sources on CompLN inputs. Refer to Pimux diagram for details.
#define ASYSCTL_O_LOCK          0x24U   // Lock Register
#define ASYSCTL_O_PMULDOCTL     0x30U   // Pmu Ldo Control Register
#define ASYSCTL_O_CMPDELAY      0x34U   //  
#define ASYSCTL_O_ANABUFCHSEL   0x38U   //  


//*************************************************************************************************
//
// The following are defines for the bit fields in the TSNSCTL register
//
//*************************************************************************************************
#define ASYSCTL_TSNSCTL_TSNSCEN   0x1U   // Temperature Sensor Enable

//*************************************************************************************************
//
// The following are defines for the bit fields in the ANAREFCTL register
//
//*************************************************************************************************
#define ASYSCTL_ANAREFCTL_ADCAVREFHIEN    0x2U      // ADC-A reference voltage is enabled
#define ASYSCTL_ANAREFCTL_ADCCVREFHIEN    0x4U      // ADC-C reference voltage is enabled
#define ASYSCTL_ANAREFCTL_ANAREFAVDDSEL   0x80U     // Analog Reference A Select
#define ASYSCTL_ANAREFCTL_ANAREFCVDDSEL   0x8000U   // Analog Reference C Select

//*************************************************************************************************
//
// The following are defines for the bit fields in the VMONCTL register
//
//*************************************************************************************************
#define ASYSCTL_VMONCTL_REGVORLV_S    0U
#define ASYSCTL_VMONCTL_REGVORLV_M    0x7U     // BOR Level Configuration
#define ASYSCTL_VMONCTL_BORLVMONDIS   0x100U   // Disable BOR feature on VDDIO

//*************************************************************************************************
//
// The following are defines for the bit fields in the CMPHPMXSEL register
//
//*************************************************************************************************
#define ASYSCTL_CMPHPMXSEL_CMP1HPMXSEL_S   0U
#define ASYSCTL_CMPHPMXSEL_CMP1HPMXSEL_M   0xFU     // CMP1HPMXSEL bits
#define ASYSCTL_CMPHPMXSEL_CMP3HPMXSEL_S   8U
#define ASYSCTL_CMPHPMXSEL_CMP3HPMXSEL_M   0xF00U   // CMP3HPMXSEL bits

//*************************************************************************************************
//
// The following are defines for the bit fields in the CMPLPMXSEL register
//
//*************************************************************************************************
#define ASYSCTL_CMPLPMXSEL_CMP1LPMXSEL_S   0U
#define ASYSCTL_CMPLPMXSEL_CMP1LPMXSEL_M   0xFU     // CMP1LPMXSEL bits
#define ASYSCTL_CMPLPMXSEL_CMP3LPMXSEL_S   8U
#define ASYSCTL_CMPLPMXSEL_CMP3LPMXSEL_M   0xF00U   // CMP3LPMXSEL bits

//*************************************************************************************************
//
// The following are defines for the bit fields in the CMPHNMXSEL register
//
//*************************************************************************************************
#define ASYSCTL_CMPHNMXSEL_CMP1HNMXSEL_S   0U
#define ASYSCTL_CMPHNMXSEL_CMP1HNMXSEL_M   0x7U     // CMP1HNMXSEL bits
#define ASYSCTL_CMPHNMXSEL_CMP3HNMXSEL_S   6U
#define ASYSCTL_CMPHNMXSEL_CMP3HNMXSEL_M   0x1C0U   // CMP3HNMXSEL bits

//*************************************************************************************************
//
// The following are defines for the bit fields in the CMPLNMXSEL register
//
//*************************************************************************************************
#define ASYSCTL_CMPLNMXSEL_CMP1LNMXSEL_S   0U
#define ASYSCTL_CMPLNMXSEL_CMP1LNMXSEL_M   0x7U     // CMP1LNMXSEL bits
#define ASYSCTL_CMPLNMXSEL_CMP3LNMXSEL_S   6U
#define ASYSCTL_CMPLNMXSEL_CMP3LNMXSEL_M   0x1C0U   // CMP3LNMXSEL bits

//*************************************************************************************************
//
// The following are defines for the bit fields in the LOCK register
//
//*************************************************************************************************
#define ASYSCTL_LOCK_TSNSCTL       0x1U      // TSNSCTL Register lock bit
#define ASYSCTL_LOCK_ANAREFCTL     0x2U      // ANAREFCTL Register lock bit
#define ASYSCTL_LOCK_VMONCTL       0x4U      // VMONCTL Register lock bit
#define ASYSCTL_LOCK_CMPHPMXSEL    0x20U     // CMPHPMXSEL Register lock bit
#define ASYSCTL_LOCK_CMPLPMXSEL    0x40U     // CMPLPMXSEL Register lock bit
#define ASYSCTL_LOCK_CMPHNMXSEL    0x80U     // CMPHNMXSEL Register lock bit
#define ASYSCTL_LOCK_CMPLNMXSEL    0x100U    // CMPLNMXSEL Register lock bit
#define ASYSCTL_LOCK_VREGCTL       0x200U    // VREGCTL Register lock bit
#define ASYSCTL_LOCK_PMULDOCTL     0x800U    // PMULDOCTL Register lock bit
#define ASYSCTL_LOCK_CMPMXDELAY    0x1000U   // CMPMXDELAY Register lock bit
#define ASYSCTL_LOCK_ANABUFCHSEL   0x2000U   // ANABUFCHSEL Register lock bit

//*************************************************************************************************
//
// The following are defines for the bit fields in the PMULDOCTL register
//
//*************************************************************************************************
#define ASYSCTL_PMULDOCTL_PMUVREFHIEN   0x1U   // Pmu Vrefhi Enable

//*************************************************************************************************
//
// The following are defines for the bit fields in the CMPDELAY register
//
//*************************************************************************************************
#define ASYSCTL_CMPDELAY_CMPMXDELAY_S   0U
#define ASYSCTL_CMPDELAY_CMPMXDELAY_M   0xFFU   //  

//*************************************************************************************************
//
// The following are defines for the bit fields in the ANABUFCHSEL register
//
//*************************************************************************************************
#define ASYSCTL_ANABUFCHSEL_ADCABUFCHSEL_S   0U
#define ASYSCTL_ANABUFCHSEL_ADCABUFCHSEL_M   0x7U     //  
#define ASYSCTL_ANABUFCHSEL_ADCCBUFCHSEL_S   6U
#define ASYSCTL_ANABUFCHSEL_ADCCBUFCHSEL_M   0x1C0U   //  
#define ASYSCTL_ANABUFCHSEL_TSNSAEN          0x200U   //  



#endif
