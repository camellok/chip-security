/*
 * Copyright (c) 2019-2026, Beijing Haawking Technology Co., Ltd
 * hx280013x Zone1 OTP reference derived from the supplied device reference.
 * All data directives are disabled; existing target OTP stays unchanged.
 * No memory security, execute-only, lock, password, key or boot setting is emitted.
 * This cannot restore OTP or undo programmed bits. ZSB1 is an address reference.
 * TARGET_VALUE requires target-specific provisioning data; factory passwords
 * are not inferred from blank configuration words. See ../README.md.
 */

# 0x00640000: ZSB1 reference only; preserve target link pointer.
.section "b0_dcsm_z1_linkpointer1", "a", @progbits
#   .word <TARGET_VALUE>    # 0x00640000: LINKPOINTER1

# 0x00640004: ZSB1 reference only; preserve target link pointer.
.section "b0_dcsm_z1_linkpointer2", "a", @progbits
#   .word <TARGET_VALUE>    # 0x00640004: LINKPOINTER2

# 0x00640008: ZSB1 reference only; preserve target link pointer.
.section "b0_dcsm_z1_linkpointer3", "a", @progbits
#   .word <TARGET_VALUE>    # 0x00640008: LINKPOINTER3

# 0x0064000C: Target-specific value; preserve existing OTP.
.section "b0_dcsm_z1_jlm_enable", "a", @progbits
#   .word <TARGET_VALUE>    # 0x0064000C: JLM_ENABLE

# 0x00640010: Target-specific value; preserve existing OTP.
.section "b0_dcsm_z1_gpreg", "a", @progbits
#   .word <TARGET_VALUE>    # 0x00640010: GPREG1
#   .word <TARGET_VALUE>    # 0x00640014: GPREG2
#   .word <TARGET_VALUE>    # 0x00640018: GPREG3
#   .word <TARGET_VALUE>    # 0x0064001C: GPREG4

# 0x00640020: Target-specific value; preserve existing OTP.
.section "b0_dcsm_z1_pswdlock", "a", @progbits
#   .word <TARGET_VALUE>    # 0x00640020: PSWDLOCK

# 0x00640024: Target-specific value; preserve existing OTP.
.section "b0_dcsm_z1_crclock", "a", @progbits
#   .word <TARGET_VALUE>    # 0x00640024: CRCLOCK

# 0x00640028: Target-specific value; preserve existing OTP.
.section "b0_dcsm_z1_jtagpswdh", "a", @progbits
#   .word <TARGET_VALUE>    # 0x00640028: JTAGPSWDH0
#   .word <TARGET_VALUE>    # 0x0064002C: JTAGPSWDH1

# 0x00640030: Target-specific value; preserve existing OTP.
.section "b0_dcsm_z1_cmackey", "a", @progbits
#   .word <TARGET_VALUE>    # 0x00640030: CMACKEY0
#   .word <TARGET_VALUE>    # 0x00640034: CMACKEY1
#   .word <TARGET_VALUE>    # 0x00640038: CMACKEY2
#   .word <TARGET_VALUE>    # 0x0064003C: CMACKEY3

# 0x00640040: Target-specific value; preserve existing OTP.
.section "b0_dcsm_z1_password", "a", @progbits
#   .word <TARGET_VALUE>    # 0x00640040: CSMPSWD0
#   .word <TARGET_VALUE>    # 0x00640044: CSMPSWD1
#   .word <TARGET_VALUE>    # 0x00640048: CSMPSWD2
#   .word <TARGET_VALUE>    # 0x0064004C: CSMPSWD3

# 0x00640050: Blank reference 0xFFFFFFFF per word. BOTH zones 10/10 nonsecure reference: SECT1/2=0xAAAAAAAA, SECT3=0xAAAAAAFF, RAM1=0xFFFFFFAA. GRABSECT3 +0x18 is the accepted experimental layout; confirm before use.
.section "b0_dcsm_z1_grab", "a", @progbits
#   .word 0xFFFFFFFF    # 0x00640050: GRABSECT1
#   .word 0xFFFFFFFF    # 0x00640054: GRABSECT2
#   .word 0xFFFFFFFF    # 0x00640058: GRABSECT3
#   .word 0xFFFFFFFF    # 0x0064005C: GRABRAM1

# 0x00640068: Blank reference 0xFFFFFFFF; no execute-only requested.
.section "b0_dcsm_z1_exeonlysect1", "a", @progbits
#   .word 0xFFFFFFFF    # 0x00640068: EXEONLYSECT1

# 0x0064006C: INFERRED offset +0x2C; inactive reference, confirm before use. Blank reference 0xFFFFFFFF.
.section "b0_dcsm_z1_exeonlysect2", "a", @progbits
#   .word 0xFFFFFFFF    # 0x0064006C: EXEONLYSECT2

# 0x00640070: Blank reference 0xFFFFFFFF; no execute-only requested.
.section "b0_dcsm_z1_exeonlyram1", "a", @progbits
#   .word 0xFFFFFFFF    # 0x00640070: EXEONLYRAM1

# 0x00640078: Target-specific value; preserve existing OTP.
.section "b0_dcsm_z1_jtagpswdl", "a", @progbits
#   .word <TARGET_VALUE>    # 0x00640078: JTAGPSWDL0
#   .word <TARGET_VALUE>    # 0x0064007C: JTAGPSWDL1

# Reserved words and unused ZSB slots have no data directives.
