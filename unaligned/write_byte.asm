.data
  byte_out_of_range: .asciiz "Attemping to write value larger than a byte."

.text
.globl write_byte
	
# $a0 address
# $a1 byte
write_byte:
and $t0, $a1, 0xff
bne $t0, $a1, write_byte_out_of_range
li $t0, 4
div $a0, $t0
mfhi $t1 # $t1 remainder
sub $a0, $a0, $t1 # $t2 word aligned address
lw $t3, ($a0)
li $t4, 0xff # bit mask 
mul $t5, $t1, 8
sllv $t4, $t4, $t5 # move the bit mask into place
li $t2, 0xffffffff
xor $t4, $t4, $t2 # flip the bit mask
and $t3, $t3, $t4
sllv $a1, $a1, $t5
or $a1, $a1, $t3
sw $a1, ($a0)
jr $ra

write_byte_out_of_range:
la $a0, byte_out_of_range
j show_error_and_quit