/* Z2 ZSB1 ownership only: retain its factory password and fixed header. */
.section "dcsm_z2_zsb1_grab", "a", @progbits
    .word 0xAAAAAAAA         /* +0x10: GRABSECT1 */
    .word 0xAAAAAAAA         /* +0x14: GRABSECT2 */
    .word 0xAAAAAAFF         /* +0x18: GRABSECT3, no Zone2 claims */
    .word 0xFFFFFFAA         /* +0x1C: GRABRAM1, LS0 A-D nonsecure */
