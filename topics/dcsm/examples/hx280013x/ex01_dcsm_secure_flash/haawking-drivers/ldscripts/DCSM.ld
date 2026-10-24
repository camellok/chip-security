/***************************************************************
 * Copyright (c) 2019-2026, Beijing Haawking Technology Co., Ltd
 *
 * File  : DCSM.ld
 * Description: user OTP configuration for 280013x.
 *              Used by the default APP ELF.
 ***************************************************************/

/* ZSB1. Change these bases together with LINKPOINTER and slot password masks. */
DCSM_Z1_ZSB_BASE = 0x00640040;
DCSM_Z2_ZSB_BASE = 0x00640440;

/*----------------------------------------------------------------------*/
/* Memories                                                             */
/*----------------------------------------------------------------------*/
MEMORY
{
    DCSM_OTP_Z1_LINKPOINTER(rw):        ORIGIN = 0x00640000, LENGTH = 0x0C
    DCSM_OTP_Z1_JLM_ENABLE(rw):         ORIGIN = 0x0064000C, LENGTH = 0x04
    DCSM_OTP_Z1_GPREG(rw):              ORIGIN = 0x00640010, LENGTH = 0x10
    DCSM_OTP_Z1_PSWDLOCK(rw):           ORIGIN = 0x00640020, LENGTH = 0x04
    DCSM_OTP_Z1_CRCLOCK(rw):            ORIGIN = 0x00640024, LENGTH = 0x04
    DCSM_OTP_Z1_JTAGPSWDH(rw):          ORIGIN = 0x00640028, LENGTH = 0x08
    DCSM_OTP_Z1_CMACKEY(rw):            ORIGIN = 0x00640030, LENGTH = 0x10

    DCSM_ZSEL_Z1_PASSWORD(rw):          ORIGIN = DCSM_Z1_ZSB_BASE + 0x00, LENGTH = 0x10
    DCSM_ZSEL_Z1_GRAB(rw):              ORIGIN = DCSM_Z1_ZSB_BASE + 0x10, LENGTH = 0x10
    DCSM_ZSEL_Z1_EXEONLYSECT(rw):       ORIGIN = DCSM_Z1_ZSB_BASE + 0x28, LENGTH = 0x08
    DCSM_ZSEL_Z1_EXEONLYRAM1(rw):       ORIGIN = DCSM_Z1_ZSB_BASE + 0x30, LENGTH = 0x04
    DCSM_ZSEL_Z1_JTAGPSWDL(rw):         ORIGIN = DCSM_Z1_ZSB_BASE + 0x38, LENGTH = 0x08

    DCSM_OTP_Z2_LINKPOINTER(rw):        ORIGIN = 0x00640400, LENGTH = 0x0C
    DCSM_OTP_Z2_GPREG(rw):              ORIGIN = 0x00640410, LENGTH = 0x10
    DCSM_OTP_Z2_PSWDLOCK(rw):           ORIGIN = 0x00640420, LENGTH = 0x04
    DCSM_OTP_Z2_CRCLOCK(rw):            ORIGIN = 0x00640424, LENGTH = 0x04

    DCSM_ZSEL_Z2_PASSWORD(rw):          ORIGIN = DCSM_Z2_ZSB_BASE + 0x00, LENGTH = 0x10
    DCSM_ZSEL_Z2_GRAB(rw):              ORIGIN = DCSM_Z2_ZSB_BASE + 0x10, LENGTH = 0x10
    DCSM_ZSEL_Z2_EXEONLYSECT(rw):       ORIGIN = DCSM_Z2_ZSB_BASE + 0x28, LENGTH = 0x08
    DCSM_ZSEL_Z2_EXEONLYRAM1(rw):       ORIGIN = DCSM_Z2_ZSB_BASE + 0x30, LENGTH = 0x04

}

/* Reserved offsets have no output sections and are never filled.
 * GRABSECT3 +0x18: accepted experimental layout.
 * EXEONLYSECT2 +0x2C: inferred, disabled by default in assembly.
 * Separate group regions keep optional groups at their offsets without padding.
 */

/*----------------------------------------------------------------------*/
/* Sections                                                             */
/*----------------------------------------------------------------------*/
SECTIONS
{
    /* Zone1 fixed OTP header */
    . = ORIGIN(DCSM_OTP_Z1_LINKPOINTER);
    .dcsm_otp_z1_linkpointer :
    {
        KEEP(*(b0_dcsm_otp_z1_linkpointer))
    } > DCSM_OTP_Z1_LINKPOINTER

    . = ORIGIN(DCSM_OTP_Z1_JLM_ENABLE);
    .dcsm_otp_z1_jlm_enable :
    {
        KEEP(*(b0_dcsm_otp_z1_jlm_enable))
    } > DCSM_OTP_Z1_JLM_ENABLE

    . = ORIGIN(DCSM_OTP_Z1_GPREG);
    .dcsm_otp_z1_gpreg :
    {
        KEEP(*(b0_dcsm_otp_z1_gpreg))
    } > DCSM_OTP_Z1_GPREG

    ASSERT(SIZEOF(.dcsm_otp_z1_gpreg) == 0 || SIZEOF(.dcsm_otp_z1_gpreg) == 0x10, "Zone1 GPREG: enable the complete group")

    . = ORIGIN(DCSM_OTP_Z1_PSWDLOCK);
    .dcsm_otp_z1_pswdlock :
    {
        KEEP(*(b0_dcsm_otp_z1_pswdlock))
    } > DCSM_OTP_Z1_PSWDLOCK

    . = ORIGIN(DCSM_OTP_Z1_CRCLOCK);
    .dcsm_otp_z1_crclock :
    {
        KEEP(*(b0_dcsm_otp_z1_crclock))
    } > DCSM_OTP_Z1_CRCLOCK

    . = ORIGIN(DCSM_OTP_Z1_JTAGPSWDH);
    .dcsm_otp_z1_jtagpswdh :
    {
        KEEP(*(b0_dcsm_otp_z1_jtagpswdh))
    } > DCSM_OTP_Z1_JTAGPSWDH

    ASSERT(SIZEOF(.dcsm_otp_z1_jtagpswdh) == 0 || SIZEOF(.dcsm_otp_z1_jtagpswdh) == 0x08, "Zone1 JTAGPSWDH: enable the complete group")

    . = ORIGIN(DCSM_OTP_Z1_CMACKEY);
    .dcsm_otp_z1_cmackey :
    {
        KEEP(*(b0_dcsm_otp_z1_cmackey))
    } > DCSM_OTP_Z1_CMACKEY

    ASSERT(SIZEOF(.dcsm_otp_z1_cmackey) == 0 || SIZEOF(.dcsm_otp_z1_cmackey) == 0x10, "Zone1 CMACKEY: enable the complete group")

    /* Zone1 Zone Select Block */
    . = ORIGIN(DCSM_ZSEL_Z1_PASSWORD);
    .dcsm_zsel_z1_password :
    {
        KEEP(*(b0_dcsm_zsel_z1_password))
    } > DCSM_ZSEL_Z1_PASSWORD

    ASSERT(SIZEOF(.dcsm_zsel_z1_password) == 0 || SIZEOF(.dcsm_zsel_z1_password) == 0x10, "Zone1 PASSWORD: enable the complete group")

    . = ORIGIN(DCSM_ZSEL_Z1_GRAB);
    .dcsm_zsel_z1_grab :
    {
        KEEP(*(b0_dcsm_zsel_z1_grab))
    } > DCSM_ZSEL_Z1_GRAB

    ASSERT(SIZEOF(.dcsm_zsel_z1_grab) == 0 || SIZEOF(.dcsm_zsel_z1_grab) == 0x10, "Zone1 GRAB: enable the complete group")

    . = ORIGIN(DCSM_ZSEL_Z1_EXEONLYSECT);
    .dcsm_zsel_z1_exeonlysect :
    {
        KEEP(*(b0_dcsm_zsel_z1_exeonlysect))
    } > DCSM_ZSEL_Z1_EXEONLYSECT

    ASSERT(SIZEOF(.dcsm_zsel_z1_exeonlysect) == 0 || SIZEOF(.dcsm_zsel_z1_exeonlysect) == 0x08, "Zone1 EXEONLYSECT: enable the complete group")

    . = ORIGIN(DCSM_ZSEL_Z1_EXEONLYRAM1);
    .dcsm_zsel_z1_exeonlyram1 :
    {
        KEEP(*(b0_dcsm_zsel_z1_exeonlyram1))
    } > DCSM_ZSEL_Z1_EXEONLYRAM1

    . = ORIGIN(DCSM_ZSEL_Z1_JTAGPSWDL);
    .dcsm_zsel_z1_jtagpswdl :
    {
        KEEP(*(b0_dcsm_zsel_z1_jtagpswdl))
    } > DCSM_ZSEL_Z1_JTAGPSWDL

    ASSERT(SIZEOF(.dcsm_zsel_z1_jtagpswdl) == 0 || SIZEOF(.dcsm_zsel_z1_jtagpswdl) == 0x08, "Zone1 JTAGPSWDL: enable the complete group")

    /* Zone2 fixed OTP header */
    . = ORIGIN(DCSM_OTP_Z2_LINKPOINTER);
    .dcsm_otp_z2_linkpointer :
    {
        KEEP(*(b0_dcsm_otp_z2_linkpointer))
    } > DCSM_OTP_Z2_LINKPOINTER

    . = ORIGIN(DCSM_OTP_Z2_GPREG);
    .dcsm_otp_z2_gpreg :
    {
        KEEP(*(b0_dcsm_otp_z2_gpreg))
    } > DCSM_OTP_Z2_GPREG

    ASSERT(SIZEOF(.dcsm_otp_z2_gpreg) == 0 || SIZEOF(.dcsm_otp_z2_gpreg) == 0x10, "Zone2 GPREG: enable the complete group")

    . = ORIGIN(DCSM_OTP_Z2_PSWDLOCK);
    .dcsm_otp_z2_pswdlock :
    {
        KEEP(*(b0_dcsm_otp_z2_pswdlock))
    } > DCSM_OTP_Z2_PSWDLOCK

    . = ORIGIN(DCSM_OTP_Z2_CRCLOCK);
    .dcsm_otp_z2_crclock :
    {
        KEEP(*(b0_dcsm_otp_z2_crclock))
    } > DCSM_OTP_Z2_CRCLOCK

    /* Zone2 Zone Select Block */
    . = ORIGIN(DCSM_ZSEL_Z2_PASSWORD);
    .dcsm_zsel_z2_password :
    {
        KEEP(*(b0_dcsm_zsel_z2_password))
    } > DCSM_ZSEL_Z2_PASSWORD

    ASSERT(SIZEOF(.dcsm_zsel_z2_password) == 0 || SIZEOF(.dcsm_zsel_z2_password) == 0x10, "Zone2 PASSWORD: enable the complete group")

    . = ORIGIN(DCSM_ZSEL_Z2_GRAB);
    .dcsm_zsel_z2_grab :
    {
        KEEP(*(b0_dcsm_zsel_z2_grab))
    } > DCSM_ZSEL_Z2_GRAB

    ASSERT(SIZEOF(.dcsm_zsel_z2_grab) == 0 || SIZEOF(.dcsm_zsel_z2_grab) == 0x10, "Zone2 GRAB: enable the complete group")

    . = ORIGIN(DCSM_ZSEL_Z2_EXEONLYSECT);
    .dcsm_zsel_z2_exeonlysect :
    {
        KEEP(*(b0_dcsm_zsel_z2_exeonlysect))
    } > DCSM_ZSEL_Z2_EXEONLYSECT

    ASSERT(SIZEOF(.dcsm_zsel_z2_exeonlysect) == 0 || SIZEOF(.dcsm_zsel_z2_exeonlysect) == 0x08, "Zone2 EXEONLYSECT: enable the complete group")

    . = ORIGIN(DCSM_ZSEL_Z2_EXEONLYRAM1);
    .dcsm_zsel_z2_exeonlyram1 :
    {
        KEEP(*(b0_dcsm_zsel_z2_exeonlyram1))
    } > DCSM_ZSEL_Z2_EXEONLYRAM1

    /DISCARD/ :
    {
        *(.comment)
        *(.riscv.attributes)
    }
}
