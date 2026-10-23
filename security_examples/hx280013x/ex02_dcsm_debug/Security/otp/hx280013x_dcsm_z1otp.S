/* Z1 ZSB1 (0x00640040). Manual preparation for a fresh device only.
 * No LINKPOINTER, PSWDLOCK, JTAGLOCK, CMAC or boot words are emitted.
 * Verify device OTP and all factory-programmed bits before programming.
 */
#include "../password_values.h"
.section "dcsm_z1_zsb1", "a", @progbits
    .word DEMO_Z1_KEY0       /* +0x00: CSMPSWD0 */
    .word DEMO_Z1_KEY1       /* +0x04: CSMPSWD1, subset of factory 0x4D7FFFFF */
    .word DEMO_Z1_KEY2       /* +0x08: CSMPSWD2 */
    .word DEMO_Z1_KEY3       /* +0x0C: CSMPSWD3 */
    .word 0xAAAAAAAA         /* +0x10: GRABSECT1, sector0-15 nonsecure */
    .word 0xAAAAAAAA         /* +0x14: GRABSECT2, sector16-31 nonsecure */
    .word 0xAAAAA5FF         /* +0x18: GRABSECT3, sector32-47 Zone1 */
    .word 0xFFFFFFAA         /* +0x1C: GRABRAM1, LS0 A-D nonsecure */
/* Remaining ZSB fields are intentionally omitted, preserving factory contents. */
