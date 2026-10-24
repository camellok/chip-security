/*
 * Copyright (c) 2019-2026, Beijing Haawking Technology Co., Ltd
 * hx280013x Zone2 OTP reference derived from the supplied device reference.
 * All data directives are disabled; existing target OTP stays unchanged.
 * No memory security, execute-only, lock, password, key or boot setting is emitted.
 * This cannot restore OTP or undo programmed bits. ZSB1 is an address reference.
 * TARGET_VALUE requires target-specific provisioning data; factory passwords
 * are not inferred from blank configuration words. See ../README.md.
 */

# 0x00640400: ZSB1 reference only; preserve target link pointer.
.section "b0_dcsm_z2_linkpointer1", "a", @progbits
#   .word <TARGET_VALUE>    # 0x00640400: LINKPOINTER1

# 0x00640404: ZSB1 reference only; preserve target link pointer.
.section "b0_dcsm_z2_linkpointer2", "a", @progbits
#   .word <TARGET_VALUE>    # 0x00640404: LINKPOINTER2

# 0x00640408: ZSB1 reference only; preserve target link pointer.
.section "b0_dcsm_z2_linkpointer3", "a", @progbits
#   .word <TARGET_VALUE>    # 0x00640408: LINKPOINTER3

# 0x00640410: Target-specific value; preserve existing OTP.
.section "b0_dcsm_z2_gpreg", "a", @progbits
#   .word <TARGET_VALUE>    # 0x00640410: GPREG1
#   .word <TARGET_VALUE>    # 0x00640414: GPREG2
#   .word <TARGET_VALUE>    # 0x00640418: GPREG3
#   .word <TARGET_VALUE>    # 0x0064041C: GPREG4

# 0x00640420: Target-specific value; preserve existing OTP.
.section "b0_dcsm_z2_pswdlock", "a", @progbits
#   .word <TARGET_VALUE>    # 0x00640420: PSWDLOCK

# 0x00640424: Target-specific value; preserve existing OTP.
.section "b0_dcsm_z2_crclock", "a", @progbits
#   .word <TARGET_VALUE>    # 0x00640424: CRCLOCK

# 0x00640440: Target-specific value; preserve existing OTP.
.section "b0_dcsm_z2_password", "a", @progbits
#   .word <TARGET_VALUE>    # 0x00640440: CSMPSWD0
#   .word <TARGET_VALUE>    # 0x00640444: CSMPSWD1
#   .word <TARGET_VALUE>    # 0x00640448: CSMPSWD2
#   .word <TARGET_VALUE>    # 0x0064044C: CSMPSWD3

# 0x00640450: Blank reference 0xFFFFFFFF per word. BOTH zones 10/10 nonsecure reference: SECT1/2=0xAAAAAAAA, SECT3=0xAAAAAAFF, RAM1=0xFFFFFFAA. GRABSECT3 +0x18 is the accepted experimental layout; confirm before use.
.section "b0_dcsm_z2_grab", "a", @progbits
#   .word 0xFFFFFFFF    # 0x00640450: GRABSECT1
#   .word 0xFFFFFFFF    # 0x00640454: GRABSECT2
#   .word 0xFFFFFFFF    # 0x00640458: GRABSECT3
#   .word 0xFFFFFFFF    # 0x0064045C: GRABRAM1

# 0x00640468: Blank reference 0xFFFFFFFF; no execute-only requested.
.section "b0_dcsm_z2_exeonlysect1", "a", @progbits
#   .word 0xFFFFFFFF    # 0x00640468: EXEONLYSECT1

# 0x0064046C: INFERRED offset +0x2C; inactive reference, confirm before use. Blank reference 0xFFFFFFFF.
.section "b0_dcsm_z2_exeonlysect2", "a", @progbits
#   .word 0xFFFFFFFF    # 0x0064046C: EXEONLYSECT2

# 0x00640470: Blank reference 0xFFFFFFFF; no execute-only requested.
.section "b0_dcsm_z2_exeonlyram1", "a", @progbits
#   .word 0xFFFFFFFF    # 0x00640470: EXEONLYRAM1

# Reserved words and unused ZSB slots have no data directives.
