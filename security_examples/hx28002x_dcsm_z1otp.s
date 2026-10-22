/***************************************************************
 * Copyright (c) 2019-2026, Beijing Haawking Technology Co., Ltd
 *
 * Author      : Silin Luo
 * File        : hx28002x_dcsm_z1otp.s
 * Description :
 *   RISC-V/GAS style Zone 1 DCSM OTP template.
 *
 *   This file is intentionally organized to mirror the TI
 *   f28002x DCSM OTP asm layout, while using GNU assembler syntax
 *   for the Haawking RISC-V toolchain.
 *
 *   This is a data template, not executable code.
 ***************************************************************/

#----------------------------------------------------------------------
# Bank0 Zone1 OTP LINKPOINTER
#----------------------------------------------------------------------
.section "b0_dcsm_otp_z1_linkpointer","a",@progbits
.word 0x1FFFFFFF      # B0_Z1OTP_LINKPOINTER1
# .word 0xFFFFFFFF      # Reserved
.word 0x1FFFFFFF      # B0_Z1OTP_LINKPOINTER2
# .word 0xFFFFFFFF      # Reserved
.word 0x1FFFFFFF      # B0_Z1OTP_LINKPOINTER3
# .word 0xFFFFFFFF      # Reserved

#----------------------------------------------------------------------
# Bank0 Zone1 OTP GPREG
#----------------------------------------------------------------------
.section "b0_dcsm_otp_z1_gpreg","a",@progbits
# .word 0x5AFF1820      # Z1OTP_BOOTPIN_CONFIG / Z1OTP_GPREG1
# .word 0x5AFFFFFF      # Z1OTP_GPREG2

#----------------------------------------------------------------------
# Bank0 Zone1 OTP PSWDLOCK
#----------------------------------------------------------------------
.section "b0_dcsm_otp_z1_pswdlock","a",@progbits
# .word 0xFB7FFFFF      # Z1OTP_PSWDLOCK
# .word 0x7FFFFFFF      # Reserved

#----------------------------------------------------------------------
# Bank0 Zone1 OTP CRCLOCK
#----------------------------------------------------------------------
.section "b0_dcsm_otp_z1_crclock","a",@progbits
# .word 0x4BFFFFFF      # Z1OTP_CRCLOCK
# .word 0x3FFFFFFF      # Reserved

#----------------------------------------------------------------------
# Bank0 Zone1 OTP JTAGLOCK
#----------------------------------------------------------------------
.section "b0_dcsm_otp_z1_jtaglock","ax",@progbits
// Uncomment only when this section of data needs to be modified.
# .word 0xDBFFFFFF      # Z1OTP_JTAGLOCK
# .word 0x07FFFFFF		# Reserved

#----------------------------------------------------------------------
# Bank0 Zone1 OTP BOOTCTRL
#----------------------------------------------------------------------
.section "b0_dcsm_otp_z1_bootctrl","a",@progbits
# .word 0x00000000      # Z1OTP_GPREG3 / BOOTDEF_LOW
# .word 0xFFFFFFFF      # Z1OTP_BOOTCTRL / BOOTDEF_HIGH

#----------------------------------------------------------------------
# Bank0 Zone1 Zone Select Block
# Offset +0x00 : EXEONLYRAM
# Offset +0x04 : EXEONLYSECT
# Offset +0x08 : GRABRAM
# Offset +0x0C : GRABSECT
# Offset +0x10 : CSMPSWD0
# Offset +0x14 : CSMPSWD1
# Offset +0x18 : CSMPSWD2
# Offset +0x1C : CSMPSWD3
#----------------------------------------------------------------------
.section "b0_dcsm_zsel_z1","a",@progbits
# .word 0xAAAAAAAA      # Z1OTP_EXEONLYRAM
# .word 0xAAAAAAAA      # B0_Z1OTP_EXEONLYSECT
# .word 0xAAAAAAAA      # Z1OTP_GRABRAM
.word 0xAAAAA9AA      # B0_Z1OTP_GRABSECT

.word 0x11111111      # Z1OTP_CSMPSWD0
.word 0x22222222      # Z1OTP_CSMPSWD1
.word 0x33333333      # Z1OTP_CSMPSWD2
.word 0x44444444      # Z1OTP_CSMPSWD3

#----------------------------------------------------------------------
# Bank1 Zone1 OTP LINKPOINTER
# Keep this block only if Haawking TRM/linker later confirms Bank1 use.
#----------------------------------------------------------------------
.section "b1_dcsm_otp_z1_linkpointer","a",@progbits
# .word 0x1FFFFFFF      # B1_Z1OTP_LINKPOINTER1
# .word 0xFFFFFFFF      # Reserved
# .word 0x1FFFFFFF      # B1_Z1OTP_LINKPOINTER2
# .word 0xFFFFFFFF      # Reserved
# .word 0x1FFFFFFF      # B1_Z1OTP_LINKPOINTER3
# .word 0xFFFFFFFF      # Reserved

#----------------------------------------------------------------------
# Bank1 Zone1 Zone Select Block
# Keep this block only if Haawking TRM/linker later confirms Bank1 use.
#----------------------------------------------------------------------
.section "b1_dcsm_zsel_z1","a",@progbits
# .word 0xFFFFFFFF      # Reserved
# .word 0xFFFFFFFF      # B1_Z1OTP_EXEONLYSECT
# .word 0xFFFFFFFF      # Reserved
# .word 0xFFFFFFFF      # B1_Z1OTP_GRABSECT
#
# .word 0xFFFFFFFF      # Reserved
# .word 0xFFFFFFFF      # Reserved
# .word 0xFFFFFFFF      # Reserved
# .word 0xFFFFFFFF      # Reserved

#----------------------------------------------------------------------
# Optional reserved OTP fill for final production lock-down
#----------------------------------------------------------------------
# .section "dcsm_rsvd_z1","a",@progbits
# .rept 0x1E0
# .word 0x00000000
# .endr

/***************************************************************
 * End of file
 ***************************************************************/
