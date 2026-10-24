/* Copyright (c) 2019-2026, Beijing Haawking Technology Co., Ltd
 * OTP-only reference. All accompanying groups are empty by default.
 * No padding/fill. Not an APP script or factory restore image.
 * Enable complete groups only after confirming target-specific OTP.
 */
MEMORY
{
    B0_DCSM_Z1_LINKPOINTER1 (r) : ORIGIN = 0x007A0000, LENGTH = 0x04
    B0_DCSM_Z1_LINKPOINTER2 (r) : ORIGIN = 0x007A0008, LENGTH = 0x04
    B0_DCSM_Z1_LINKPOINTER3 (r) : ORIGIN = 0x007A0010, LENGTH = 0x04
    B0_DCSM_Z1_GPREG (r) : ORIGIN = 0x007A0018, LENGTH = 0x08
    B0_DCSM_Z1_PSWDLOCK (r) : ORIGIN = 0x007A0020, LENGTH = 0x04
    B0_DCSM_Z1_CRCLOCK (r) : ORIGIN = 0x007A0028, LENGTH = 0x04
    B0_DCSM_Z1_JTAGLOCK (r) : ORIGIN = 0x007A0030, LENGTH = 0x04
    B0_DCSM_Z1_BOOTCTRL (r) : ORIGIN = 0x007A0038, LENGTH = 0x08
    B0_DCSM_Z1_EXEONLY (r) : ORIGIN = 0x007A0040, LENGTH = 0x08
    B0_DCSM_Z1_GRAB (r) : ORIGIN = 0x007A0048, LENGTH = 0x08
    B0_DCSM_Z1_PASSWORD (r) : ORIGIN = 0x007A0050, LENGTH = 0x10
    B0_DCSM_Z2_LINKPOINTER1 (r) : ORIGIN = 0x007A0400, LENGTH = 0x04
    B0_DCSM_Z2_LINKPOINTER2 (r) : ORIGIN = 0x007A0408, LENGTH = 0x04
    B0_DCSM_Z2_LINKPOINTER3 (r) : ORIGIN = 0x007A0410, LENGTH = 0x04
    B0_DCSM_Z2_GPREG (r) : ORIGIN = 0x007A0418, LENGTH = 0x08
    B0_DCSM_Z2_PSWDLOCK (r) : ORIGIN = 0x007A0420, LENGTH = 0x04
    B0_DCSM_Z2_CRCLOCK (r) : ORIGIN = 0x007A0428, LENGTH = 0x04
    B0_DCSM_Z2_BOOTCTRL (r) : ORIGIN = 0x007A0438, LENGTH = 0x08
    B0_DCSM_Z2_EXEONLY (r) : ORIGIN = 0x007A0440, LENGTH = 0x08
    B0_DCSM_Z2_GRAB (r) : ORIGIN = 0x007A0448, LENGTH = 0x08
    B0_DCSM_Z2_PASSWORD (r) : ORIGIN = 0x007A0450, LENGTH = 0x10
}
SECTIONS
{
    .b0_dcsm_z1_linkpointer1 0x007A0000 : { KEEP(*(b0_dcsm_z1_linkpointer1)) } > B0_DCSM_Z1_LINKPOINTER1
    ASSERT(SIZEOF(.b0_dcsm_z1_linkpointer1) == 0 || SIZEOF(.b0_dcsm_z1_linkpointer1) == 0x4, "b0_dcsm_z1_linkpointer1: enable the complete group")
    .b0_dcsm_z1_linkpointer2 0x007A0008 : { KEEP(*(b0_dcsm_z1_linkpointer2)) } > B0_DCSM_Z1_LINKPOINTER2
    ASSERT(SIZEOF(.b0_dcsm_z1_linkpointer2) == 0 || SIZEOF(.b0_dcsm_z1_linkpointer2) == 0x4, "b0_dcsm_z1_linkpointer2: enable the complete group")
    .b0_dcsm_z1_linkpointer3 0x007A0010 : { KEEP(*(b0_dcsm_z1_linkpointer3)) } > B0_DCSM_Z1_LINKPOINTER3
    ASSERT(SIZEOF(.b0_dcsm_z1_linkpointer3) == 0 || SIZEOF(.b0_dcsm_z1_linkpointer3) == 0x4, "b0_dcsm_z1_linkpointer3: enable the complete group")
    .b0_dcsm_z1_gpreg 0x007A0018 : { KEEP(*(b0_dcsm_z1_gpreg)) } > B0_DCSM_Z1_GPREG
    ASSERT(SIZEOF(.b0_dcsm_z1_gpreg) == 0 || SIZEOF(.b0_dcsm_z1_gpreg) == 0x8, "b0_dcsm_z1_gpreg: enable the complete group")
    .b0_dcsm_z1_pswdlock 0x007A0020 : { KEEP(*(b0_dcsm_z1_pswdlock)) } > B0_DCSM_Z1_PSWDLOCK
    ASSERT(SIZEOF(.b0_dcsm_z1_pswdlock) == 0 || SIZEOF(.b0_dcsm_z1_pswdlock) == 0x4, "b0_dcsm_z1_pswdlock: enable the complete group")
    .b0_dcsm_z1_crclock 0x007A0028 : { KEEP(*(b0_dcsm_z1_crclock)) } > B0_DCSM_Z1_CRCLOCK
    ASSERT(SIZEOF(.b0_dcsm_z1_crclock) == 0 || SIZEOF(.b0_dcsm_z1_crclock) == 0x4, "b0_dcsm_z1_crclock: enable the complete group")
    .b0_dcsm_z1_jtaglock 0x007A0030 : { KEEP(*(b0_dcsm_z1_jtaglock)) } > B0_DCSM_Z1_JTAGLOCK
    ASSERT(SIZEOF(.b0_dcsm_z1_jtaglock) == 0 || SIZEOF(.b0_dcsm_z1_jtaglock) == 0x4, "b0_dcsm_z1_jtaglock: enable the complete group")
    .b0_dcsm_z1_bootctrl 0x007A0038 : { KEEP(*(b0_dcsm_z1_bootctrl)) } > B0_DCSM_Z1_BOOTCTRL
    ASSERT(SIZEOF(.b0_dcsm_z1_bootctrl) == 0 || SIZEOF(.b0_dcsm_z1_bootctrl) == 0x8, "b0_dcsm_z1_bootctrl: enable the complete group")
    .b0_dcsm_z1_exeonly 0x007A0040 : { KEEP(*(b0_dcsm_z1_exeonly)) } > B0_DCSM_Z1_EXEONLY
    ASSERT(SIZEOF(.b0_dcsm_z1_exeonly) == 0 || SIZEOF(.b0_dcsm_z1_exeonly) == 0x8, "b0_dcsm_z1_exeonly: enable the complete group")
    .b0_dcsm_z1_grab 0x007A0048 : { KEEP(*(b0_dcsm_z1_grab)) } > B0_DCSM_Z1_GRAB
    ASSERT(SIZEOF(.b0_dcsm_z1_grab) == 0 || SIZEOF(.b0_dcsm_z1_grab) == 0x8, "b0_dcsm_z1_grab: enable the complete group")
    .b0_dcsm_z1_password 0x007A0050 : { KEEP(*(b0_dcsm_z1_password)) } > B0_DCSM_Z1_PASSWORD
    ASSERT(SIZEOF(.b0_dcsm_z1_password) == 0 || SIZEOF(.b0_dcsm_z1_password) == 0x10, "b0_dcsm_z1_password: enable the complete group")
    .b0_dcsm_z2_linkpointer1 0x007A0400 : { KEEP(*(b0_dcsm_z2_linkpointer1)) } > B0_DCSM_Z2_LINKPOINTER1
    ASSERT(SIZEOF(.b0_dcsm_z2_linkpointer1) == 0 || SIZEOF(.b0_dcsm_z2_linkpointer1) == 0x4, "b0_dcsm_z2_linkpointer1: enable the complete group")
    .b0_dcsm_z2_linkpointer2 0x007A0408 : { KEEP(*(b0_dcsm_z2_linkpointer2)) } > B0_DCSM_Z2_LINKPOINTER2
    ASSERT(SIZEOF(.b0_dcsm_z2_linkpointer2) == 0 || SIZEOF(.b0_dcsm_z2_linkpointer2) == 0x4, "b0_dcsm_z2_linkpointer2: enable the complete group")
    .b0_dcsm_z2_linkpointer3 0x007A0410 : { KEEP(*(b0_dcsm_z2_linkpointer3)) } > B0_DCSM_Z2_LINKPOINTER3
    ASSERT(SIZEOF(.b0_dcsm_z2_linkpointer3) == 0 || SIZEOF(.b0_dcsm_z2_linkpointer3) == 0x4, "b0_dcsm_z2_linkpointer3: enable the complete group")
    .b0_dcsm_z2_gpreg 0x007A0418 : { KEEP(*(b0_dcsm_z2_gpreg)) } > B0_DCSM_Z2_GPREG
    ASSERT(SIZEOF(.b0_dcsm_z2_gpreg) == 0 || SIZEOF(.b0_dcsm_z2_gpreg) == 0x8, "b0_dcsm_z2_gpreg: enable the complete group")
    .b0_dcsm_z2_pswdlock 0x007A0420 : { KEEP(*(b0_dcsm_z2_pswdlock)) } > B0_DCSM_Z2_PSWDLOCK
    ASSERT(SIZEOF(.b0_dcsm_z2_pswdlock) == 0 || SIZEOF(.b0_dcsm_z2_pswdlock) == 0x4, "b0_dcsm_z2_pswdlock: enable the complete group")
    .b0_dcsm_z2_crclock 0x007A0428 : { KEEP(*(b0_dcsm_z2_crclock)) } > B0_DCSM_Z2_CRCLOCK
    ASSERT(SIZEOF(.b0_dcsm_z2_crclock) == 0 || SIZEOF(.b0_dcsm_z2_crclock) == 0x4, "b0_dcsm_z2_crclock: enable the complete group")
    .b0_dcsm_z2_bootctrl 0x007A0438 : { KEEP(*(b0_dcsm_z2_bootctrl)) } > B0_DCSM_Z2_BOOTCTRL
    ASSERT(SIZEOF(.b0_dcsm_z2_bootctrl) == 0 || SIZEOF(.b0_dcsm_z2_bootctrl) == 0x8, "b0_dcsm_z2_bootctrl: enable the complete group")
    .b0_dcsm_z2_exeonly 0x007A0440 : { KEEP(*(b0_dcsm_z2_exeonly)) } > B0_DCSM_Z2_EXEONLY
    ASSERT(SIZEOF(.b0_dcsm_z2_exeonly) == 0 || SIZEOF(.b0_dcsm_z2_exeonly) == 0x8, "b0_dcsm_z2_exeonly: enable the complete group")
    .b0_dcsm_z2_grab 0x007A0448 : { KEEP(*(b0_dcsm_z2_grab)) } > B0_DCSM_Z2_GRAB
    ASSERT(SIZEOF(.b0_dcsm_z2_grab) == 0 || SIZEOF(.b0_dcsm_z2_grab) == 0x8, "b0_dcsm_z2_grab: enable the complete group")
    .b0_dcsm_z2_password 0x007A0450 : { KEEP(*(b0_dcsm_z2_password)) } > B0_DCSM_Z2_PASSWORD
    ASSERT(SIZEOF(.b0_dcsm_z2_password) == 0 || SIZEOF(.b0_dcsm_z2_password) == 0x10, "b0_dcsm_z2_password: enable the complete group")
    /DISCARD/ : { *(.comment) *(.riscv.attributes) }
}
