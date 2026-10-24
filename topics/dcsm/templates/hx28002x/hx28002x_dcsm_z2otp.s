/***************************************************************
 * Copyright (c) 2019-2026, Beijing Haawking Technology Co., Ltd
 *
 * Author      : Silin Luo
 * File        : hx28002x_dcsm_z2otp.s
 * Description :
 *   RISC-V/GAS style Zone 2 DCSM OTP template.
 *
 *   This file is intentionally organized to mirror the TI
 *   f28002x DCSM OTP asm layout, while using GNU assembler syntax
 *   for the Haawking RISC-V toolchain.
 *
 *   This is a data template, not executable code.
 ***************************************************************/

#----------------------------------------------------------------------
# Bank0 Zone2 OTP LINKPOINTER
#----------------------------------------------------------------------
.section "b0_dcsm_otp_z2_linkpointer","a",@progbits
# .word 0x1FFFFFFF      # B0_Z2OTP_LINKPOINTER1
# .word 0xFFFFFFFF      # Reserved
# .word 0x1FFFFFFF      # B0_Z2OTP_LINKPOINTER2
# .word 0xFFFFFFFF      # Reserved
# .word 0x1FFFFFFF      # B0_Z2OTP_LINKPOINTER3
# .word 0xFFFFFFFF      # Reserved

#----------------------------------------------------------------------
# Bank0 Zone2 OTP GPREG
#----------------------------------------------------------------------
.section "b0_dcsm_otp_z2_gpreg","a",@progbits
# .word 0x5AFF1820      # Z2OTP_BOOTPIN_CONFIG / Z2OTP_GPREG1
# .word 0x5AFFFFFF      # Z2OTP_GPREG2

#----------------------------------------------------------------------
# Bank0 Zone2 OTP PSWDLOCK
#----------------------------------------------------------------------
.section "b0_dcsm_otp_z2_pswdlock","a",@progbits
# .word 0xBF7FFFFF      # Z2OTP_PSWDLOCK
# .word 0x77FFFFFF      # Reserved

#----------------------------------------------------------------------
# Bank0 Zone2 OTP CRCLOCK
#----------------------------------------------------------------------
.section "b0_dcsm_otp_z2_crclock","a",@progbits
# .word 0x4BFFFFFF      # Z2OTP_CRCLOCK
# .word 0x3FFFFFFF      # Reserved

#----------------------------------------------------------------------
# Bank0 Zone2 OTP JTAGLOCK
#----------------------------------------------------------------------
.section "b0_dcsm_otp_z2_jtaglock","ax",@progbits
// Uncomment only when this section of data needs to be modified.
# .word 0xDBFFFFFF      # Z2OTP_JTAGLOCK
# .word 0x07FFFFFF		# Reserved

#----------------------------------------------------------------------
# Bank0 Zone2 OTP BOOTCTRL
#----------------------------------------------------------------------
.section "b0_dcsm_otp_z2_bootctrl","a",@progbits
# .word 0x00000000      # Z2OTP_GPREG3 / BOOTDEF_LOW
# .word 0xFFFFFFFF      # Z2OTP_BOOTCTRL / BOOTDEF_HIGH

#----------------------------------------------------------------------
# Bank0 Zone2 Zone Select Block
# Offset +0x00 : EXEONLYRAM
# Offset +0x04 : EXEONLYSECT
# Offset +0x08 : GRABRAM
# Offset +0x0C : GRABSECT
# Offset +0x10 : CSMPSWD0
# Offset +0x14 : CSMPSWD1
# Offset +0x18 : CSMPSWD2
# Offset +0x1C : CSMPSWD3
#----------------------------------------------------------------------
.section "b0_dcsm_zsel_z2","a",@progbits
# .word 0xFFFFFFFF      # B0_Z2OTP_EXEONLYRAM
# .word 0xFFFFFFFF      # B0_Z2OTP_EXEONLYSECT
# .word 0xFFFFFFFF      # Z2OTP_GRABRAM
# .word 0xFFFFFFFF      # B0_Z2OTP_GRABSECT
#
# .word 0xFFFFFFFF      # Z2OTP_CSMPSWD0
# .word 0xE3FFFFFF      # Z2OTP_CSMPSWD1
# .word 0xFFFFFFFF      # Z2OTP_CSMPSWD2
# .word 0xFFFFFFFF      # Z2OTP_CSMPSWD3

#----------------------------------------------------------------------
# Bank1 Zone2 OTP LINKPOINTER
# Keep this block only if Haawking TRM/linker later confirms Bank1 use.
#----------------------------------------------------------------------
.section "b1_dcsm_otp_z2_linkpointer","a",@progbits
# .word 0x1FFFFFFF      # B1_Z2OTP_LINKPOINTER1
# .word 0xFFFFFFFF      # Reserved
# .word 0x1FFFFFFF      # B1_Z2OTP_LINKPOINTER2
# .word 0xFFFFFFFF      # Reserved
# .word 0x1FFFFFFF      # B1_Z2OTP_LINKPOINTER3
# .word 0xFFFFFFFF      # Reserved

#----------------------------------------------------------------------
# Bank1 Zone2 Zone Select Block
# Keep this block only if Haawking TRM/linker later confirms Bank1 use.
#----------------------------------------------------------------------
.section "b1_dcsm_zsel_z2","a",@progbits
# .word 0xFFFFFFFF      # Reserved
# .word 0xFFFFFFFF      # B1_Z2OTP_EXEONLYSECT
# .word 0xFFFFFFFF      # Reserved
# .word 0xFFFFFFFF      # B1_Z2OTP_GRABSECT
#
# .word 0xFFFFFFFF      # Reserved
# .word 0xFFFFFFFF      # Reserved
# .word 0xFFFFFFFF      # Reserved
# .word 0xFFFFFFFF      # Reserved

#----------------------------------------------------------------------
# Optional reserved OTP fill for final production lock-down
#----------------------------------------------------------------------
# .section "dcsm_rsvd_z2","a",@progbits
# .rept 0x1E0
# .word 0x00000000
# .endr

/***************************************************************
 * End of file
 ***************************************************************/
