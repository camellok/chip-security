/***************************************************************
 * Copyright (c) 2019-2026, Beijing Haawking Technology Co., Ltd
 *
 * File  : DCSM.ld
 * Description: linker options for user_otp.(DCSM settings)
 *              Complete fixed-header and ZSB template for Zone1/Zone2.
 *              Built separately; not included by the APP linker.
 ***************************************************************/

/* 280013x-specific coverage: GPREG1-4 in both Zones; Zone1 JLM_ENABLE,
 * JTAGPSWDH0/1 and CMACKEY0-3; ZSB GRABSECT1-3, EXEONLYSECT1/2,
 * GRABRAM1, EXEONLYRAM1 and Zone1 JTAGPSWDL0/1.
 * Header addresses follow the Haawking TRM / supplied hw_dcsm.h.
 * ZSB GRABSECT3 +0x18: accepted experimental inference.
 * ZSB EXEONLYSECT2 +0x2C: inferred, disabled by default in assembly.
 * 28002x BOOTPIN/BOOTDEF offsets must not be reused on this platform.
 */

/*----------------------------------------------------------------------*/
/* Memories                                                             */
/*----------------------------------------------------------------------*/
MEMORY
{
    DCSM_OTP_Z1_LINKPOINTER(rw):      ORIGIN = 0x00640000, LENGTH = 0x0000000C
    DCSM_OTP_Z1_JLM_ENABLE(rw):       ORIGIN = 0x0064000C, LENGTH = 0x00000004
    DCSM_OTP_Z1_GPREG(rw):            ORIGIN = 0x00640010, LENGTH = 0x00000010
    DCSM_OTP_Z1_PSWDLOCK(rw):         ORIGIN = 0x00640020, LENGTH = 0x00000004
    DCSM_OTP_Z1_CRCLOCK(rw):          ORIGIN = 0x00640024, LENGTH = 0x00000004
    DCSM_OTP_Z1_JTAGPSWDH(rw):        ORIGIN = 0x00640028, LENGTH = 0x00000008
    DCSM_OTP_Z1_CMACKEY(rw):          ORIGIN = 0x00640030, LENGTH = 0x00000010
    DCSM_ZSEL_Z1(rw):                 ORIGIN = 0x00640040, LENGTH = 0x00000040/* ZSB1; movable */

    DCSM_OTP_Z2_LINKPOINTER(rw):      ORIGIN = 0x00640400, LENGTH = 0x0000000C
    DCSM_OTP_Z2_RESERVED0(rw):        ORIGIN = 0x0064040C, LENGTH = 0x00000004
    DCSM_OTP_Z2_GPREG(rw):            ORIGIN = 0x00640410, LENGTH = 0x00000010
    DCSM_OTP_Z2_PSWDLOCK(rw):         ORIGIN = 0x00640420, LENGTH = 0x00000004
    DCSM_OTP_Z2_CRCLOCK(rw):          ORIGIN = 0x00640424, LENGTH = 0x00000004
    DCSM_OTP_Z2_RESERVED1(rw):        ORIGIN = 0x00640428, LENGTH = 0x00000018
    DCSM_ZSEL_Z2(rw):                 ORIGIN = 0x00640440, LENGTH = 0x00000040/* ZSB1; movable */

}

/*----------------------------------------------------------------------*/
/* Sections                                                             */
/*----------------------------------------------------------------------*/
SECTIONS
{
    /*----------------------------------------------------------------------*/
    /* Zone1 fixed OTP header                                               */
    /*----------------------------------------------------------------------*/
    .dcsm_otp_z1_linkpointer 0x00640000 :
    {
        KEEP(*(b0_dcsm_otp_z1_linkpointer))
    } > DCSM_OTP_Z1_LINKPOINTER

    .dcsm_otp_z1_jlm_enable 0x0064000C :
    {
        KEEP(*(b0_dcsm_otp_z1_jlm_enable))
    } > DCSM_OTP_Z1_JLM_ENABLE

    .dcsm_otp_z1_gpreg 0x00640010 :
    {
        KEEP(*(b0_dcsm_otp_z1_gpreg))
    } > DCSM_OTP_Z1_GPREG

    .dcsm_otp_z1_pswdlock 0x00640020 :
    {
        KEEP(*(b0_dcsm_otp_z1_pswdlock))
    } > DCSM_OTP_Z1_PSWDLOCK

    .dcsm_otp_z1_crclock 0x00640024 :
    {
        KEEP(*(b0_dcsm_otp_z1_crclock))
    } > DCSM_OTP_Z1_CRCLOCK

    .dcsm_otp_z1_jtagpswdh 0x00640028 :
    {
        KEEP(*(b0_dcsm_otp_z1_jtagpswdh))
    } > DCSM_OTP_Z1_JTAGPSWDH

    .dcsm_otp_z1_cmackey 0x00640030 :
    {
        KEEP(*(b0_dcsm_otp_z1_cmackey))
    } > DCSM_OTP_Z1_CMACKEY

    /*----------------------------------------------------------------------*/
    /* Zone1 Zone Select Block                                              */
    /*----------------------------------------------------------------------*/
    .dcsm_zsel_z1_password (ORIGIN(DCSM_ZSEL_Z1) + 0x00) :
    {
        KEEP(*(b0_dcsm_zsel_z1_password))
    } > DCSM_ZSEL_Z1

    .dcsm_zsel_z1_grab (ORIGIN(DCSM_ZSEL_Z1) + 0x10) :
    {
        KEEP(*(b0_dcsm_zsel_z1_grab))
    } > DCSM_ZSEL_Z1

    .dcsm_zsel_z1_reserved0 (ORIGIN(DCSM_ZSEL_Z1) + 0x20) :
    {
        KEEP(*(b0_dcsm_zsel_z1_reserved0))
    } > DCSM_ZSEL_Z1

    .dcsm_zsel_z1_exeonlysect (ORIGIN(DCSM_ZSEL_Z1) + 0x28) :
    {
        KEEP(*(b0_dcsm_zsel_z1_exeonlysect))
    } > DCSM_ZSEL_Z1

    .dcsm_zsel_z1_exeonlyram1 (ORIGIN(DCSM_ZSEL_Z1) + 0x30) :
    {
        KEEP(*(b0_dcsm_zsel_z1_exeonlyram1))
    } > DCSM_ZSEL_Z1

    .dcsm_zsel_z1_reserved1 (ORIGIN(DCSM_ZSEL_Z1) + 0x34) :
    {
        KEEP(*(b0_dcsm_zsel_z1_reserved1))
    } > DCSM_ZSEL_Z1

    .dcsm_zsel_z1_jtagpswdl (ORIGIN(DCSM_ZSEL_Z1) + 0x38) :
    {
        KEEP(*(b0_dcsm_zsel_z1_jtagpswdl))
    } > DCSM_ZSEL_Z1

    ASSERT(SIZEOF(.dcsm_otp_z1_gpreg) == 0 || SIZEOF(.dcsm_otp_z1_gpreg) == 0x10, "Zone1 GPREG: enable the complete four-word group")
    ASSERT(SIZEOF(.dcsm_zsel_z1_exeonlysect) == 0 || SIZEOF(.dcsm_zsel_z1_exeonlysect) == 0x08, "Zone1 EXEONLYSECT: enable the complete two-word group")
    ASSERT(SIZEOF(.dcsm_zsel_z1_password) == 0 || SIZEOF(.dcsm_zsel_z1_password) == 0x10, "Zone1 password: enable the complete four-word group")
    ASSERT(SIZEOF(.dcsm_zsel_z1_grab) == 0 || SIZEOF(.dcsm_zsel_z1_grab) == 0x10, "Zone1 grab: enable the complete four-word group")

    /*----------------------------------------------------------------------*/
    /* Zone2 fixed OTP header                                               */
    /*----------------------------------------------------------------------*/
    .dcsm_otp_z2_linkpointer 0x00640400 :
    {
        KEEP(*(b0_dcsm_otp_z2_linkpointer))
    } > DCSM_OTP_Z2_LINKPOINTER

    .dcsm_otp_z2_reserved0 0x0064040C :
    {
        KEEP(*(b0_dcsm_otp_z2_reserved0))
    } > DCSM_OTP_Z2_RESERVED0

    .dcsm_otp_z2_gpreg 0x00640410 :
    {
        KEEP(*(b0_dcsm_otp_z2_gpreg))
    } > DCSM_OTP_Z2_GPREG

    .dcsm_otp_z2_pswdlock 0x00640420 :
    {
        KEEP(*(b0_dcsm_otp_z2_pswdlock))
    } > DCSM_OTP_Z2_PSWDLOCK

    .dcsm_otp_z2_crclock 0x00640424 :
    {
        KEEP(*(b0_dcsm_otp_z2_crclock))
    } > DCSM_OTP_Z2_CRCLOCK

    .dcsm_otp_z2_reserved1 0x00640428 :
    {
        KEEP(*(b0_dcsm_otp_z2_reserved1))
    } > DCSM_OTP_Z2_RESERVED1

    /*----------------------------------------------------------------------*/
    /* Zone2 Zone Select Block                                              */
    /*----------------------------------------------------------------------*/
    .dcsm_zsel_z2_password (ORIGIN(DCSM_ZSEL_Z2) + 0x00) :
    {
        KEEP(*(b0_dcsm_zsel_z2_password))
    } > DCSM_ZSEL_Z2

    .dcsm_zsel_z2_grab (ORIGIN(DCSM_ZSEL_Z2) + 0x10) :
    {
        KEEP(*(b0_dcsm_zsel_z2_grab))
    } > DCSM_ZSEL_Z2

    .dcsm_zsel_z2_reserved0 (ORIGIN(DCSM_ZSEL_Z2) + 0x20) :
    {
        KEEP(*(b0_dcsm_zsel_z2_reserved0))
    } > DCSM_ZSEL_Z2

    .dcsm_zsel_z2_exeonlysect (ORIGIN(DCSM_ZSEL_Z2) + 0x28) :
    {
        KEEP(*(b0_dcsm_zsel_z2_exeonlysect))
    } > DCSM_ZSEL_Z2

    .dcsm_zsel_z2_exeonlyram1 (ORIGIN(DCSM_ZSEL_Z2) + 0x30) :
    {
        KEEP(*(b0_dcsm_zsel_z2_exeonlyram1))
    } > DCSM_ZSEL_Z2

    .dcsm_zsel_z2_reserved1 (ORIGIN(DCSM_ZSEL_Z2) + 0x34) :
    {
        KEEP(*(b0_dcsm_zsel_z2_reserved1))
    } > DCSM_ZSEL_Z2

    .dcsm_zsel_z2_reserved2 (ORIGIN(DCSM_ZSEL_Z2) + 0x38) :
    {
        KEEP(*(b0_dcsm_zsel_z2_reserved2))
    } > DCSM_ZSEL_Z2

    ASSERT(SIZEOF(.dcsm_otp_z2_gpreg) == 0 || SIZEOF(.dcsm_otp_z2_gpreg) == 0x10, "Zone2 GPREG: enable the complete four-word group")
    ASSERT(SIZEOF(.dcsm_zsel_z2_exeonlysect) == 0 || SIZEOF(.dcsm_zsel_z2_exeonlysect) == 0x08, "Zone2 EXEONLYSECT: enable the complete two-word group")
    ASSERT(SIZEOF(.dcsm_zsel_z2_password) == 0 || SIZEOF(.dcsm_zsel_z2_password) == 0x10, "Zone2 password: enable the complete four-word group")
    ASSERT(SIZEOF(.dcsm_zsel_z2_grab) == 0 || SIZEOF(.dcsm_zsel_z2_grab) == 0x10, "Zone2 grab: enable the complete four-word group")

    /DISCARD/ :
    {
        *(.comment)
        *(.riscv.attributes)
    }
}
