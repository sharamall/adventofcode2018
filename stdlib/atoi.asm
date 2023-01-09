.text
.globl atoi

# $a0 address of string
atoi:
addi $sp, $sp, -4 # save $s0 to stack
sw $s0, ($sp)
addi $sp, $sp, -4 # save $s1 to stack
sw $s1, ($sp)
addi $sp, $sp, -4 # save $s2 to stack
sw $s2, ($sp)
addi $sp, $sp, -4 # save $ra to stack
sw $ra, ($sp)

move $s0, $a0
move $s2, $zero

jal read_byte
li $s1, 1
bne $v0, 0x2D, atoi_parse # 0x2D is '-'
li $s1, -1

atoi_parse:
addi $s0, $s0, 1
move $a0, $s0
jal read_byte
beqz $v0, atoi_end
mul $s2, $s2, 10
addi $v0, $v0, -48
add $s2, $s2, $v0
j atoi_parse

atoi_end:
mul $v0, $s2, $s1

lw $ra, ($sp) 
addi $sp, $sp, 4 # load $ra from stack
lw $s2, ($sp)
addi $sp, $sp, 4 # load $s2 from stack
lw $s1, ($sp)
addi $sp, $sp, 4 # load $s1 from stack
lw $s0, ($sp)
addi $sp, $sp, 4 # load $s0 from stack
jr $ra