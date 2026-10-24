/***************************************************************
 * Copyright (c) 2019-2026, Beijing Haawking Technology Co., Ltd
 *
 * Author      : Silin Luo
 * File        : hx28002x_dcsm_z1otp.s
 * Description :
 *   Zone 1 user OTP configuration for the Haawking RISC-V assembler.
 *
 *   Field order follows the TI f28002x DCSM examples. DCSM.ld places
 *   each section at its OTP address. Commented-out directives emit
 *   no data, so those locations retain their existing OTP contents.
 *
 *   The sections below contain configuration words, not instructions.
 ***************************************************************/

#----------------------------------------------------------------------
# Bank0 Zone1 OTP LINKPOINTER
# All three copies select shared ex03/ex04 ZSB3.
#----------------------------------------------------------------------
.section "b0_dcsm_otp_z1_linkpointer", "a", @progbits
    .word 0x1FFFFFFC    # B0_Z1OTP_LINKPOINTER1
    .word 0xFFFFFFFF    # Reserved
    .word 0x1FFFFFFC    # B0_Z1OTP_LINKPOINTER2
    .word 0xFFFFFFFF    # Reserved
    .word 0x1FFFFFFC    # B0_Z1OTP_LINKPOINTER3
    .word 0xFFFFFFFF    # Reserved

#----------------------------------------------------------------------
# Bank0 Zone1 OTP GPREG
# Optional boot pin and general-purpose settings; omitted from this image.
#----------------------------------------------------------------------
.section "b0_dcsm_otp_z1_gpreg", "a", @progbits
#   .word 0x5AFF1820    # Z1OTP_BOOTPIN_CONFIG / Z1OTP_GPREG1
#   .word 0x5AFFFFFF    # Z1OTP_GPREG2

#----------------------------------------------------------------------
# Bank0 Zone1 OTP PSWDLOCK
# Optional password read protection; omitted from this image.
#----------------------------------------------------------------------
.section "b0_dcsm_otp_z1_pswdlock", "a", @progbits
#   .word 0xFB7FFFFF    # Z1OTP_PSWDLOCK
#   .word 0x7FFFFFFF    # Reserved

#----------------------------------------------------------------------
# Bank0 Zone1 OTP CRCLOCK
# Optional secure-memory CRC access control; omitted from this image.
#----------------------------------------------------------------------
.section "b0_dcsm_otp_z1_crclock", "a", @progbits
#   .word 0x4BFFFFFF    # Z1OTP_CRCLOCK
#   .word 0x3FFFFFFF    # Reserved

#----------------------------------------------------------------------
# Bank0 Zone1 OTP JTAGLOCK
#----------------------------------------------------------------------
.section "b0_dcsm_otp_z1_jtaglock", "ax", @progbits
// Optional JTAG lock settings; the words below are omitted from this image.
#   .word 0xDBFFFFFF    # Z1OTP_JTAGLOCK
#   .word 0x07FFFFFF    # Reserved

#----------------------------------------------------------------------
# Bank0 Zone1 OTP BOOTCTRL
# Optional boot definitions; omitted from this image.
#----------------------------------------------------------------------
.section "b0_dcsm_otp_z1_bootctrl", "a", @progbits
#   .word 0x00000000    # Z1OTP_GPREG3 / BOOTDEF_LOW
#   .word 0xFFFFFFFF    # Z1OTP_BOOTCTRL / BOOTDEF_HIGH

#----------------------------------------------------------------------
# Bank0 Zone1 ZSB3; verify factory password bits before programming.
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
.section "b0_dcsm_zsel_z1", "a", @progbits
    .word 0xFFFFFFFF    # Z1OTP_EXEONLYRAM: execute-only disabled
    .word 0xFFFFFFEF    # B0_Z1OTP_EXEONLYSECT: sector4 execute-only; sector5 normal
    .word 0xFFFFA9FF    # Z1OTP_GRABRAM: LS4 = 01; LS5-LS7 = 10
    .word 0xAAAAA5AA    # B0_Z1OTP_GRABSECT: sector4/5 = 01; other sectors = 10

    .word 0x11111111    # Z1OTP_CSMPSWD0
    .word 0x02222222    # Demo only: verify ZSB3 factory zero bits on target
    .word 0x33333333    # Z1OTP_CSMPSWD2
    .word 0x44444444    # Z1OTP_CSMPSWD3

#----------------------------------------------------------------------
# Bank1 Zone1 OTP LINKPOINTER
# Inactive Bank1 reference; confirm device support and linker placement before use.
#----------------------------------------------------------------------
.section "b1_dcsm_otp_z1_linkpointer", "a", @progbits
#   .word 0x1FFFFFFE    # B1_Z1OTP_LINKPOINTER1
#   .word 0xFFFFFFFF    # Reserved
#   .word 0x1FFFFFFE    # B1_Z1OTP_LINKPOINTER2
#   .word 0xFFFFFFFF    # Reserved
#   .word 0x1FFFFFFE    # B1_Z1OTP_LINKPOINTER3
#   .word 0xFFFFFFFF    # Reserved

#----------------------------------------------------------------------
# Bank1 Zone1 Zone Select Block
# Inactive Bank1 reference; confirm device support and linker placement before use.
#----------------------------------------------------------------------
.section "b1_dcsm_zsel_z1", "a", @progbits
#   .word 0xFFFFFFFF    # Reserved
#   .word 0xFFFFFFFF    # B1_Z1OTP_EXEONLYSECT
#   .word 0xFFFFFFFF    # Reserved
#   .word 0xFFFFFFFF    # B1_Z1OTP_GRABSECT
#
#   .word 0xFFFFFFFF    # Reserved
#   .word 0xFFFFFFFF    # Reserved
#   .word 0xFFFFFFFF    # Reserved
#   .word 0xFFFFFFFF    # Reserved

#----------------------------------------------------------------------
# Optional reserved OTP fill for the final production image
#----------------------------------------------------------------------
# .section "dcsm_rsvd_z1", "a", @progbits
# .rept 0x1E0
#   .word 0x00000000
# .endr

/***************************************************************
 * End of file
 ***************************************************************/
