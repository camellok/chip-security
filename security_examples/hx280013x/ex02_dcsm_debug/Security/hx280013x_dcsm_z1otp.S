/***************************************************************
 * Copyright (c) 2019-2026, Beijing Haawking Technology Co., Ltd
 *
 * File        : hx280013x_dcsm_z1otp.S
 * Description :
 *   Complete Zone 1 user OTP template for the Haawking RISC-V assembler.
 *   DCSM.ld places each section at its OTP byte address.
 *   Commented-out directives emit no data and preserve existing contents.
 *   The sections below contain configuration words, not instructions.
 ***************************************************************/

#----------------------------------------------------------------------
# Template use
# All fixed-header and ZSB fields are listed, including reserved words.
# Only the ex01/ex02 demonstration fields are enabled by default.
# Enable complete password/key groups; never remove a word inside a group.
# Each optional group has a fixed linker address; gaps are not filled.
# Keep reserved words commented. Verify all factory bits before OTP use.
#----------------------------------------------------------------------

#----------------------------------------------------------------------
# 280013x fields / differences from the 28002x template
# Header byte offsets: LINKPOINTER1/2/3 +0x00/+0x04/+0x08;
# GPREG1/2/3/4 +0x10/+0x14/+0x18/+0x1C; PSWDLOCK +0x20; CRCLOCK +0x24.
# GPREG words use the 280013x definitions; do not copy 28002x BOOTDEF aliases.
# Zone1-only header: JLM_ENABLE +0x0C; JTAGPSWDH0/1 +0x28/+0x2C;
# CMACKEY0/1/2/3 +0x30/+0x34/+0x38/+0x3C.
# JTAGPSWDH0/1 hold password bits [95:64]/[127:96] permanently.
# ZSB JTAGPSWDL0/1 hold the lower 64 bits in the selected slot.
# JLM_ENABLE[3:0] = 0xF disables JTAGLOCK; another value enables it.
# Both ZSBs: GRABSECT1/2/3 +0x10/+0x14/+0x18;
# EXEONLYSECT1/2 +0x28/+0x2C; GRABRAM1 +0x1C; EXEONLYRAM1 +0x30.
# GRABSECT3 +0x18 is the accepted experiment layout; EXEONLYSECT2 +0x2C
# remains inferred and commented out. Reserved words are never required fill.
# Reference: Haawking TRM V1.3 sections 5.2.6/5.2.7/5.8.5/5.8.6,
# and the supplied 280013x DriverLib inc/hw_dcsm.h (header offsets).
#----------------------------------------------------------------------

#----------------------------------------------------------------------
# Bank0 Zone1 OTP LINKPOINTER
# Byte address: 0x00640000. Optional; omitted from this image.
#----------------------------------------------------------------------
.section "b0_dcsm_otp_z1_linkpointer", "a", @progbits
#   .word 0xFFFFFFFF    # Z1OTP_LINKPOINTER1: low14 = 0x3FFF selects ZSB1
#   .word 0xFFFFFFFF    # Z1OTP_LINKPOINTER2: low14 = 0x3FFF selects ZSB1
#   .word 0xFFFFFFFF    # Z1OTP_LINKPOINTER3: low14 = 0x3FFF selects ZSB1

#----------------------------------------------------------------------
# Bank0 Zone1 OTP JLM_ENABLE
# Byte address: 0x0064000C. Optional; omitted from this image.
#----------------------------------------------------------------------
.section "b0_dcsm_otp_z1_jlm_enable", "a", @progbits
#   .word 0xFFFF000F    # Z1OTP_JLM_ENABLE: factory value; JTAGLOCK remains disabled

#----------------------------------------------------------------------
# Bank0 Zone1 OTP GPREGx
# Byte address: 0x00640010. Optional; omitted from this image.
#----------------------------------------------------------------------
.section "b0_dcsm_otp_z1_gpreg", "a", @progbits
#   .word 0xFFFFFFFF    # Z1OTP_GPREG1: 280013x general-purpose configuration
#   .word 0xFFFFFFFF    # Z1OTP_GPREG2: 280013x general-purpose configuration
#   .word 0xFFFFFFFF    # Z1OTP_GPREG3: 280013x general-purpose configuration
#   .word 0xFFFFFFFF    # Z1OTP_GPREG4: 280013x general-purpose configuration

#----------------------------------------------------------------------
# Bank0 Zone1 OTP PSWDLOCK
# Byte address: 0x00640020. Optional; omitted from this image.
#----------------------------------------------------------------------
.section "b0_dcsm_otp_z1_pswdlock", "a", @progbits
#   .word 0xFB7FFFFF    # Z1OTP_PSWDLOCK: factory value; low nibble F keeps password readable

#----------------------------------------------------------------------
# Bank0 Zone1 OTP CRCLOCK
# Byte address: 0x00640024. Optional; omitted from this image.
#----------------------------------------------------------------------
.section "b0_dcsm_otp_z1_crclock", "a", @progbits
#   .word 0x7FFFFFFF    # Z1OTP_CRCLOCK: factory value

#----------------------------------------------------------------------
# Bank0 Zone1 OTP JTAGPSWDH
# Byte address: 0x00640028. Optional; omitted from this image.
#----------------------------------------------------------------------
.section "b0_dcsm_otp_z1_jtagpswdh", "a", @progbits
#   .word 0x4BFFFFFF    # Z1OTP_JTAGPSWDH0: password bits [95:64]; factory value
#   .word 0x3FFFFFFF    # Z1OTP_JTAGPSWDH1: password bits [127:96]; factory value

#----------------------------------------------------------------------
# Bank0 Zone1 OTP CMACKEY
# Byte address: 0x00640030. Optional; omitted from this image.
#----------------------------------------------------------------------
.section "b0_dcsm_otp_z1_cmackey", "a", @progbits
#   .word 0xFFFFFFFF    # Z1OTP_CMACKEY0: key bits [31:0]; replace complete key
#   .word 0xFFFFFFFF    # Z1OTP_CMACKEY1: key bits [63:32]; replace complete key
#   .word 0xFFFFFFFF    # Z1OTP_CMACKEY2: key bits [95:64]; replace complete key
#   .word 0xFFFFFFFF    # Z1OTP_CMACKEY3: key bits [127:96]; replace complete key

#----------------------------------------------------------------------
# Bank0 Zone1 ZSB1 layout
# Base: 0x00640040; block size: 0x40 bytes.
# +0x00..+0x0C CSMPSWD0..3; +0x10/+0x14 GRABSECT1/2;
# +0x18 GRABSECT3; +0x1C GRABRAM1; +0x20/+0x24 reserved;
# +0x28/+0x2C EXEONLYSECT1/2; +0x30 EXEONLYRAM1;
# +0x34 reserved; +0x38/+0x3C JTAGPSWDL0/1.
# GRABSECT3 +0x18: inferred layout accepted for this experiment, 2026-10-24.
# EXEONLYSECT2 +0x2C: layout inference, disabled until confirmed.
#----------------------------------------------------------------------

#----------------------------------------------------------------------
# Bank0 Zone1 ZSB1 PASSWORD
# Byte offset +0x00. Enabled for this example.
#----------------------------------------------------------------------
.section "b0_dcsm_zsel_z1_password", "a", @progbits
    .word 0x11111111    # Z1OTP_CSMPSWD0
    .word 0x00222222    # Z1OTP_CSMPSWD1: keep factory-programmed zero bits
    .word 0x33333333    # Z1OTP_CSMPSWD2
    .word 0x44444444    # Z1OTP_CSMPSWD3

#----------------------------------------------------------------------
# Bank0 Zone1 ZSB1 GRAB
# Byte offset +0x10. Enabled for this example.
#----------------------------------------------------------------------
.section "b0_dcsm_zsel_z1_grab", "a", @progbits
    .word 0xAAAAAAAA    # Z1OTP_GRABSECT1: sector0-15 = 10
    .word 0xAAAAAAAA    # Z1OTP_GRABSECT2: sector16-31 = 10
    .word 0xAAAAA5FF    # Z1OTP_GRABSECT3: sector32-47 = 01; others = 10
    .word 0xFFFFFFAA    # Z1OTP_GRABRAM1: LS0 A-D = 10; reserved bits remain 1

#----------------------------------------------------------------------
# Bank0 Zone1 ZSB1 RESERVED0
# Byte offset +0x20. Optional; omitted from this image.
#----------------------------------------------------------------------
.section "b0_dcsm_zsel_z1_reserved0", "a", @progbits
#   .word 0xFFFFFFFF    # Reserved +0x20: no GRABRAM2 on this device
#   .word 0xFFFFFFFF    # Reserved +0x24: no GRABRAM3 on this device

#----------------------------------------------------------------------
# Bank0 Zone1 ZSB1 EXEONLYSECTx
# Byte offset +0x28. Optional; omitted from this image.
#----------------------------------------------------------------------
.section "b0_dcsm_zsel_z1_exeonlysect", "a", @progbits
#   .word 0xFFFFFFFF    # Z1OTP_EXEONLYSECT1: execute-only disabled
#   .word 0xFFFFFFFF    # Z1OTP_EXEONLYSECT2: inferred +0x2C; confirm before use


#----------------------------------------------------------------------
# Bank0 Zone1 ZSB1 EXEONLYRAM1
# Byte offset +0x30. Optional; omitted from this image.
#----------------------------------------------------------------------
.section "b0_dcsm_zsel_z1_exeonlyram1", "a", @progbits
#   .word 0xFFFFFFFF    # Z1OTP_EXEONLYRAM1: execute-only disabled

#----------------------------------------------------------------------
# Bank0 Zone1 ZSB1 RESERVED1
# Byte offset +0x34. Optional; omitted from this image.
#----------------------------------------------------------------------
.section "b0_dcsm_zsel_z1_reserved1", "a", @progbits
#   .word 0xFFFFFFFF    # Reserved +0x34: leave unchanged

#----------------------------------------------------------------------
# Bank0 Zone1 ZSB1 JTAGPSWDL
# Byte offset +0x38. Optional; omitted from this image.
#----------------------------------------------------------------------
.section "b0_dcsm_zsel_z1_jtagpswdl", "a", @progbits
#   .word 0xFFFFFFFF    # Z1OTP_JTAGPSWDL0: factory value
#   .word 0x2BFFFFFF    # Z1OTP_JTAGPSWDL1: ZSB1 factory value

#----------------------------------------------------------------------
# Unused ZSB slots
# DCSM.ld selects one 0x40-byte block per Zone. No unused-slot fill is emitted.
# For another slot, update the block origin, LINKPOINTER and factory password bits.
# Do not copy ZSB1 password masks to another slot unchanged.
#----------------------------------------------------------------------

/***************************************************************
 * End of file
 ***************************************************************/
