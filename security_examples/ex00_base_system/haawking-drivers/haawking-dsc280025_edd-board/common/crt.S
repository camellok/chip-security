# See LICENSE for license details.

#include "encoding.h"

#define CSR_EALLOW      0x7c1

#if __riscv_xlen == 64
# define LREG ld
# define SREG sd
# define REGBYTES 8
#else
# define LREG lw
# define SREG sw
# define REGBYTES 4
#endif
  .symver _start,haawking_start@VERS_DSC280025CEDD_V1.0.10
  .section "codestart","ax",@progbits
  .globl _start 
_start:
j _ENTRY
.size  _start,   .-_start

  .section ".text.init","ax",@progbits
  .globl _ENTRY
_ENTRY:
    csrsi CSR_EALLOW, 0x01
setFlash:
	li t0, 5
    li a0, 0x7AF000
    sw t0, 0x4(a0)
    NOP
    NOP
    NOP
    NOP
    NOP
	sw x0, 0x80(a0)
	sw x0, 0x84(a0)
	sw x0, 0x88(a0)
	sw x0, 0x8C(a0)
	sw x0, 0x90(a0)
	sw x0, 0x94(a0)
	sw x0, 0x98(a0)
	sw x0, 0x9C(a0)
	sw x0, 0xA0(a0)
	sw x0, 0xA4(a0)
    csrci CSR_EALLOW, 0x01
enableNmi:
	csrsi CSR_EALLOW, 0x01
	li t0, 1
	li a0, 0x5330
	sw t0,0(a0)
	li a0, 0x5300
	sw t0,0(a0)
	NOP
enableBor:
	li t0,0x4
	li a0, 0x39008
	sw t0,0(a0)
	csrci CSR_EALLOW, 0x01
checkPartid:
	li a0, 0x7A0F38
	li a1, 0x33800+0x18	//a1=GPAPUD
	li a2, 0x33800+0x98	//a2=GPBPUD
	lw t0, 0(a0)		//read PARTIDL
	li t1, 0x700		//bit[10:8]=package
	and t0, t0, t1		//t0=packge value
	li t1, 0x100		//package=1,64PIN-QFPQ100
	beq t0, t1, config64PinGpioPullup
	li t1, 0x200		//package=2,64PIN-QFP
	beq t0, t1, config64PinGpioPullup
	li t1, 0x300		//package=3,80PIN-QFP
	beq t0, t1, config80PinGpioPullup
	li t1, 0x400		//package=4,48PIN-QFP
	beq t0, t1, config48PinGpioPullup
	li t1, 0x600		//package=6,48PIN-QFPQ100
	beq t0, t1, config48PinGpioPullup
	j clearAllReg
config80PinGpioPullup:
	csrsi CSR_EALLOW, 0x01
	li t0, 0xFFFFFFFF
	li t1, 0xFFFFFFFF
	sw t0, 0(a1)
	sw t1, 0(a2)
	csrci CSR_EALLOW, 0x01
	j clearAllReg
config64PinGpioPullup:
	csrsi CSR_EALLOW, 0x01
	li t0, 0x31FF3FFF
	li t1, 0xFFFF83FB
	sw t0, 0(a1)
	sw t1, 0(a2)
	csrci CSR_EALLOW, 0x01
	j clearAllReg
config48PinGpioPullup:
	csrsi CSR_EALLOW, 0x01
	li t0, 0x313D30FF
	li t1, 0xFFFF807B
	sw t0, 0(a1)
	sw t1, 0(a2)
	csrci CSR_EALLOW, 0x01
	j clearAllReg

clearAllReg:
  li  x1, 0
  li  x2, 0
  li  x3, 0
  li  x4, 0
  li  x5, 0
  li  x6, 0
  li  x7, 0
  li  x8, 0
  li  x9, 0
  li  x10,0
  li  x11,0
  li  x12,0
  li  x13,0
  li  x14,0
  li  x15,0
  li  x16,0
  li  x17,0
  li  x18,0
  li  x19,0
  li  x20,0
  li  x21,0
  li  x22,0
  li  x23,0
  li  x24,0
  li  x25,0
  li  x26,0
  li  x27,0
  li  x28,0
  li  x29,0
  li  x30,0
  li  x31,0

  # enable FPU and accelerator if present
  li t0, MSTATUS_FS | MSTATUS_XS
  csrs mstatus, t0

  # make sure XLEN agrees with compilation choice
  li t0, 1
  slli t0, t0, 31
#if __riscv_xlen == 64
  bgez t0, 1f
#else
  bltz t0, 1f
#endif
2:
  j 2b
1:

#ifdef __riscv_flen
  # initialize FPU if we have one
  la t0, 1f
  csrw mtvec, t0

  fssr    x0
  fmv.s.x f0, x0
  fmv.s.x f1, x0
  fmv.s.x f2, x0
  fmv.s.x f3, x0
  fmv.s.x f4, x0
  fmv.s.x f5, x0
  fmv.s.x f6, x0
  fmv.s.x f7, x0
  fmv.s.x f8, x0
  fmv.s.x f9, x0
  fmv.s.x f10,x0
  fmv.s.x f11,x0
  fmv.s.x f12,x0
  fmv.s.x f13,x0
  fmv.s.x f14,x0
  fmv.s.x f15,x0
  fmv.s.x f16,x0
  fmv.s.x f17,x0
  fmv.s.x f18,x0
  fmv.s.x f19,x0
  fmv.s.x f20,x0
  fmv.s.x f21,x0
  fmv.s.x f22,x0
  fmv.s.x f23,x0
  fmv.s.x f24,x0
  fmv.s.x f25,x0
  fmv.s.x f26,x0
  fmv.s.x f27,x0
  fmv.s.x f28,x0
  fmv.s.x f29,x0
  fmv.s.x f30,x0
  fmv.s.x f31,x0
1:
#endif

  # initialize trap vector
  la t0, trap_entry
  csrw mtvec, t0

  # initialize global pointer
.option push
.option norelax
  la gp, __global_pointer$
.option pop

  la  tp, _end + 63
  and tp, tp, -64

  # get core id
  csrr a0, mhartid
  # for now, assume only 1 core
  li a1, 1
1:bgeu a0, a1, 1b

  # give each core 128KB of stack + TLS
#define STKSHIFT 17
  sll a2, a0, STKSHIFT
  add tp, tp, a2
  #add sp, a0, 1
  #sll sp, sp, STKSHIFT
  #add sp, sp, tp
#ifdef DHRY_TEST
  lui sp,0x14
#else
#  lui sp,0x12
  la sp, __global_sp$
#endif
  addi sp,sp,-8

  jal ra,_init
  jal ra,main
  
  .align 2
trap_entry:
  j trap_entry


