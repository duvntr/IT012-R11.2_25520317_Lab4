
.data
m1:      .asciiz "Thang "
m2:      .asciiz ": "
mt:      .asciiz "Tong: "
mm:      .asciiz "Thang cao nhat: "
lp:      .asciiz " ("
rp:      .asciiz ")"
nl:      .asciiz "\n"

#reading: .word 1000, 1095, 1205, 1345, 1510, 1715, 1955
         #.word 2210, 2440, 2625, 2775, 2895, 2995
reading: .word 1140, 1377, 1569, 1726, 1853, 1960, 2062
         .word 2179, 2326, 2498, 2710, 2957, 3219
usage:   .space 48

.text
.globl main
main:
    la   $s0, reading     # $s0 = dia chi nen reading
    la   $s1, usage       # $s1 = dia chi nen usage
    addi $s2, $zero, 0    # i = 0
    addi $s3, $zero, 12   # n = 12 thang

    addi $s4, $zero, 0    # $s4 = tong dien nang (Tong = 0)
    addi $s5, $zero, -1   # $s5 = dien nang cao nhat (khoi tao am)
    addi $s6, $zero, 0    # $s6 = thang cao nhat

Loop:
    beq  $s2, $s3, Done   # Thoat neu i == 12

    # Tinh dia chi reading[i] va doc reading[i] vao $t3
    sll  $t1, $s2, 2      # $t1 = 4 * i
    add  $t1, $t1, $s0    # $t1 = dia chi reading[i]
    lw   $t3, 0($t1)      # $t3 = reading[i]
    lw   $t4, 4($t1)      # $t4 = reading[i+1] (cach 4 byte)

    # $t5 = dien nang thang i+1
    sub  $t5, $t4, $t3

    # Tinh dia chi usage[i] va luu vao bo nho
    sll  $t2, $s2, 2      # $t2 = 4 * i
    add  $t2, $t2, $s1    # $t2 = dia chi usage[i]
    sw   $t5, 0($t2)      # usage[i] = $t5

    # Cong don tong dien nang
    add  $s4, $s4, $t5

    # Kiem tra max: neu $s5 < $t5 thi cap nhat
    slt  $t6, $s5, $t5
    beq  $t6, $zero, Skip_Max
    move $s5, $t5         # Max kWh moi
    addi $s6, $s2, 1      # Thang max = i + 1

Skip_Max:
    # In "Thang "
    li   $v0, 4
    la   $a0, m1
    syscall

    # In so thang (i + 1)
    li   $v0, 1
    addi $a0, $s2, 1
    syscall

    # In ": "
    li   $v0, 4
    la   $a0, m2
    syscall

    # In dien nang $t5
    li   $v0, 1
    move $a0, $t5
    syscall

    # In xuong dong
    li   $v0, 4
    la   $a0, nl
    syscall

    # Tang chi so vong lap
    addi $s2, $s2, 1
    j    Loop

Done:
    # In dong tong: "Tong: <tong>\n"
    li   $v0, 4
    la   $a0, mt
    syscall

    li   $v0, 1
    move $a0, $s4
    syscall

    li   $v0, 4
    la   $a0, nl
    syscall

    # In dong thang cao nhat: "Thang cao nhat: <thang> (<kwh>)\n"
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

    li   $v0, 10
    syscall
