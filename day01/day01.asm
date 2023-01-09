.data 
in_file: .asciiz "day01/day01in.txt"  # needs to be relative to the Mars jar, not this source file
.include "read_line.data.asm"
.include "../stdlib.data.asm"
.include "../utils.data.asm"

.text 
.globl day01 

b day01

.include "../error.asm"
.include "../stdlib.asm"
.include "../unaligned.asm"
.include "read_line.asm"

day01:
la $a0, in_file 
la $a1, 0
li $v0, 13 
syscall 
bltz $v0, show_error_and_quit
move $s0, $v0
li $a0, 8
jal calloc # alloc linked list HEAD
move $s1, $v0 
move $s2, $s1 # s2 is current pointer, s1 is root
sw $zero, ($s1) # init linked list of numbers HEAD as NULL
sw $zero, 4($s1) # init linked list of numbers HEAD as NULL

read_lines:
move $a0, $s0
jal read_line

beqz $v0, part1
move $a0, $v0
jal atoi
move $s3, $v0 # store the read int
li $a0, 8
jal calloc # alloc linked list item
sw $v0, 4($s2) # set last pointer to newly allocated memory
move $s2, $v0 # set current to new pointer
sw $s3, 0($s2) # save read int to last pair
sw $zero, 4($s2) # set next pointer to null
j read_lines

part1:
move $s2, $s1
move $s3, $zero
part1_loop:
lw $t0, 0($s2)
add $s3, $s3, $t0
lw $s2, 4($s2)
bnez $s2, part1_loop

move $a0, $s3
li $v0, 1
syscall

la $a0, part1_pretty
li $v0, 4
syscall

la $a0, newline
li $v0, 4
syscall

part2:
move $s2, $s1
lw $s2, 4($s2) # skip head of list (it's 0)
move $s3, $zero
move $s4, $zero # accumulator 
# allocate a new list forfinding matches
li $a0, 8
jal calloc # alloc linked list item
move $s3, $v0
sw $zero, 0($s3)
sw $zero, 4($s3) 
move $t7, $zero

part2_loop:
lw $t0, 0($s2)
move $s7, $t0 # save current value
add $s4, $s4, $t0 # add to accumulator
move $t0, $s3 # set up checking for contains

part2_contains: 
lw $t1, 0($t0)
beq $s4, $t1, part2_contain_true # found in list
lw $t2, 4($t0) # load next pointer
beqz $t2, part2_end_of_list
move $t0, $t2
j part2_contains

part2_contain_true:
move $s3, $s4
j part2_end
part2_end_of_list:
move $s6, $t0 # save last pair
li $a0, 8
jal calloc
sw $v0, 4($s6) # set next pointer to newly allocated memory
sw $s4, 0($v0) # set car to read value
sw $zero, 4($v0) # reset new pair cdr
lw $s2, 4($s2)
bnez $s2, part2_loop
lw $s2, 4($s1) # reached end of input, loop back to beginning of list
j part2_loop

part2_end:

move $a0, $s3
li $v0, 1
syscall

la $a0, part2_pretty
li $v0, 4
syscall

la $a0, newline
li $v0, 4
syscall

la $a0, success
jal show_error_and_quit
