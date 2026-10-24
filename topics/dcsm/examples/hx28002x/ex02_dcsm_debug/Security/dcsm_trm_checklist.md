# DCSM Memory Map Fill-In Sheet

This sheet is only for confirming the Haawking DCSM OTP memory map.

Assumption for this version:

- DCSM capability boundary is aligned with TI C2000.
- The main task here is to confirm the Haawking memory map and final linker placement.

Project:

- Example name:
- Device name:
- TRM version:
- TRM chapter:
- Checked by:
- Date:

## 1. Zone 1 OTP address map

| Block | Section name in asm | Start address | End address | Word count | Notes |
| --- | --- | --- | --- | --- | --- |
| Z1 LINKPOINTER | `dcsm_otp_z1_linkpointer` | `0x7A0000` | `0x7A0014` | `6` | `LINKPOINTER1/2/3 + reserved interleave` |
| Z1 GPREG | `dcsm_otp_z1_gpreg` | `0x7A0018` | `0x7A001C` | `2` | `Z1OTP_GPREG1`, `Z1OTP_GPREG2` |
| Z1 PSWDLOCK | `dcsm_otp_z1_pswdlock` | `0x7A0020` | `0x7A0024` | `2` | `PSWDLOCK + reserved` |
| Z1 CRCLOCK | `dcsm_otp_z1_crclock` | `0x7A0028` | `0x7A002C` | `2` | `CRCLOCK + reserved` |
| Z1 BOOTCTRL | `dcsm_otp_z1_bootctrl` | `0x7A0038` | `0x7A003C` | `2` | `Z1OTP_GPREG3`, `Z1OTP_BOOTCTRL` |
| Z1 ZSB region | `dcsm_zsel_z1` | `0x7A0040` | `0x7A03FF` | `240` | `30 blocks x 8 words, each block is 0x20 bytes` |
| Z1 RESERVED gap | N/A | `0x7A0030` | `0x7A0034` | `2` | `Reserved in screenshot` |

## 2. Zone 2 OTP address map

| Block | Section name in asm | Start address | End address | Word count | Notes |
| --- | --- | --- | --- | --- | --- |
| Z2 LINKPOINTER | `dcsm_otp_z2_linkpointer` | `0x7A0400` | `0x7A0414` | `6` | `LINKPOINTER1/2/3 + reserved interleave` |
| Z2 GPREG | `dcsm_otp_z2_gpreg` | `0x7A0418` | `0x7A041C` | `2` | `Z2OTP_GPREG1`, `Z2OTP_GPREG2` |
| Z2 PSWDLOCK | `dcsm_otp_z2_pswdlock` | `0x7A0420` | `0x7A0424` | `2` | `PSWDLOCK + reserved` |
| Z2 CRCLOCK | `dcsm_otp_z2_crclock` | `0x7A0428` | `0x7A042C` | `2` | `CRCLOCK + reserved` |
| Z2 BOOTCTRL | `dcsm_otp_z2_bootctrl` | `0x7A0438` | `0x7A043C` | `2` | `Z2OTP_GPREG3`, `Z2OTP_BOOTCTRL` |
| Z2 ZSB region | `dcsm_zsel_z2` | `0x7A0440` | `0x7A07FF` | `240` | `30 blocks x 8 words, each block is 0x20 bytes` |
| Z2 RESERVED gap | N/A | `0x7A0430` | `0x7A0434` | `2` | `Reserved in screenshot` |

## 3. Bank split mapping

Current screenshots only confirm Bank0 layout. Keep Bank1 blank until a matching TRM page is found.

| Zone | Bank | Block | Start address | End address | Notes |
| --- | --- | --- | --- | --- | --- |
| Z1 | B0 | LINKPOINTER | `0x7A0000` | `0x7A0014` |  |
| Z1 | B0 | GPREG | `0x7A0018` | `0x7A001C` | `GPREG1/2` |
| Z1 | B0 | PSWDLOCK | `0x7A0020` | `0x7A0024` |  |
| Z1 | B0 | CRCLOCK | `0x7A0028` | `0x7A002C` |  |
| Z1 | B0 | BOOTCTRL | `0x7A0038` | `0x7A003C` | `GPREG3 + BOOTCTRL` |
| Z1 | B0 | ZSB | `0x7A0040` | `0x7A03FF` |  |
| Z1 | B1 | LINKPOINTER |  |  |  |
| Z1 | B1 | ZSB |  |  |  |
| Z2 | B0 | LINKPOINTER | `0x7A0400` | `0x7A0414` |  |
| Z2 | B0 | GPREG | `0x7A0418` | `0x7A041C` | `GPREG1/2` |
| Z2 | B0 | PSWDLOCK | `0x7A0420` | `0x7A0424` |  |
| Z2 | B0 | CRCLOCK | `0x7A0428` | `0x7A042C` |  |
| Z2 | B0 | BOOTCTRL | `0x7A0438` | `0x7A043C` | `GPREG3 + BOOTCTRL` |
| Z2 | B0 | ZSB | `0x7A0440` | `0x7A07FF` |  |
| Z2 | B1 | LINKPOINTER |  |  |  |
| Z2 | B1 | ZSB |  |  |  |

## 4. Link pointer decode result

| Zone | Link pointer value field | Raw address | Decoded ZSB address | Notes |
| --- | --- | --- | --- | --- |
| Z1 | B0_Z1OTP_LINKPOINTER1 | `0x7A0000` |  | `Decode rule not yet captured from screenshot` |
| Z1 | B0_Z1OTP_LINKPOINTER2 | `0x7A0008` |  | `Decode rule not yet captured from screenshot` |
| Z1 | B0_Z1OTP_LINKPOINTER3 | `0x7A0010` |  | `Decode rule not yet captured from screenshot` |
| Z2 | B0_Z2OTP_LINKPOINTER1 | `0x7A0400` |  | `Decode rule not yet captured from screenshot` |
| Z2 | B0_Z2OTP_LINKPOINTER2 | `0x7A0408` |  | `Decode rule not yet captured from screenshot` |
| Z2 | B0_Z2OTP_LINKPOINTER3 | `0x7A0410` |  | `Decode rule not yet captured from screenshot` |

## 5. Password word address mapping

| Zone | Password word | Address | Notes |
| --- | --- | --- | --- |
| Z1 | CSMPSWD0 | `ZSB base + 0x10` | `For Zone Select Block1: 0x7A0050` |
| Z1 | CSMPSWD1 | `ZSB base + 0x14` | `For Zone Select Block1: 0x7A0054` |
| Z1 | CSMPSWD2 | `ZSB base + 0x18` | `For Zone Select Block1: 0x7A0058` |
| Z1 | CSMPSWD3 | `ZSB base + 0x1C` | `For Zone Select Block1: 0x7A005C` |
| Z2 | CSMPSWD0 | `ZSB base + 0x10` | `For Zone Select Block1: 0x7A0450` |
| Z2 | CSMPSWD1 | `ZSB base + 0x14` | `For Zone Select Block1: 0x7A0454` |
| Z2 | CSMPSWD2 | `ZSB base + 0x18` | `For Zone Select Block1: 0x7A0458` |
| Z2 | CSMPSWD3 | `ZSB base + 0x1C` | `For Zone Select Block1: 0x7A045C` |

## 6. ZSB field address mapping

| Zone | Field name | Address | Notes |
| --- | --- | --- | --- |
| Z1 | EXEONLYRAM | `ZSB base + 0x00` | `For Zone Select Block1: 0x7A0040` |
| Z1 | EXEONLYSECT | `ZSB base + 0x04` | `For Zone Select Block1: 0x7A0044` |
| Z1 | GRABRAM | `ZSB base + 0x08` | `For Zone Select Block1: 0x7A0048` |
| Z1 | GRABSECT | `ZSB base + 0x0C` | `For Zone Select Block1: 0x7A004C` |
| Z2 | EXEONLYRAM | `ZSB base + 0x00` | `For Zone Select Block1: 0x7A0440` |
| Z2 | EXEONLYSECT | `ZSB base + 0x04` | `For Zone Select Block1: 0x7A0444` |
| Z2 | GRABRAM | `ZSB base + 0x08` | `For Zone Select Block1: 0x7A0448` |
| Z2 | GRABSECT | `ZSB base + 0x0C` | `For Zone Select Block1: 0x7A044C` |

## 7. Final linker memory plan

| Section name | Planned linker memory region | Start address | Length | Notes |
| --- | --- | --- | --- | --- |
| `dcsm_otp_z1_linkpointer` | `B0_Z1 LINKPOINTER` | `0x7A0000` | `0x18` | `6 words` |
| `dcsm_otp_z1_gpreg` | `B0_Z1 GPREG1/2` | `0x7A0018` | `0x08` | `2 words` |
| `dcsm_otp_z1_pswdlock` | `B0_Z1 PSWDLOCK` | `0x7A0020` | `0x08` | `2 words` |
| `dcsm_otp_z1_crclock` | `B0_Z1 CRCLOCK` | `0x7A0028` | `0x08` | `2 words` |
| `dcsm_otp_z1_bootctrl` | `B0_Z1 GPREG3/BOOTCTRL` | `0x7A0038` | `0x08` | `2 words` |
| `dcsm_zsel_z1` | `B0_Z1 active ZSB` | `TBD by LINKPOINTER` | `0x20` | `One selected ZSB block` |
| `dcsm_rsvd_z1` | `Reserved / optional` | `TBD` | `TBD` | `Do not program before flow is confirmed` |
| `dcsm_otp_z2_linkpointer` | `B0_Z2 LINKPOINTER` | `0x7A0400` | `0x18` | `6 words` |
| `dcsm_otp_z2_gpreg` | `B0_Z2 GPREG1/2` | `0x7A0418` | `0x08` | `2 words` |
| `dcsm_otp_z2_pswdlock` | `B0_Z2 PSWDLOCK` | `0x7A0420` | `0x08` | `2 words` |
| `dcsm_otp_z2_crclock` | `B0_Z2 CRCLOCK` | `0x7A0428` | `0x08` | `2 words` |
| `dcsm_otp_z2_bootctrl` | `B0_Z2 GPREG3/BOOTCTRL` | `0x7A0438` | `0x08` | `2 words` |
| `dcsm_zsel_z2` | `B0_Z2 active ZSB` | `TBD by LINKPOINTER` | `0x20` | `One selected ZSB block` |
| `dcsm_rsvd_z2` | `Reserved / optional` | `TBD` | `TBD` | `Do not program before flow is confirmed` |

## 8. Open items

- Does the final linker need `b0_` prefixes in section names, or only in memory region names:
- Are Bank1 OTP blocks present anywhere else in TRM:
- What is the exact LINKPOINTER decode rule for selecting `Zone Select Block1..30`:
- Are reserved regions required in the final programming flow:
- Other notes:
