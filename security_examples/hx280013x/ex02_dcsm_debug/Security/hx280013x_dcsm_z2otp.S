/***************************************************************
 * Copyright (c) 2019-2026, Beijing Haawking Technology Co., Ltd
 *
 * File        : hx280013x_dcsm_z2otp.S
 * Description :
 *   Complete Zone 2 user OTP template for the Haawking RISC-V assembler.
 *   DCSM.ld places each section at its OTP byte address.
 *   Commented-out directives emit no data and preserve existing contents.
 *   The sections below contain configuration words, not instructions.
 ***************************************************************/

#----------------------------------------------------------------------
# Template use
# All fixed-header and ZSB fields are listed; reserved offsets are comments only.
# Only the ex01/ex02 demonstration fields are enabled by default.
# Enable complete password/key groups; never remove a word inside a group.
# Each optional group has a fixed linker address; gaps are not filled.
# Never emit reserved words. Verify all factory bits before OTP use.
#----------------------------------------------------------------------

#----------------------------------------------------------------------
# 280013x fields / differences from the 28002x template
# Header byte offsets: LINKPOINTER1/2/3 +0x00/+0x04/+0x08;
# GPREG1/2/3/4 +0x10/+0x14/+0x18/+0x1C; PSWDLOCK +0x20; CRCLOCK +0x24.
# GPREG words use the 280013x definitions; do not copy 28002x BOOTDEF aliases.
# Zone2 header +0x0C and +0x28..+0x3C are reserved.
# No Zone2 JLM_ENABLE, JTAG password or CMAC key fields are defined here.
# Both ZSBs: GRABSECT1/2/3 +0x10/+0x14/+0x18;
# EXEONLYSECT1/2 +0x28/+0x2C; GRABRAM1 +0x1C; EXEONLYRAM1 +0x30.
# GRABSECT3 +0x18 is the accepted experiment layout; EXEONLYSECT2 +0x2C
# remains inferred and commented out. Reserved words are never required fill.
# Reference: Haawking TRM V1.3 sections 5.2.6/5.2.7/5.8.5/5.8.6,
# and the supplied 280013x DriverLib inc/hw_dcsm.h (header offsets).
#----------------------------------------------------------------------

#----------------------------------------------------------------------
# Bank0 Zone2 OTP LINKPOINTER
# Byte address: 0x00640400. Optional; omitted from this image.
#----------------------------------------------------------------------
.section "b0_dcsm_otp_z2_linkpointer", "a", @progbits
#   .word 0xFFFFFFFF    # Z2OTP_LINKPOINTER1: low14 = 0x3FFF selects ZSB1
#   .word 0xFFFFFFFF    # Z2OTP_LINKPOINTER2: low14 = 0x3FFF selects ZSB1
#   .word 0xFFFFFFFF    # Z2OTP_LINKPOINTER3: low14 = 0x3FFF selects ZSB1

#----------------------------------------------------------------------
# Bank0 Zone2 OTP RESERVED0
# Byte address: 0x0064040C. Reserved; no data is emitted.
#----------------------------------------------------------------------
# Reserved locations are documented here only; never emit data for them.

#----------------------------------------------------------------------
# Bank0 Zone2 OTP GPREGx
# Byte address: 0x00640410. Optional; omitted from this image.
#----------------------------------------------------------------------
.section "b0_dcsm_otp_z2_gpreg", "a", @progbits
#   .word 0xFFFFFFFF    # Z2OTP_GPREG1: 280013x general-purpose configuration
#   .word 0xFFFFFFFF    # Z2OTP_GPREG2: 280013x general-purpose configuration
#   .word 0xFFFFFFFF    # Z2OTP_GPREG3: 280013x general-purpose configuration
#   .word 0xFFFFFFFF    # Z2OTP_GPREG4: 280013x general-purpose configuration

#----------------------------------------------------------------------
# Bank0 Zone2 OTP PSWDLOCK
# Byte address: 0x00640420. Optional; omitted from this image.
#----------------------------------------------------------------------
.section "b0_dcsm_otp_z2_pswdlock", "a", @progbits
#   .word 0x1F7FFFFF    # Z2OTP_PSWDLOCK: factory value; low nibble F keeps password readable

#----------------------------------------------------------------------
# Bank0 Zone2 OTP CRCLOCK
# Byte address: 0x00640424. Optional; omitted from this image.
#----------------------------------------------------------------------
.section "b0_dcsm_otp_z2_crclock", "a", @progbits
#   .word 0x3FFFFFFF    # Z2OTP_CRCLOCK: factory value

#----------------------------------------------------------------------
# Bank0 Zone2 OTP RESERVED1
# Byte addresses: 0x00640428..0x0064043F. Reserved; no data is emitted.
#----------------------------------------------------------------------
# Reserved locations are documented here only; never emit data for them.

#----------------------------------------------------------------------
# Bank0 Zone2 ZSB1 layout
# Base: 0x00640440; block size: 0x40 bytes.
# +0x00..+0x0C CSMPSWD0..3; +0x10/+0x14 GRABSECT1/2;
# +0x18 GRABSECT3; +0x1C GRABRAM1; +0x20/+0x24 reserved;
# +0x28/+0x2C EXEONLYSECT1/2; +0x30 EXEONLYRAM1;
# +0x34 reserved; +0x38/+0x3C reserved.
# GRABSECT3 +0x18: inferred layout accepted for this experiment, 2026-10-24.
# EXEONLYSECT2 +0x2C: layout inference, disabled until confirmed.
#----------------------------------------------------------------------

#----------------------------------------------------------------------
# Bank0 Zone2 ZSB1 PASSWORD
# Byte offset +0x00. Optional; omitted from this image.
#----------------------------------------------------------------------
.section "b0_dcsm_zsel_z2_password", "a", @progbits
#   .word 0xFFFFFFFF    # Z2OTP_CSMPSWD0
#   .word 0x1F7FFFFF    # Z2OTP_CSMPSWD1: keep factory-programmed zero bits
#   .word 0xFFFFFFFF    # Z2OTP_CSMPSWD2
#   .word 0xFFFFFFFF    # Z2OTP_CSMPSWD3

#----------------------------------------------------------------------
# Bank0 Zone2 ZSB1 GRAB
# Byte offset +0x10. Enabled for this example.
#----------------------------------------------------------------------
.section "b0_dcsm_zsel_z2_grab", "a", @progbits
    .word 0xAAAAAAAA    # Z2OTP_GRABSECT1: sector0-15 = 10
    .word 0xAAAAAAAA    # Z2OTP_GRABSECT2: sector16-31 = 10
    .word 0xAAAAAAFF    # Z2OTP_GRABSECT3: no Zone2 claims; reserved bits remain 1
    .word 0xFFFFFFAA    # Z2OTP_GRABRAM1: LS0 A-D = 10; reserved bits remain 1

#----------------------------------------------------------------------
# Bank0 Zone2 ZSB1 RESERVED0
# Byte offsets +0x20/+0x24 (no GRABRAM2/3). Reserved; no data is emitted.
#----------------------------------------------------------------------
# Reserved locations are documented here only; never emit data for them.

#----------------------------------------------------------------------
# Bank0 Zone2 ZSB1 EXEONLYSECTx
# Byte offset +0x28. Optional; omitted from this image.
#----------------------------------------------------------------------
.section "b0_dcsm_zsel_z2_exeonlysect", "a", @progbits
#   .word 0xFFFFFFFF    # Z2OTP_EXEONLYSECT1: execute-only disabled
#   .word 0xFFFFFFFF    # Z2OTP_EXEONLYSECT2: inferred +0x2C; confirm before use

#----------------------------------------------------------------------
# Bank0 Zone2 ZSB1 EXEONLYRAM1
# Byte offset +0x30. Optional; omitted from this image.
#----------------------------------------------------------------------
.section "b0_dcsm_zsel_z2_exeonlyram1", "a", @progbits
#   .word 0xFFFFFFFF    # Z2OTP_EXEONLYRAM1: execute-only disabled

#----------------------------------------------------------------------
# Bank0 Zone2 ZSB1 RESERVED1
# Byte offset +0x34. Reserved; no data is emitted.
#----------------------------------------------------------------------
# Reserved locations are documented here only; never emit data for them.

#----------------------------------------------------------------------
# Bank0 Zone2 ZSB1 RESERVED2
# Byte offsets +0x38/+0x3C. Reserved; no data is emitted.
#----------------------------------------------------------------------
# Reserved locations are documented here only; never emit data for them.

#----------------------------------------------------------------------
# Unused ZSB slots
# DCSM.ld selects one 0x40-byte block per Zone. No unused-slot fill is emitted.
# For another slot, update the block origin, LINKPOINTER and factory password bits.
# Do not copy ZSB1 password masks to another slot unchanged.
#----------------------------------------------------------------------

/***************************************************************
 * End of file
 ***************************************************************/
