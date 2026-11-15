# Ma nguon 5 – phan bac dien nang
.data
prompt: .asciiz "Nhap dien nang (kWh): "
msg:    .asciiz "Bac: "
nl:     .asciiz "\n"
 
.text
.globl main
main:
  li  $v0, 4
  la  $a0, prompt
  syscall
  li  $v0, 5            # doc kWh, ket qua o $v0
  syscall
  add $s0, $v0, $zero   # $s0 = dien nang (kWh)
  # >>> xac dinh bac (1..4) theo Bang 6, dat vao $s1
  # Ki?m tra b?c 1: kWh <= 100 (<101)
  slti $t0, $s0, 101
  bne $t0, $zero, IsBac1
  # Ki?m tra b?c 1: kWh <= 150 (<151)
  slti $t0, $s0, 151
  bne $t0, $zero, IsBac2
  # Ki?m tra b?c 1: kWh <= 200 (<201)
  slti $t0, $s0, 201
  bne $t0, $zero, IsBac3
  # B?c 4: >200
  li $s1,4
  j Print
  # >>> in “Bac: “, roi $s1, roi xuong dong
IsBac1:
  li $s1,1
  j Print

IsBac2:
  li $s1,2
  j Print
  
IsBac3:
  li $s1,3
  j Print
  
Print:
  li   $v0, 4
  la   $a0, msg
  syscall

  li   $v0, 1
  add  $a0, $s1, $zero
  syscall

  li   $v0, 4
  la   $a0, nl
  syscall
  
  li  $v0, 10
  syscall
