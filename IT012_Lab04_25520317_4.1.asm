# Ma nguon 1 – mang trong bo nho
.data
reading: .word 1000, 1095, 1205, 1345, 1510, 1715, 1955
         .word 2210, 2440, 2625, 2775, 2895, 2995
usage:   .space 48
 
# Ma nguon 2 – doc reading, ghi usage
.text
.globl main
main:
  la  $s0, reading      # $s0 = dia chi nen cua reading
  la  $s1, usage        # $s1 = dia chi nen cua usage
  lw  $t0, 0($s0)       # $t0 = reading[0]
  lw  $t1, 4($s0)       # $t1 = reading[1]
  sub $t2, $t1, $t0     # $t2 = dien nang thang 1
  sw  $t2, 0($s1)       # usage[0] = $t2
  # >>> dien nang thang 2 -> usage[1]
  lw $t0, 4($s0)	# $t0 = reading[1] = 1095
  lw $t1, 8($s0)	# $t1 = reading[2] = 1205
  sub $t2, $t1, $t0	# $t2 = $t1 - $t0 = 1205 - 1095 = 110
  sw $t2, 4($s1)	# usage[1] = 110
 
  # >>> dien nang thang 3 -> usage[2]
  lw $t0, 8($s0)	# $t0 = reading[2] = 1205
  lw $t1, 12($s0)	# $t1 = reading[3] = 1345
  sub $t2, $t1, $t0	# $t2 = $t1 - $t0 = 1345 - 1205 = 140
  sw $t2, 8($s1)	#usage[2] = 140
  
  li  $v0, 10
  syscall

