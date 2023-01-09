.globl calloc

calloc:
li $t0, 4
div $a0, $t0
mfhi $t0
bnez $t0, calloc_unaligned_error
mflo $t0
bgtz $a0, calloc_args_are_valid
la $a0, invalid_heap_allocation_str
j show_error_and_quit

calloc_unaligned_error:
la $a0, heap_allocation_unaligned_str
j show_error_and_quit

calloc_args_are_valid:
li $v0, 9
syscall
bgtz $a0, calloc_allocation_success
la $a0, heap_allocation_failed_str
j show_error_and_quit
calloc_allocation_success:
move $t1, $v0
calloc_init_memory_loop:
sw $zero, ($t1)
addi $t0,$t0, -1
addi $t1,$t1, 4
beqz $t0, calloc_return
j calloc_init_memory_loop
calloc_return:
jr $ra
