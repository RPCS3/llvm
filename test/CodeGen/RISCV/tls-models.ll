; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -relocation-model=pic < %s \
; RUN:     | FileCheck -check-prefix=RV32-PIC %s
; RUN: llc -mtriple=riscv64 -relocation-model=pic < %s \
; RUN:     | FileCheck -check-prefix=RV64-PIC %s
; RUN: llc -mtriple=riscv32 < %s | FileCheck -check-prefix=NOPIC %s
; RUN: llc -mtriple=riscv64 < %s | FileCheck -check-prefix=NOPIC %s

; Check that TLS symbols are lowered correctly based on the specified
; model.

@unspecified = thread_local global i32 42
@ld = thread_local(localdynamic) global i32 42
@ie = thread_local(initialexec) global i32 42
@le = thread_local(localexec) global i32 42


; No model specified

define i32* @f1() nounwind {
; RV32-PIC-LABEL: f1:
; RV32-PIC:       # %bb.0: # %entry
; RV32-PIC-NEXT:    addi sp, sp, -16
; RV32-PIC-NEXT:    sw ra, 12(sp)
; RV32-PIC-NEXT:  .LBB0_1: # %entry
; RV32-PIC-NEXT:    # Label of block must be emitted
; RV32-PIC-NEXT:    auipc a0, %tls_gd_pcrel_hi(unspecified)
; RV32-PIC-NEXT:    addi a0, a0, %pcrel_lo(.LBB0_1)
; RV32-PIC-NEXT:    call __tls_get_addr@plt
; RV32-PIC-NEXT:    lw ra, 12(sp)
; RV32-PIC-NEXT:    addi sp, sp, 16
; RV32-PIC-NEXT:    ret
;
; RV64-PIC-LABEL: f1:
; RV64-PIC:       # %bb.0: # %entry
; RV64-PIC-NEXT:    addi sp, sp, -16
; RV64-PIC-NEXT:    sd ra, 8(sp)
; RV64-PIC-NEXT:  .LBB0_1: # %entry
; RV64-PIC-NEXT:    # Label of block must be emitted
; RV64-PIC-NEXT:    auipc a0, %tls_gd_pcrel_hi(unspecified)
; RV64-PIC-NEXT:    addi a0, a0, %pcrel_lo(.LBB0_1)
; RV64-PIC-NEXT:    call __tls_get_addr@plt
; RV64-PIC-NEXT:    ld ra, 8(sp)
; RV64-PIC-NEXT:    addi sp, sp, 16
; RV64-PIC-NEXT:    ret
;
; NOPIC-LABEL: f1:
; NOPIC:       # %bb.0: # %entry
; NOPIC-NEXT:    lui a0, %tprel_hi(unspecified)
; NOPIC-NEXT:    add a0, a0, tp, %tprel_add(unspecified)
; NOPIC-NEXT:    addi a0, a0, %tprel_lo(unspecified)
; NOPIC-NEXT:    ret
entry:
  ret i32* @unspecified
}


; localdynamic specified

define i32* @f2() nounwind {
; RV32-PIC-LABEL: f2:
; RV32-PIC:       # %bb.0: # %entry
; RV32-PIC-NEXT:    addi sp, sp, -16
; RV32-PIC-NEXT:    sw ra, 12(sp)
; RV32-PIC-NEXT:  .LBB1_1: # %entry
; RV32-PIC-NEXT:    # Label of block must be emitted
; RV32-PIC-NEXT:    auipc a0, %tls_gd_pcrel_hi(ld)
; RV32-PIC-NEXT:    addi a0, a0, %pcrel_lo(.LBB1_1)
; RV32-PIC-NEXT:    call __tls_get_addr@plt
; RV32-PIC-NEXT:    lw ra, 12(sp)
; RV32-PIC-NEXT:    addi sp, sp, 16
; RV32-PIC-NEXT:    ret
;
; RV64-PIC-LABEL: f2:
; RV64-PIC:       # %bb.0: # %entry
; RV64-PIC-NEXT:    addi sp, sp, -16
; RV64-PIC-NEXT:    sd ra, 8(sp)
; RV64-PIC-NEXT:  .LBB1_1: # %entry
; RV64-PIC-NEXT:    # Label of block must be emitted
; RV64-PIC-NEXT:    auipc a0, %tls_gd_pcrel_hi(ld)
; RV64-PIC-NEXT:    addi a0, a0, %pcrel_lo(.LBB1_1)
; RV64-PIC-NEXT:    call __tls_get_addr@plt
; RV64-PIC-NEXT:    ld ra, 8(sp)
; RV64-PIC-NEXT:    addi sp, sp, 16
; RV64-PIC-NEXT:    ret
;
; NOPIC-LABEL: f2:
; NOPIC:       # %bb.0: # %entry
; NOPIC-NEXT:    lui a0, %tprel_hi(ld)
; NOPIC-NEXT:    add a0, a0, tp, %tprel_add(ld)
; NOPIC-NEXT:    addi a0, a0, %tprel_lo(ld)
; NOPIC-NEXT:    ret
entry:
  ret i32* @ld
}


; initialexec specified

define i32* @f3() nounwind {
; RV32-PIC-LABEL: f3:
; RV32-PIC:       # %bb.0: # %entry
; RV32-PIC-NEXT:  .LBB2_1: # %entry
; RV32-PIC-NEXT:    # Label of block must be emitted
; RV32-PIC-NEXT:    auipc a0, %tls_ie_pcrel_hi(ie)
; RV32-PIC-NEXT:    lw a0, %pcrel_lo(.LBB2_1)(a0)
; RV32-PIC-NEXT:    add a0, a0, tp
; RV32-PIC-NEXT:    ret
;
; RV64-PIC-LABEL: f3:
; RV64-PIC:       # %bb.0: # %entry
; RV64-PIC-NEXT:  .LBB2_1: # %entry
; RV64-PIC-NEXT:    # Label of block must be emitted
; RV64-PIC-NEXT:    auipc a0, %tls_ie_pcrel_hi(ie)
; RV64-PIC-NEXT:    ld a0, %pcrel_lo(.LBB2_1)(a0)
; RV64-PIC-NEXT:    add a0, a0, tp
; RV64-PIC-NEXT:    ret
;
; NOPIC-LABEL: f3:
; NOPIC:       # %bb.0: # %entry
; NOPIC-NEXT:    lui a0, %tprel_hi(ie)
; NOPIC-NEXT:    add a0, a0, tp, %tprel_add(ie)
; NOPIC-NEXT:    addi a0, a0, %tprel_lo(ie)
; NOPIC-NEXT:    ret
entry:
  ret i32* @ie
}


; localexec specified

define i32* @f4() nounwind {
; RV32-PIC-LABEL: f4:
; RV32-PIC:       # %bb.0: # %entry
; RV32-PIC-NEXT:    lui a0, %tprel_hi(le)
; RV32-PIC-NEXT:    add a0, a0, tp, %tprel_add(le)
; RV32-PIC-NEXT:    addi a0, a0, %tprel_lo(le)
; RV32-PIC-NEXT:    ret
;
; RV64-PIC-LABEL: f4:
; RV64-PIC:       # %bb.0: # %entry
; RV64-PIC-NEXT:    lui a0, %tprel_hi(le)
; RV64-PIC-NEXT:    add a0, a0, tp, %tprel_add(le)
; RV64-PIC-NEXT:    addi a0, a0, %tprel_lo(le)
; RV64-PIC-NEXT:    ret
;
; NOPIC-LABEL: f4:
; NOPIC:       # %bb.0: # %entry
; NOPIC-NEXT:    lui a0, %tprel_hi(le)
; NOPIC-NEXT:    add a0, a0, tp, %tprel_add(le)
; NOPIC-NEXT:    addi a0, a0, %tprel_lo(le)
; NOPIC-NEXT:    ret
entry:
  ret i32* @le
}
