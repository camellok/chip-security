/***************************************************************
 * Copyright (c) 2019-2026, Beijing Haawking Technology Co., Ltd
 *
 * Author      : Silin Luo
 * File        : hx28002x_dcsm_z2otp.s
 * Description :
 *   Zone 2 user OTP configuration for the Haawking RISC-V assembler.
 *
 *   Field order follows the TI f28002x DCSM examples. DCSM.ld places
 *   each section at its OTP address. Commented-out directives emit
 *   no data, so those locations retain their existing OTP contents.
 *
 *   The sections below contain configuration words, not instructions.
 ***************************************************************/

#----------------------------------------------------------------------
# Bank0 Zone2 OTP LINKPOINTER
# Omitted from this image; retain the existing Zone2 link pointers.
#----------------------------------------------------------------------
.section "b0_dcsm_otp_z2_linkpointer", "a", @progbits
#   .word 0x1FFFFFFF    # B0_Z2OTP_LINKPOINTER1
#   .word 0xFFFFFFFF    # Reserved
#   .word 0x1FFFFFFF    # B0_Z2OTP_LINKPOINTER2
#   .word 0xFFFFFFFF    # Reserved
#   .word 0x1FFFFFFF    # B0_Z2OTP_LINKPOINTER3
#   .word 0xFFFFFFFF    # Reserved

#----------------------------------------------------------------------
# Bank0 Zone2 OTP GPREG
# Optional boot pin and general-purpose settings; omitted from this image.
#----------------------------------------------------------------------
.section "b0_dcsm_otp_z2_gpreg", "a", @progbits
#   .word 0x5AFF1820    # Z2OTP_BOOTPIN_CONFIG / Z2OTP_GPREG1
#   .word 0x5AFFFFFF    # Z2OTP_GPREG2

#----------------------------------------------------------------------
# Bank0 Zone2 OTP PSWDLOCK
# Optional password read protection; omitted from this image.
#----------------------------------------------------------------------
.section "b0_dcsm_otp_z2_pswdlock", "a", @progbits
#   .word 0xBF7FFFFF    # Z2OTP_PSWDLOCK
#   .word 0x77FFFFFF    # Reserved

#----------------------------------------------------------------------
# Bank0 Zone2 OTP CRCLOCK
# Optional secure-memory CRC access control; omitted from this image.
#----------------------------------------------------------------------
.section "b0_dcsm_otp_z2_crclock", "a", @progbits
#   .word 0x0FFFFFFF    # Z2OTP_CRCLOCK: original OTP value at 0x7A0428
#   .word 0x37FFFFFF    # Reserved: original OTP value at 0x7A042C

#----------------------------------------------------------------------
# Bank0 Zone2 OTP JTAGLOCK
#----------------------------------------------------------------------
.section "b0_dcsm_otp_z2_jtaglock", "ax", @progbits
// Optional JTAG lock settings; the words below are omitted from this image.
#   .word 0xDBFFFFFF    # Z2OTP_JTAGLOCK
#   .word 0x07FFFFFF    # Reserved

#----------------------------------------------------------------------
# Bank0 Zone2 OTP BOOTCTRL
# Optional boot definitions; omitted from this image.
#----------------------------------------------------------------------
.section "b0_dcsm_otp_z2_bootctrl", "a", @progbits
#   .word 0x00000000    # Z2OTP_GPREG3 / BOOTDEF_LOW
#   .word 0xFFFFFFFF    # Z2OTP_BOOTCTRL / BOOTDEF_HIGH

#----------------------------------------------------------------------
# Bank0 Zone2 ZSB1
# Byte offsets are relative to the start of this block.
# Offset +0x00 : EXEONLYRAM
# Offset +0x04 : EXEONLYSECT
# Offset +0x08 : GRABRAM
# Offset +0x0C : GRABSECT
# Offset +0x10 : CSMPSWD0
# Offset +0x14 : CSMPSWD1
# Offset +0x18 : CSMPSWD2
# Offset +0x1C : CSMPSWD3
#----------------------------------------------------------------------
.section "b0_dcsm_zsel_z2", "a", @progbits
    .word 0xFFFFFFFF    # B0_Z2OTP_EXEONLYRAM: execute-only disabled
    .word 0xFFFFFFFF    # B0_Z2OTP_EXEONLYSECT: execute-only disabled
    .word 0xFFFFAAFF    # Z2OTP_GRABRAM: LS4-LS7 = 10; reserved bits remain 1
    .word 0xAAAAAAAA    # B0_Z2OTP_GRABSECT: all sectors = 10; no Zone2 claim

# Retain the factory password words read from ZSB1 before programming.
    .word 0xFFFFFFFF    # Z2OTP_CSMPSWD0
    .word 0xE3FFFFFF    # Z2OTP_CSMPSWD1
    .word 0xFFFFFFFF    # Z2OTP_CSMPSWD2
    .word 0xFFFFFFFF    # Z2OTP_CSMPSWD3

#----------------------------------------------------------------------
# Bank1 Zone2 OTP LINKPOINTER
# Inactive Bank1 reference; confirm device support and linker placement before use.
#----------------------------------------------------------------------
.section "b1_dcsm_otp_z2_linkpointer", "a", @progbits
#   .word 0x1FFFFFFF    # B1_Z2OTP_LINKPOINTER1
#   .word 0xFFFFFFFF    # Reserved
#   .word 0x1FFFFFFF    # B1_Z2OTP_LINKPOINTER2
#   .word 0xFFFFFFFF    # Reserved
#   .word 0x1FFFFFFF    # B1_Z2OTP_LINKPOINTER3
#   .word 0xFFFFFFFF    # Reserved

#----------------------------------------------------------------------
# Bank1 Zone2 Zone Select Block
# Inactive Bank1 reference; confirm device support and linker placement before use.
#----------------------------------------------------------------------
.section "b1_dcsm_zsel_z2", "a", @progbits
#   .word 0xFFFFFFFF    # Reserved
#   .word 0xFFFFFFFF    # B1_Z2OTP_EXEONLYSECT
#   .word 0xFFFFFFFF    # Reserved
#   .word 0xFFFFFFFF    # B1_Z2OTP_GRABSECT
#
#   .word 0xFFFFFFFF    # Reserved
#   .word 0xFFFFFFFF    # Reserved
#   .word 0xFFFFFFFF    # Reserved
#   .word 0xFFFFFFFF    # Reserved

#----------------------------------------------------------------------
# Optional reserved OTP fill for the final production image
#----------------------------------------------------------------------
# .section "dcsm_rsvd_z2", "a", @progbits
# .rept 0x1E0
#   .word 0x00000000
# .endr

/***************************************************************
 * End of file
 ***************************************************************/
