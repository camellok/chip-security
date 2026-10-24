/*
 * Copyright (c) 2019-2026, Beijing Haawking Technology Co., Ltd
 * hx28002x Zone2 OTP reference derived from the supplied device reference.
 * All data directives are disabled; existing target OTP stays unchanged.
 * No memory security, execute-only, lock, password, key or boot setting is emitted.
 * This cannot restore OTP or undo programmed bits. ZSB1 is an address reference.
 * TARGET_VALUE requires target-specific provisioning data; factory passwords
 * are not inferred from blank configuration words. See ../README.md.
 */

# 0x007A0400: ZSB1 reference only; preserve target link pointer.
.section "b0_dcsm_z2_linkpointer1", "a", @progbits
#   .word <TARGET_VALUE>    # 0x007A0400: LINKPOINTER1

# 0x007A0408: ZSB1 reference only; preserve target link pointer.
.section "b0_dcsm_z2_linkpointer2", "a", @progbits
#   .word <TARGET_VALUE>    # 0x007A0408: LINKPOINTER2

# 0x007A0410: ZSB1 reference only; preserve target link pointer.
.section "b0_dcsm_z2_linkpointer3", "a", @progbits
#   .word <TARGET_VALUE>    # 0x007A0410: LINKPOINTER3

# 0x007A0418: Target-specific value; preserve existing OTP.
.section "b0_dcsm_z2_gpreg", "a", @progbits
#   .word <TARGET_VALUE>    # 0x007A0418: GPREG1 / BOOTPIN_CONFIG
#   .word <TARGET_VALUE>    # 0x007A041C: GPREG2

# 0x007A0420: Target-specific value; preserve existing OTP.
.section "b0_dcsm_z2_pswdlock", "a", @progbits
#   .word <TARGET_VALUE>    # 0x007A0420: PSWDLOCK

# 0x007A0428: Target-specific value; preserve existing OTP.
.section "b0_dcsm_z2_crclock", "a", @progbits
#   .word <TARGET_VALUE>    # 0x007A0428: CRCLOCK

# 0x007A0438: Target-specific value; preserve existing OTP.
.section "b0_dcsm_z2_bootctrl", "a", @progbits
#   .word <TARGET_VALUE>    # 0x007A0438: GPREG3 / BOOTDEF_LOW
#   .word <TARGET_VALUE>    # 0x007A043C: BOOTCTRL / BOOTDEF_HIGH

# 0x007A0440: Blank reference 0xFFFFFFFF per word; no execute-only requested.
.section "b0_dcsm_z2_exeonly", "a", @progbits
#   .word 0xFFFFFFFF    # 0x007A0440: EXEONLYRAM
#   .word 0xFFFFFFFF    # 0x007A0444: EXEONLYSECT

# 0x007A0448: Blank reference 0xFFFFFFFF per word. BOTH zones 10/10 nonsecure reference: RAM=0xFFFFAAFF, SECT=0xAAAAAAAA. Nothing emitted.
.section "b0_dcsm_z2_grab", "a", @progbits
#   .word 0xFFFFFFFF    # 0x007A0448: GRABRAM
#   .word 0xFFFFFFFF    # 0x007A044C: GRABSECT

# 0x007A0450: Target-specific value; preserve existing OTP.
.section "b0_dcsm_z2_password", "a", @progbits
#   .word <TARGET_VALUE>    # 0x007A0450: CSMPSWD0
#   .word <TARGET_VALUE>    # 0x007A0454: CSMPSWD1
#   .word <TARGET_VALUE>    # 0x007A0458: CSMPSWD2
#   .word <TARGET_VALUE>    # 0x007A045C: CSMPSWD3

# Reserved words and unused ZSB slots have no data directives.
