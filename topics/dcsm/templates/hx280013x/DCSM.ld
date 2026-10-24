/* Copyright (c) 2019-2026, Beijing Haawking Technology Co., Ltd
 * OTP-only reference. All accompanying groups are empty by default.
 * No padding/fill. Not an APP script or factory restore image.
 * Enable complete groups only after confirming target-specific OTP.
 */
MEMORY
{
    B0_DCSM_Z1_LINKPOINTER1 (r) : ORIGIN = 0x00640000, LENGTH = 0x04
    B0_DCSM_Z1_LINKPOINTER2 (r) : ORIGIN = 0x00640004, LENGTH = 0x04
    B0_DCSM_Z1_LINKPOINTER3 (r) : ORIGIN = 0x00640008, LENGTH = 0x04
    B0_DCSM_Z1_JLM_ENABLE (r) : ORIGIN = 0x0064000C, LENGTH = 0x04
    B0_DCSM_Z1_GPREG (r) : ORIGIN = 0x00640010, LENGTH = 0x10
    B0_DCSM_Z1_PSWDLOCK (r) : ORIGIN = 0x00640020, LENGTH = 0x04
    B0_DCSM_Z1_CRCLOCK (r) : ORIGIN = 0x00640024, LENGTH = 0x04
    B0_DCSM_Z1_JTAGPSWDH (r) : ORIGIN = 0x00640028, LENGTH = 0x08
    B0_DCSM_Z1_CMACKEY (r) : ORIGIN = 0x00640030, LENGTH = 0x10
    B0_DCSM_Z1_PASSWORD (r) : ORIGIN = 0x00640040, LENGTH = 0x10
    B0_DCSM_Z1_GRAB (r) : ORIGIN = 0x00640050, LENGTH = 0x10
    B0_DCSM_Z1_EXEONLYSECT1 (r) : ORIGIN = 0x00640068, LENGTH = 0x04
    B0_DCSM_Z1_EXEONLYSECT2 (r) : ORIGIN = 0x0064006C, LENGTH = 0x04
    B0_DCSM_Z1_EXEONLYRAM1 (r) : ORIGIN = 0x00640070, LENGTH = 0x04
    B0_DCSM_Z1_JTAGPSWDL (r) : ORIGIN = 0x00640078, LENGTH = 0x08
    B0_DCSM_Z2_LINKPOINTER1 (r) : ORIGIN = 0x00640400, LENGTH = 0x04
    B0_DCSM_Z2_LINKPOINTER2 (r) : ORIGIN = 0x00640404, LENGTH = 0x04
    B0_DCSM_Z2_LINKPOINTER3 (r) : ORIGIN = 0x00640408, LENGTH = 0x04
    B0_DCSM_Z2_GPREG (r) : ORIGIN = 0x00640410, LENGTH = 0x10
    B0_DCSM_Z2_PSWDLOCK (r) : ORIGIN = 0x00640420, LENGTH = 0x04
    B0_DCSM_Z2_CRCLOCK (r) : ORIGIN = 0x00640424, LENGTH = 0x04
    B0_DCSM_Z2_PASSWORD (r) : ORIGIN = 0x00640440, LENGTH = 0x10
    B0_DCSM_Z2_GRAB (r) : ORIGIN = 0x00640450, LENGTH = 0x10
    B0_DCSM_Z2_EXEONLYSECT1 (r) : ORIGIN = 0x00640468, LENGTH = 0x04
    B0_DCSM_Z2_EXEONLYSECT2 (r) : ORIGIN = 0x0064046C, LENGTH = 0x04
    B0_DCSM_Z2_EXEONLYRAM1 (r) : ORIGIN = 0x00640470, LENGTH = 0x04
}
SECTIONS
{
    .b0_dcsm_z1_linkpointer1 0x00640000 : { KEEP(*(b0_dcsm_z1_linkpointer1)) } > B0_DCSM_Z1_LINKPOINTER1
    ASSERT(SIZEOF(.b0_dcsm_z1_linkpointer1) == 0 || SIZEOF(.b0_dcsm_z1_linkpointer1) == 0x4, "b0_dcsm_z1_linkpointer1: enable the complete group")
    .b0_dcsm_z1_linkpointer2 0x00640004 : { KEEP(*(b0_dcsm_z1_linkpointer2)) } > B0_DCSM_Z1_LINKPOINTER2
    ASSERT(SIZEOF(.b0_dcsm_z1_linkpointer2) == 0 || SIZEOF(.b0_dcsm_z1_linkpointer2) == 0x4, "b0_dcsm_z1_linkpointer2: enable the complete group")
    .b0_dcsm_z1_linkpointer3 0x00640008 : { KEEP(*(b0_dcsm_z1_linkpointer3)) } > B0_DCSM_Z1_LINKPOINTER3
    ASSERT(SIZEOF(.b0_dcsm_z1_linkpointer3) == 0 || SIZEOF(.b0_dcsm_z1_linkpointer3) == 0x4, "b0_dcsm_z1_linkpointer3: enable the complete group")
    .b0_dcsm_z1_jlm_enable 0x0064000C : { KEEP(*(b0_dcsm_z1_jlm_enable)) } > B0_DCSM_Z1_JLM_ENABLE
    ASSERT(SIZEOF(.b0_dcsm_z1_jlm_enable) == 0 || SIZEOF(.b0_dcsm_z1_jlm_enable) == 0x4, "b0_dcsm_z1_jlm_enable: enable the complete group")
    .b0_dcsm_z1_gpreg 0x00640010 : { KEEP(*(b0_dcsm_z1_gpreg)) } > B0_DCSM_Z1_GPREG
    ASSERT(SIZEOF(.b0_dcsm_z1_gpreg) == 0 || SIZEOF(.b0_dcsm_z1_gpreg) == 0x10, "b0_dcsm_z1_gpreg: enable the complete group")
    .b0_dcsm_z1_pswdlock 0x00640020 : { KEEP(*(b0_dcsm_z1_pswdlock)) } > B0_DCSM_Z1_PSWDLOCK
    ASSERT(SIZEOF(.b0_dcsm_z1_pswdlock) == 0 || SIZEOF(.b0_dcsm_z1_pswdlock) == 0x4, "b0_dcsm_z1_pswdlock: enable the complete group")
    .b0_dcsm_z1_crclock 0x00640024 : { KEEP(*(b0_dcsm_z1_crclock)) } > B0_DCSM_Z1_CRCLOCK
    ASSERT(SIZEOF(.b0_dcsm_z1_crclock) == 0 || SIZEOF(.b0_dcsm_z1_crclock) == 0x4, "b0_dcsm_z1_crclock: enable the complete group")
    .b0_dcsm_z1_jtagpswdh 0x00640028 : { KEEP(*(b0_dcsm_z1_jtagpswdh)) } > B0_DCSM_Z1_JTAGPSWDH
    ASSERT(SIZEOF(.b0_dcsm_z1_jtagpswdh) == 0 || SIZEOF(.b0_dcsm_z1_jtagpswdh) == 0x8, "b0_dcsm_z1_jtagpswdh: enable the complete group")
    .b0_dcsm_z1_cmackey 0x00640030 : { KEEP(*(b0_dcsm_z1_cmackey)) } > B0_DCSM_Z1_CMACKEY
    ASSERT(SIZEOF(.b0_dcsm_z1_cmackey) == 0 || SIZEOF(.b0_dcsm_z1_cmackey) == 0x10, "b0_dcsm_z1_cmackey: enable the complete group")
    .b0_dcsm_z1_password 0x00640040 : { KEEP(*(b0_dcsm_z1_password)) } > B0_DCSM_Z1_PASSWORD
    ASSERT(SIZEOF(.b0_dcsm_z1_password) == 0 || SIZEOF(.b0_dcsm_z1_password) == 0x10, "b0_dcsm_z1_password: enable the complete group")
    .b0_dcsm_z1_grab 0x00640050 : { KEEP(*(b0_dcsm_z1_grab)) } > B0_DCSM_Z1_GRAB
    ASSERT(SIZEOF(.b0_dcsm_z1_grab) == 0 || SIZEOF(.b0_dcsm_z1_grab) == 0x10, "b0_dcsm_z1_grab: enable the complete group")
    .b0_dcsm_z1_exeonlysect1 0x00640068 : { KEEP(*(b0_dcsm_z1_exeonlysect1)) } > B0_DCSM_Z1_EXEONLYSECT1
    ASSERT(SIZEOF(.b0_dcsm_z1_exeonlysect1) == 0 || SIZEOF(.b0_dcsm_z1_exeonlysect1) == 0x4, "b0_dcsm_z1_exeonlysect1: enable the complete group")
    .b0_dcsm_z1_exeonlysect2 0x0064006C : { KEEP(*(b0_dcsm_z1_exeonlysect2)) } > B0_DCSM_Z1_EXEONLYSECT2
    ASSERT(SIZEOF(.b0_dcsm_z1_exeonlysect2) == 0 || SIZEOF(.b0_dcsm_z1_exeonlysect2) == 0x4, "b0_dcsm_z1_exeonlysect2: enable the complete group")
    .b0_dcsm_z1_exeonlyram1 0x00640070 : { KEEP(*(b0_dcsm_z1_exeonlyram1)) } > B0_DCSM_Z1_EXEONLYRAM1
    ASSERT(SIZEOF(.b0_dcsm_z1_exeonlyram1) == 0 || SIZEOF(.b0_dcsm_z1_exeonlyram1) == 0x4, "b0_dcsm_z1_exeonlyram1: enable the complete group")
    .b0_dcsm_z1_jtagpswdl 0x00640078 : { KEEP(*(b0_dcsm_z1_jtagpswdl)) } > B0_DCSM_Z1_JTAGPSWDL
    ASSERT(SIZEOF(.b0_dcsm_z1_jtagpswdl) == 0 || SIZEOF(.b0_dcsm_z1_jtagpswdl) == 0x8, "b0_dcsm_z1_jtagpswdl: enable the complete group")
    .b0_dcsm_z2_linkpointer1 0x00640400 : { KEEP(*(b0_dcsm_z2_linkpointer1)) } > B0_DCSM_Z2_LINKPOINTER1
    ASSERT(SIZEOF(.b0_dcsm_z2_linkpointer1) == 0 || SIZEOF(.b0_dcsm_z2_linkpointer1) == 0x4, "b0_dcsm_z2_linkpointer1: enable the complete group")
    .b0_dcsm_z2_linkpointer2 0x00640404 : { KEEP(*(b0_dcsm_z2_linkpointer2)) } > B0_DCSM_Z2_LINKPOINTER2
    ASSERT(SIZEOF(.b0_dcsm_z2_linkpointer2) == 0 || SIZEOF(.b0_dcsm_z2_linkpointer2) == 0x4, "b0_dcsm_z2_linkpointer2: enable the complete group")
    .b0_dcsm_z2_linkpointer3 0x00640408 : { KEEP(*(b0_dcsm_z2_linkpointer3)) } > B0_DCSM_Z2_LINKPOINTER3
    ASSERT(SIZEOF(.b0_dcsm_z2_linkpointer3) == 0 || SIZEOF(.b0_dcsm_z2_linkpointer3) == 0x4, "b0_dcsm_z2_linkpointer3: enable the complete group")
    .b0_dcsm_z2_gpreg 0x00640410 : { KEEP(*(b0_dcsm_z2_gpreg)) } > B0_DCSM_Z2_GPREG
    ASSERT(SIZEOF(.b0_dcsm_z2_gpreg) == 0 || SIZEOF(.b0_dcsm_z2_gpreg) == 0x10, "b0_dcsm_z2_gpreg: enable the complete group")
    .b0_dcsm_z2_pswdlock 0x00640420 : { KEEP(*(b0_dcsm_z2_pswdlock)) } > B0_DCSM_Z2_PSWDLOCK
    ASSERT(SIZEOF(.b0_dcsm_z2_pswdlock) == 0 || SIZEOF(.b0_dcsm_z2_pswdlock) == 0x4, "b0_dcsm_z2_pswdlock: enable the complete group")
    .b0_dcsm_z2_crclock 0x00640424 : { KEEP(*(b0_dcsm_z2_crclock)) } > B0_DCSM_Z2_CRCLOCK
    ASSERT(SIZEOF(.b0_dcsm_z2_crclock) == 0 || SIZEOF(.b0_dcsm_z2_crclock) == 0x4, "b0_dcsm_z2_crclock: enable the complete group")
    .b0_dcsm_z2_password 0x00640440 : { KEEP(*(b0_dcsm_z2_password)) } > B0_DCSM_Z2_PASSWORD
    ASSERT(SIZEOF(.b0_dcsm_z2_password) == 0 || SIZEOF(.b0_dcsm_z2_password) == 0x10, "b0_dcsm_z2_password: enable the complete group")
    .b0_dcsm_z2_grab 0x00640450 : { KEEP(*(b0_dcsm_z2_grab)) } > B0_DCSM_Z2_GRAB
    ASSERT(SIZEOF(.b0_dcsm_z2_grab) == 0 || SIZEOF(.b0_dcsm_z2_grab) == 0x10, "b0_dcsm_z2_grab: enable the complete group")
    .b0_dcsm_z2_exeonlysect1 0x00640468 : { KEEP(*(b0_dcsm_z2_exeonlysect1)) } > B0_DCSM_Z2_EXEONLYSECT1
    ASSERT(SIZEOF(.b0_dcsm_z2_exeonlysect1) == 0 || SIZEOF(.b0_dcsm_z2_exeonlysect1) == 0x4, "b0_dcsm_z2_exeonlysect1: enable the complete group")
    .b0_dcsm_z2_exeonlysect2 0x0064046C : { KEEP(*(b0_dcsm_z2_exeonlysect2)) } > B0_DCSM_Z2_EXEONLYSECT2
    ASSERT(SIZEOF(.b0_dcsm_z2_exeonlysect2) == 0 || SIZEOF(.b0_dcsm_z2_exeonlysect2) == 0x4, "b0_dcsm_z2_exeonlysect2: enable the complete group")
    .b0_dcsm_z2_exeonlyram1 0x00640470 : { KEEP(*(b0_dcsm_z2_exeonlyram1)) } > B0_DCSM_Z2_EXEONLYRAM1
    ASSERT(SIZEOF(.b0_dcsm_z2_exeonlyram1) == 0 || SIZEOF(.b0_dcsm_z2_exeonlyram1) == 0x4, "b0_dcsm_z2_exeonlyram1: enable the complete group")
    /DISCARD/ : { *(.comment) *(.riscv.attributes) }
}
