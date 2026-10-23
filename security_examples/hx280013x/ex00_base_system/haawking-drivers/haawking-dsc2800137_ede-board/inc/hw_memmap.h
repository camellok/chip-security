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

#ifndef HW_MEMMAP_H
#define HW_MEMMAP_H


//*****************************************************************************
//
// The following are defines for the base address of the memories and
// peripherals.
//
//*****************************************************************************
#define M0_RAM_BASE                               0x00000000U
#define LS0_RAM_BASE                              0x00010000U
#define ADCA_BASE                                 0x00108000U
#define ADCACTL3_BASE                             0x00108190U
#define ADCARESULT_BASE                           0x00108140U
#define ADCC_BASE                                 0x00108200U
#define ADCCCTL3_BASE                             0x00108390U
#define ADCCRESULT_BASE                           0x00108340U
#define MEMCFG_BASE                               0x00100C00U
#define ACCESSPROTECTION_BASE                     0x00100C2CU
#define BIST_BASE                                 0x00100C44U
#define CPUTIMER0_BASE                            0x00101000U
#define CPUTIMER1_BASE                            0x00101010U
#define CPUTIMER2_BASE                            0x00101020U
#define PIECTRL_BASE                              0x00101100U
#define XINT_BASE                                 0x00101200U
#define NMI_BASE                                  0x00101300U
#define PIEVECTTABLE_BASE                         0x00102000U
#define EPWM1_BASE                                0x00200000U
#define EPWM2_BASE                                0x00200400U
#define EPWM3_BASE                                0x00200800U
#define EPWM4_BASE                                0x00200C00U
#define EPWM5_BASE                                0x00201000U
#define EPWM6_BASE                                0x00201400U
#define EPWM7_BASE                                0x00201800U
#define ECAP1_BASE                                0x00202000U
#define CMPSS1_BASE                               0x00202100U
#define CMPSSLITE3_BASE                           0x00202200U
#define EQEP1_BASE                                0x00202300U
#define SPIA_BASE                                 0x00202380U
#define SCIA_BASE                                 0x00202400U
#define SCIB_BASE                                 0x00202480U
#define SCIC_BASE                                 0x00202500U
#define I2CA_BASE                                 0x00202580U
#define INPUTXBAR_BASE                            0x00213000U
#define XBAR_BASE                                 0x00213080U
#define EPWMXBAR_BASE                             0x00213400U
#define OUTPUTXBAR_BASE                           0x00213600U
#define DCC0_BASE                                 0x00214400U
#define GPIOCTRL_BASE                             0x00214800U
#define GPIODATA_BASE                             0x00214E00U
#define GPIODATAREAD_BASE                         0x00214F00U
#define CLKCFG_BASE                               0x00218000U
#define CPUSYS_BASE                               0x00218200U
#define DEVCFG_BASE                               0x00218400U
#define SYNCSOC_BASE                              0x00218C00U
#define SYSSTAT_BASE                              0x00218C20U
#define WD_BASE                                   0x00218E00U
#define TRIM_CFG_BASE                             0x00218F00U
#define UID_BASE                                  0x006463C0U
#define ANALOGSUBSYS_BASE                         0x00219000U
#define DCSM_Z1_BASE                              0x00219400U
#define DCSM_Z2_BASE                              0x00219480U
#define DCSMCOMMON_BASE                           0x00219500U
#define DCSM_Z1OTP_BASE                           0x00640000U
#define DCSM_Z2OTP_BASE                           0x00640400U
#define FLASH0CTRL_BASE                           0x00641000U
#endif
