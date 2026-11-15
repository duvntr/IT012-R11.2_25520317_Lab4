
.data
m1:      .asciiz "Thang "
m2:      .asciiz ": "
mt:      .asciiz "Tong: "
mm:      .asciiz "Thang cao nhat: "
lp:      .asciiz " ("
rp:      .asciiz ")"
nl:      .asciiz "\n"
bac_msg: .asciiz "Bac "
reading: .word 1000, 1095, 1205, 1345, 1510, 1715, 1955
         .word 2210, 2440, 2625, 2775, 2895, 2995
usage:   .space 48
cnt:     .word 0, 0, 0, 0     # Mang dem so thang của 4 bac (khoi tao = 0)

.text
.globl main
main:
  la   $s0, reading
  la   $s1, usage
  la   $s7, cnt         # $s7 = dia chi nen cnt
  addi $s2, $zero, 0    # i = 0
  addi $s3, $zero, 12   # n = 12

  addi $s4, $zero, 0    # Tong
  addi $s5, $zero, -1   # Max usage
  addi $s6, $zero, 0    # Max month

Loop:
  beq  $s2, $s3, PrintBacInfo

  sll  $t1, $s2, 2
  add  $t1, $t1, $s0
  lw   $t3, 0($t1)
  lw   $t4, 4($t1)
  sub  $t5, $t4, $t3     # usage[i]

  sll  $t2, $s2, 2
  add  $t2, $t2, $s1
  sw   $t5, 0($t2)

  add  $s4, $s4, $t5
  slt  $t6, $s5, $t5
  beq  $t6, $zero, SkipMax
  add  $s5, $t5, $zero
  addi $s6, $s2, 1

SkipMax:
  # Xác định bậc (0..3 tuong ung Bac 1..4)
  slti $t0, $t5, 101
  bne  $t0, $zero, B1
  slti $t0, $t5, 151
  bne  $t0, $zero, B2
  slti $t0, $t5, 201
  bne  $t0, $zero, B3
  li   $t7, 3           # Bac 4 -> cnt[3]
  j    IncCnt

B1:
  li   $t7, 0           # Bac 1 -> cnt[0]
  j    IncCnt
B2:
  li   $t7, 1           # Bac 2 -> cnt[1]
  j    IncCnt
B3:
  li   $t7, 2           # Bac 3 -> cnt[2]
  j    IncCnt

IncCnt:
  # Tang cnt[k] len 1 bang lw, addi, sw
  sll  $t8, $t7, 2
  add  $t8, $t8, $s7
  lw   $t9, 0($t8)
  addi $t9, $t9, 1
  sw   $t9, 0($t8)

  # In thông tin tháng
  li   $v0, 4
  la   $a0, m1
  syscall
  li   $v0, 1
  addi $a0, $s2, 1
  syscall
  li   $v0, 4
  la   $a0, m2
  syscall
  li   $v0, 1
  move $a0, $t5
  syscall
  li   $v0, 4
  la   $a0, nl
  syscall

  addi $s2, $s2, 1
  j    Loop

PrintBacInfo:
  # In Tong va Thang cao nhat
  li   $v0, 4
  la   $a0, mt
  syscall
  li   $v0, 1
  move $a0, $s4
  syscall
  li   $v0, 4
  la   $a0, nl
  syscall

  li   $v0, 4
  la   $a0, mm
  syscall
  li   $v0, 1
  move $a0, $s6
  syscall
  li   $v0, 4
  la   $a0, lp
  syscall
  li   $v0, 1
  move $a0, $s5
  syscall
  li   $v0, 4
  la   $a0, rp
  syscall
  li   $v0, 4
  la   $a0, nl
  syscall

  # In đếm số tháng theo bậc
  addi $s2, $zero, 0
  addi $s3, $zero, 4
PrintLoop:
  beq  $s2, $s3, ExitAll
  sll  $t1, $s2, 2
  add  $t1, $t1, $s7
  lw   $t2, 0($t1)

  li   $v0, 4
  la   $a0, bac_msg
  syscall
  li   $v0, 1
  addi $a0, $s2, 1
  syscall
  li   $v0, 4
  la   $a0, m2
  syscall
  li   $v0, 1
  move $a0, $t2
  syscall
  li   $v0, 4
  la   $a0, nl
  syscall

  addi $s2, $s2, 1
  j    PrintLoop

ExitAll:
  li   $v0, 10
  syscall