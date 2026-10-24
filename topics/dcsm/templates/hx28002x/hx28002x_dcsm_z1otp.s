/*
 * Copyright (c) 2019-2026, Beijing Haawking Technology Co., Ltd
 * hx28002x Zone1 OTP reference derived from the supplied device reference.
 * All data directives are disabled; existing target OTP stays unchanged.
 * No memory security, execute-only, lock, password, key or boot setting is emitted.
 * This cannot restore OTP or undo programmed bits. ZSB1 is an address reference.
 * TARGET_VALUE requires target-specific provisioning data; factory passwords
 * are not inferred from blank configuration words. See ../README.md.
 */

# 0x007A0000: ZSB1 reference only; preserve target link pointer.
.section "b0_dcsm_z1_linkpointer1", "a", @progbits
#   .word <TARGET_VALUE>    # 0x007A0000: LINKPOINTER1

# 0x007A0008: ZSB1 reference only; preserve target link pointer.
.section "b0_dcsm_z1_linkpointer2", "a", @progbits
#   .word <TARGET_VALUE>    # 0x007A0008: LINKPOINTER2

# 0x007A0010: ZSB1 reference only; preserve target link pointer.
.section "b0_dcsm_z1_linkpointer3", "a", @progbits
#   .word <TARGET_VALUE>    # 0x007A0010: LINKPOINTER3

# 0x007A0018: Target-specific value; preserve existing OTP.
.section "b0_dcsm_z1_gpreg", "a", @progbits
#   .word <TARGET_VALUE>    # 0x007A0018: GPREG1 / BOOTPIN_CONFIG
#   .word <TARGET_VALUE>    # 0x007A001C: GPREG2

# 0x007A0020: Target-specific value; preserve existing OTP.
.section "b0_dcsm_z1_pswdlock", "a", @progbits
#   .word <TARGET_VALUE>    # 0x007A0020: PSWDLOCK

# 0x007A0028: Target-specific value; preserve existing OTP.
.section "b0_dcsm_z1_crclock", "a", @progbits
#   .word <TARGET_VALUE>    # 0x007A0028: CRCLOCK

# 0x007A0030: Target-specific value; preserve existing OTP.
.section "b0_dcsm_z1_jtaglock", "a", @progbits
#   .word <TARGET_VALUE>    # 0x007A0030: JTAGLOCK

# 0x007A0038: Target-specific value; preserve existing OTP.
.section "b0_dcsm_z1_bootctrl", "a", @progbits
#   .word <TARGET_VALUE>    # 0x007A0038: GPREG3 / BOOTDEF_LOW
#   .word <TARGET_VALUE>    # 0x007A003C: BOOTCTRL / BOOTDEF_HIGH

# 0x007A0040: Blank reference 0xFFFFFFFF per word; no execute-only requested.
.section "b0_dcsm_z1_exeonly", "a", @progbits
#   .word 0xFFFFFFFF    # 0x007A0040: EXEONLYRAM
#   .word 0xFFFFFFFF    # 0x007A0044: EXEONLYSECT

# 0x007A0048: Blank reference 0xFFFFFFFF per word. BOTH zones 10/10 nonsecure reference: RAM=0xFFFFAAFF, SECT=0xAAAAAAAA. Nothing emitted.
.section "b0_dcsm_z1_grab", "a", @progbits
#   .word 0xFFFFFFFF    # 0x007A0048: GRABRAM
#   .word 0xFFFFFFFF    # 0x007A004C: GRABSECT

# 0x007A0050: Target-specific value; preserve existing OTP.
.section "b0_dcsm_z1_password", "a", @progbits
#   .word <TARGET_VALUE>    # 0x007A0050: CSMPSWD0
#   .word <TARGET_VALUE>    # 0x007A0054: CSMPSWD1
#   .word <TARGET_VALUE>    # 0x007A0058: CSMPSWD2
#   .word <TARGET_VALUE>    # 0x007A005C: CSMPSWD3

# Reserved words and unused ZSB slots have no data directives.
