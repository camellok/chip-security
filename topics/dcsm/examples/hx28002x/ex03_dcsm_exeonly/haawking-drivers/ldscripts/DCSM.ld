/***************************************************************
 * Copyright (c) 2019-2026, Beijing Haawking Technology Co., Ltd
 *
 * Author: Silin Luo
 * Email : silin.luo@mail.haawking.com
 * File  : DCSM.ld
 * Description: linker options for user_otp.(DCSM settings)
 ***************************************************************/

/*----------------------------------------------------------------------*/
/* Memories                                                             */
/*----------------------------------------------------------------------*/
MEMORY
{
    DCSM_OTP_Z1_LINKPOINTER(rw):   ORIGIN = 0x007A0000, LENGTH = 0x00000018/* Z1 OTP */
    DCSM_OTP_Z1_GPREG(rw):         ORIGIN = 0x007A0018, LENGTH = 0x00000008
    DCSM_OTP_Z1_PSWDLOCK(rw):      ORIGIN = 0x007A0020, LENGTH = 0x00000008
    DCSM_OTP_Z1_CRCLOCK(rw):       ORIGIN = 0x007A0028, LENGTH = 0x00000008
    DCSM_OTP_Z1_JTAGLOCK(rw):      ORIGIN = 0x007A0030, LENGTH = 0x00000008
    DCSM_OTP_Z1_BOOTCTRL(rw):      ORIGIN = 0x007A0038, LENGTH = 0x00000008
    DCSM_ZSEL_Z1(rw):              ORIGIN = 0x007A0080, LENGTH = 0x00000020/* Zone1 ZSB3: shared ex03/ex04 profile */

    DCSM_OTP_Z2_LINKPOINTER(rw):   ORIGIN = 0x007A0400, LENGTH = 0x18
    DCSM_OTP_Z2_GPREG(rw):         ORIGIN = 0x007A0418, LENGTH = 0x08
    DCSM_OTP_Z2_PSWDLOCK(rw):      ORIGIN = 0x007A0420, LENGTH = 0x08
    DCSM_OTP_Z2_CRCLOCK(rw):       ORIGIN = 0x007A0428, LENGTH = 0x08
    /* 0x7A0430..0x7A0437 remains reserved per the supplied TRM. */
    DCSM_OTP_Z2_BOOTCTRL(rw):      ORIGIN = 0x007A0438, LENGTH = 0x08
    DCSM_ZSEL_Z2(rw):              ORIGIN = 0x007A0440, LENGTH = 0x20
}

/*----------------------------------------------------------------------*/
/* Sections                                                             */
/*----------------------------------------------------------------------*/
SECTIONS
{
    /*----------------------------------------------------------------------*/
    /* Zone1                                                                */
    /*----------------------------------------------------------------------*/
    . = 0x007A0000;
    .dcsm_otp_z1_linkpointer :
    {
        KEEP(*(b0_dcsm_otp_z1_linkpointer))
    } > DCSM_OTP_Z1_LINKPOINTER

    . = 0x007A0018;
    .dcsm_otp_z1_gpreg :
    {
        KEEP(*(b0_dcsm_otp_z1_gpreg))
    } > DCSM_OTP_Z1_GPREG

    . = 0x007A0020;
    .dcsm_otp_z1_pswdlock :
    {
        KEEP(*(b0_dcsm_otp_z1_pswdlock))
    } > DCSM_OTP_Z1_PSWDLOCK

    . = 0x007A0028;
    .dcsm_otp_z1_crclock :
    {
        KEEP(*(b0_dcsm_otp_z1_crclock))
    } > DCSM_OTP_Z1_CRCLOCK

    . = 0x007A0030;
    .dcsm_otp_z1_jtaglock :
    {
        KEEP(*(b0_dcsm_otp_z1_jtaglock))
    } > DCSM_OTP_Z1_JTAGLOCK

    . = 0x007A0038;
    .dcsm_otp_z1_bootctrl :
    {
        KEEP(*(b0_dcsm_otp_z1_bootctrl))
    } > DCSM_OTP_Z1_BOOTCTRL

    . = 0x007A0080;
    .dcsm_zsel_z1 :
    {
        KEEP(*(b0_dcsm_zsel_z1))
    } > DCSM_ZSEL_Z1

    /*----------------------------------------------------------------------*/
    /* Zone2                                                                */
    /*----------------------------------------------------------------------*/
    . = 0x007A0400;
    .dcsm_otp_z2_linkpointer :
    {
        KEEP(*(b0_dcsm_otp_z2_linkpointer))
    } > DCSM_OTP_Z2_LINKPOINTER

    . = 0x007A0418;
    .dcsm_otp_z2_gpreg :
    {
        KEEP(*(b0_dcsm_otp_z2_gpreg))
    } > DCSM_OTP_Z2_GPREG

    . = 0x007A0420;
    .dcsm_otp_z2_pswdlock :
    {
        KEEP(*(b0_dcsm_otp_z2_pswdlock))
    } > DCSM_OTP_Z2_PSWDLOCK

    . = 0x007A0428;
    .dcsm_otp_z2_crclock :
    {
        KEEP(*(b0_dcsm_otp_z2_crclock))
    } > DCSM_OTP_Z2_CRCLOCK

    . = 0x007A0438;
    .dcsm_otp_z2_bootctrl :
    {
        KEEP(*(b0_dcsm_otp_z2_bootctrl))
    } > DCSM_OTP_Z2_BOOTCTRL

    . = 0x007A0440;
    .dcsm_zsel_z2 :
    {
        KEEP(*(b0_dcsm_zsel_z2))
    } > DCSM_ZSEL_Z2
}
