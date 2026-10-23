/* Separate OTP artifact. Never linked into the application ELF/HEX. */
OUTPUT_ARCH("riscv")
SECTIONS
{
    dcsm_z1_zsb1 0x00640040 : { KEEP(*(dcsm_z1_zsb1)) }
    dcsm_z2_zsb1_grab 0x00640450 : { KEEP(*(dcsm_z2_zsb1_grab)) }
    /DISCARD/ : { *(.comment) *(.riscv.attributes) }
}
ASSERT(SIZEOF(dcsm_z1_zsb1) == 0x20, "Unexpected Z1 ZSB1 payload")
ASSERT(SIZEOF(dcsm_z2_zsb1_grab) == 0x10, "Unexpected Z2 ownership payload")
