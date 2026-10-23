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
/* Release for HXS320F2800137EDE, Peripheral Linker, 1.0.0                     */
/*                                                                             */
/* Release time: 2025-01-23 11:30:54.551212                                    */
/*                                                                             */
/*#############################################################################*/


/*----------------------------------------------------------------------*/
/* Memories                                                             */
/*----------------------------------------------------------------------*/
MEMORY
{
    AdcaRegs_FILE                   (rwx)  : ORIGIN = 0x00108000, LENGTH = 0x00000140         /* Adca registers */               
    AdcaResultRegs_FILE             (rwx)  : ORIGIN = 0x00108140, LENGTH = 0x00000050         /* AdcaResult registers */         
    AdcaCtl3Regs_FILE               (rwx)  : ORIGIN = 0x00108190, LENGTH = 0x00000004         /* AdcaCtl3 registers */           
    AdccRegs_FILE                   (rwx)  : ORIGIN = 0x00108200, LENGTH = 0x00000140         /* Adcc registers */               
    AdccResultRegs_FILE             (rwx)  : ORIGIN = 0x00108340, LENGTH = 0x00000050         /* AdccResult registers */         
    AdccCtl3Regs_FILE               (rwx)  : ORIGIN = 0x00108390, LENGTH = 0x00000004         /* AdccCtl3 registers */           
    MemCfgRegs_FILE                 (rwx)  : ORIGIN = 0x00100C00, LENGTH = 0x0000002C         /* MemCfg registers */             
    AccessProtectionRegs_FILE       (rwx)  : ORIGIN = 0x00100C2C, LENGTH = 0x00000018         /* AccessProtection registers */   
    BistRegs_FILE                   (rwx)  : ORIGIN = 0x00100C44, LENGTH = 0x00000010         /* Bist registers */               
    CpuTimer0Regs_FILE              (rwx)  : ORIGIN = 0x00101000, LENGTH = 0x00000010         /* CpuTimer0 registers */          
    CpuTimer1Regs_FILE              (rwx)  : ORIGIN = 0x00101010, LENGTH = 0x00000010         /* CpuTimer1 registers */          
    CpuTimer2Regs_FILE              (rwx)  : ORIGIN = 0x00101020, LENGTH = 0x00000010         /* CpuTimer2 registers */          
    PieCtrlRegs_FILE                (rwx)  : ORIGIN = 0x00101100, LENGTH = 0x00000068         /* PieCtrl registers */            
    XintRegs_FILE                   (rwx)  : ORIGIN = 0x00101200, LENGTH = 0x00000020         /* Xint registers */               
    NmiIntruptRegs_FILE             (rwx)  : ORIGIN = 0x00101300, LENGTH = 0x00000034         /* NmiIntrupt registers */         
    PieVectTable_FILE               (rwx)  : ORIGIN = 0x00102000, LENGTH = 0x00000200         /* PieVectT registers */                  
    EPwm1Regs_FILE                  (rwx)  : ORIGIN = 0x00200000, LENGTH = 0x00000400         /* EPwm1 registers */              
    EPwm2Regs_FILE                  (rwx)  : ORIGIN = 0x00200400, LENGTH = 0x00000400         /* EPwm2 registers */              
    EPwm3Regs_FILE                  (rwx)  : ORIGIN = 0x00200800, LENGTH = 0x00000400         /* EPwm3 registers */              
    EPwm4Regs_FILE                  (rwx)  : ORIGIN = 0x00200C00, LENGTH = 0x00000400         /* EPwm4 registers */              
    EPwm5Regs_FILE                  (rwx)  : ORIGIN = 0x00201000, LENGTH = 0x00000400         /* EPwm5 registers */              
    EPwm6Regs_FILE                  (rwx)  : ORIGIN = 0x00201400, LENGTH = 0x00000400         /* EPwm6 registers */              
    EPwm7Regs_FILE                  (rwx)  : ORIGIN = 0x00201800, LENGTH = 0x00000400         /* EPwm7 registers */              
    ECap1Regs_FILE                  (rwx)  : ORIGIN = 0x00202000, LENGTH = 0x00000040         /* ECap1 registers */              
    Cmpss1Regs_FILE                 (rwx)  : ORIGIN = 0x00202100, LENGTH = 0x00000058         /* Cmpss1 registers */             
    CmpssLite3Regs_FILE             (rwx)  : ORIGIN = 0x00202200, LENGTH = 0x00000040         /* CmpssLite3 registers */         
    EQep1Regs_FILE                  (rwx)  : ORIGIN = 0x00202300, LENGTH = 0x00000070         /* EQep1 registers */              
    SpiaRegs_FILE                   (rwx)  : ORIGIN = 0x00202380, LENGTH = 0x00000030         /* Spia registers */               
    SciaRegs_FILE                   (rwx)  : ORIGIN = 0x00202400, LENGTH = 0x00000040         /* Scia registers */               
    ScibRegs_FILE                   (rwx)  : ORIGIN = 0x00202480, LENGTH = 0x00000040         /* Scib registers */               
    ScicRegs_FILE                   (rwx)  : ORIGIN = 0x00202500, LENGTH = 0x00000040         /* Scic registers */               
    I2caRegs_FILE                   (rwx)  : ORIGIN = 0x00202580, LENGTH = 0x00000040         /* I2ca registers */               
    InputXbarRegs_FILE              (rwx)  : ORIGIN = 0x00213000, LENGTH = 0x0000007C         /* InputXbar registers */          
    XbarRegs_FILE                   (rwx)  : ORIGIN = 0x00213080, LENGTH = 0x00000020         /* Xbar registers */               
    EPwmXbarRegs_FILE               (rwx)  : ORIGIN = 0x00213400, LENGTH = 0x00000080         /* EPwmXbar registers */           
    OutputXbarRegs_FILE             (rwx)  : ORIGIN = 0x00213600, LENGTH = 0x00000080         /* OutputXbar registers */         
    Dcc0Regs_FILE                   (rwx)  : ORIGIN = 0x00214400, LENGTH = 0x00000040         /* Dcc0 registers */               
    GpioCtrlRegs_FILE               (rwx)  : ORIGIN = 0x00214800, LENGTH = 0x00000408         /* GpioCtrl registers */           
    GpioDataRegs_FILE               (rwx)  : ORIGIN = 0x00214E00, LENGTH = 0x00000080         /* GpioData registers */           
    GpioDataReadRegs_FILE           (rwx)  : ORIGIN = 0x00214F00, LENGTH = 0x00000020         /* GpioDataRead registers */       
    ClkCfgRegs_FILE                 (rwx)  : ORIGIN = 0x00218000, LENGTH = 0x00000088         /* ClkCfg registers */             
    CpuSysRegs_FILE                 (rwx)  : ORIGIN = 0x00218200, LENGTH = 0x00000160         /* CpuSys registers */             
    DevCfgRegs_FILE                 (rwx)  : ORIGIN = 0x00218400, LENGTH = 0x00000340         /* DevCfg registers */             
    SyncSocRegs_FILE                (rwx)  : ORIGIN = 0x00218C00, LENGTH = 0x0000000C         /* SyncSoc registers */            
    SysStatusRegs_FILE              (rwx)  : ORIGIN = 0x00218C20, LENGTH = 0x00000010         /* SysStatus registers */          
    WdRegs_FILE                     (rwx)  : ORIGIN = 0x00218E00, LENGTH = 0x00000058         /* Wd registers */                 
    TrimCfgRegs_FILE                (rwx)  : ORIGIN = 0x00218F00, LENGTH = 0x00000050         /* TrimCfg registers */            
    UidRegs_FILE                    (rwx)  : ORIGIN = 0x006463C0, LENGTH = 0x00000020         /* Uid registers */                
    AnalogSubsysRegs_FILE           (rwx)  : ORIGIN = 0x00219000, LENGTH = 0x00000040         /* AnalogSubsys registers */       
    DcsmZ1Regs_FILE                 (rwx)  : ORIGIN = 0x00219400, LENGTH = 0x00000080         /* DcsmZ1 registers */             
    DcsmZ2Regs_FILE                 (rwx)  : ORIGIN = 0x00219480, LENGTH = 0x00000080         /* DcsmZ2 registers */             
    DcsmCommonRegs_FILE             (rwx)  : ORIGIN = 0x00219500, LENGTH = 0x00000050         /* DcsmCommon registers */         
    DcsmZ1OtpRegs_FILE              (rwx)  : ORIGIN = 0x00640000, LENGTH = 0x00000400         /* DcsmZ1Otp registers */          
    DcsmZ2OtpRegs_FILE              (rwx)  : ORIGIN = 0x00640400, LENGTH = 0x00000400         /* DcsmZ2Otp registers */          
    Flash0CtrlRegs_FILE             (rwx)  : ORIGIN = 0x00641000, LENGTH = 0x00000300         /* Flash0Ctrl registers */         
}

/*----------------------------------------------------------------------*/
/* Sections                                                             */
/*----------------------------------------------------------------------*/
SECTIONS
{
    .AdcaRegs(NOLOAD)              : {*(.AdcaRegs)}              > AdcaRegs_FILE          
    .AdcaResultRegs(NOLOAD)        : {*(.AdcaResultRegs)}        > AdcaResultRegs_FILE    
    .AdcaCtl3Regs(NOLOAD)          : {*(.AdcaCtl3Regs)}          > AdcaCtl3Regs_FILE      
    .AdccRegs(NOLOAD)              : {*(.AdccRegs)}              > AdccRegs_FILE          
    .AdccResultRegs(NOLOAD)        : {*(.AdccResultRegs)}        > AdccResultRegs_FILE    
    .AdccCtl3Regs(NOLOAD)          : {*(.AdccCtl3Regs)}          > AdccCtl3Regs_FILE      
    .MemCfgRegs(NOLOAD)            : {*(.MemCfgRegs)}            > MemCfgRegs_FILE        
    .AccessProtectionRegs(NOLOAD)  : {*(.AccessProtectionRegs)}  > AccessProtectionRegs_FILE
    .BistRegs(NOLOAD)              : {*(.BistRegs)}              > BistRegs_FILE          
    .CpuTimer0Regs(NOLOAD)         : {*(.CpuTimer0Regs)}         > CpuTimer0Regs_FILE     
    .CpuTimer1Regs(NOLOAD)         : {*(.CpuTimer1Regs)}         > CpuTimer1Regs_FILE     
    .CpuTimer2Regs(NOLOAD)         : {*(.CpuTimer2Regs)}         > CpuTimer2Regs_FILE     
    .PieCtrlRegs(NOLOAD)           : {*(.PieCtrlRegs)}           > PieCtrlRegs_FILE       
    .XintRegs(NOLOAD)              : {*(.XintRegs)}              > XintRegs_FILE          
    .NmiIntruptRegs(NOLOAD)        : {*(.NmiIntruptRegs)}        > NmiIntruptRegs_FILE    
    .PieVectTable(NOLOAD)          : {*(.PieVectTable)}          > PieVectTable_FILE      
    .EPwm1Regs(NOLOAD)             : {*(.EPwm1Regs)}             > EPwm1Regs_FILE         
    .EPwm2Regs(NOLOAD)             : {*(.EPwm2Regs)}             > EPwm2Regs_FILE         
    .EPwm3Regs(NOLOAD)             : {*(.EPwm3Regs)}             > EPwm3Regs_FILE         
    .EPwm4Regs(NOLOAD)             : {*(.EPwm4Regs)}             > EPwm4Regs_FILE         
    .EPwm5Regs(NOLOAD)             : {*(.EPwm5Regs)}             > EPwm5Regs_FILE         
    .EPwm6Regs(NOLOAD)             : {*(.EPwm6Regs)}             > EPwm6Regs_FILE         
    .EPwm7Regs(NOLOAD)             : {*(.EPwm7Regs)}             > EPwm7Regs_FILE         
    .ECap1Regs(NOLOAD)             : {*(.ECap1Regs)}             > ECap1Regs_FILE         
    .Cmpss1Regs(NOLOAD)            : {*(.Cmpss1Regs)}            > Cmpss1Regs_FILE        
    .CmpssLite3Regs(NOLOAD)        : {*(.CmpssLite3Regs)}        > CmpssLite3Regs_FILE    
    .EQep1Regs(NOLOAD)             : {*(.EQep1Regs)}             > EQep1Regs_FILE         
    .SpiaRegs(NOLOAD)              : {*(.SpiaRegs)}              > SpiaRegs_FILE          
    .SciaRegs(NOLOAD)              : {*(.SciaRegs)}              > SciaRegs_FILE          
    .ScibRegs(NOLOAD)              : {*(.ScibRegs)}              > ScibRegs_FILE          
    .ScicRegs(NOLOAD)              : {*(.ScicRegs)}              > ScicRegs_FILE          
    .I2caRegs(NOLOAD)              : {*(.I2caRegs)}              > I2caRegs_FILE          
    .InputXbarRegs(NOLOAD)         : {*(.InputXbarRegs)}         > InputXbarRegs_FILE     
    .XbarRegs(NOLOAD)              : {*(.XbarRegs)}              > XbarRegs_FILE          
    .EPwmXbarRegs(NOLOAD)          : {*(.EPwmXbarRegs)}          > EPwmXbarRegs_FILE      
    .OutputXbarRegs(NOLOAD)        : {*(.OutputXbarRegs)}        > OutputXbarRegs_FILE    
    .Dcc0Regs(NOLOAD)              : {*(.Dcc0Regs)}              > Dcc0Regs_FILE          
    .GpioCtrlRegs(NOLOAD)          : {*(.GpioCtrlRegs)}          > GpioCtrlRegs_FILE      
    .GpioDataRegs(NOLOAD)          : {*(.GpioDataRegs)}          > GpioDataRegs_FILE      
    .GpioDataReadRegs(NOLOAD)      : {*(.GpioDataReadRegs)}      > GpioDataReadRegs_FILE  
    .ClkCfgRegs(NOLOAD)            : {*(.ClkCfgRegs)}            > ClkCfgRegs_FILE        
    .CpuSysRegs(NOLOAD)            : {*(.CpuSysRegs)}            > CpuSysRegs_FILE        
    .DevCfgRegs(NOLOAD)            : {*(.DevCfgRegs)}            > DevCfgRegs_FILE        
    .SyncSocRegs(NOLOAD)           : {*(.SyncSocRegs)}           > SyncSocRegs_FILE       
    .SysStatusRegs(NOLOAD)         : {*(.SysStatusRegs)}         > SysStatusRegs_FILE     
    .WdRegs(NOLOAD)                : {*(.WdRegs)}                > WdRegs_FILE            
    .TrimCfgRegs(NOLOAD)           : {*(.TrimCfgRegs)}           > TrimCfgRegs_FILE       
    .UidRegs(NOLOAD)               : {*(.UidRegs)}               > UidRegs_FILE           
    .AnalogSubsysRegs(NOLOAD)      : {*(.AnalogSubsysRegs)}      > AnalogSubsysRegs_FILE  
    .DcsmZ1Regs(NOLOAD)            : {*(.DcsmZ1Regs)}            > DcsmZ1Regs_FILE        
    .DcsmZ2Regs(NOLOAD)            : {*(.DcsmZ2Regs)}            > DcsmZ2Regs_FILE        
    .DcsmCommonRegs(NOLOAD)        : {*(.DcsmCommonRegs)}        > DcsmCommonRegs_FILE    
    .DcsmZ1OtpRegs(NOLOAD)         : {*(.DcsmZ1OtpRegs)}         > DcsmZ1OtpRegs_FILE     
    .DcsmZ2OtpRegs(NOLOAD)         : {*(.DcsmZ2OtpRegs)}         > DcsmZ2OtpRegs_FILE     
    .Flash0CtrlRegs(NOLOAD)        : {*(.Flash0CtrlRegs)}        > Flash0CtrlRegs_FILE    
}
