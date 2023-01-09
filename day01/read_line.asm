.globl read_line

read_line: # allocates heap memory to store line
addi $sp, $sp, -4 # save $s0 to stack
sw $s0, ($sp)
addi $sp, $sp, -4 # save $s1 to stack
sw $s1, ($sp)
addi $sp, $sp, -4 # save $s2 to stack
sw $s2, ($sp)
addi $sp, $sp, -4 # save $s3 to stack
sw $s3, ($sp)
addi $sp, $sp, -4 # save $ra to stack
sw $ra, ($sp)
addi $sp, $sp, -4 # save file descriptor to stack
sw $a0, ($sp)

li $a0, 12
jal calloc

lw $s0, ($sp)
addi $sp, $sp, 4 # load file descriptor from stack

move $s1, $v0 # char* buffer;
li $s2, 0 #count

read_line_loop_begin:
move $a0, $s0 # set up syscall
addi $sp, $sp, -4 # space to read char on stack
move $a1, $sp
li $a2, 1
li $v0, 14
syscall
bgtz $v0, read_char_success
beqz $v0, read_char_error

read_char_error:
li $v0, 16
move $a0, $s0
syscall # close file
beqz $s2, read_char_eof_success
la $a0, file_read_eof_str
jal show_error_and_quit
la $a0, file_read_error_str # else < 0
jal show_error_and_quit

read_char_eof_success:
addi $sp, $sp, 4
li $v0, 0
j read_line_reset_stack

read_char_success:
lw $a1, ($sp)
addi $sp, $sp, 4
beq $a1, 10, read_line_line_feed
move $a0, $s1
jal write_byte # write $a1 to $a0
addi $s1, $s1, 1
addi $s2, $s2, 1

j read_line_loop_begin

read_line_line_feed:
move $a0, $s1
li $a1, 0 # null terminator
jal write_byte

move $v0, $s1 # buf
move $v1, $s2 #count
sub $v0, $v0, $v1 # remove count

read_line_reset_stack:
lw $ra, ($sp)
addi $sp, $sp, 4 # load $ra from stack
lw $s3, ($sp)
addi $sp, $sp, 4 # load $s3 from stack
lw $s2, ($sp)
addi $sp, $sp, 4 # load $s2 from stack
lw $s1, ($sp)
addi $sp, $sp, 4 # load $s1 from stack
lw $s0, ($sp)
addi $sp, $sp, 4 # load $s0 from stack

jr $ra