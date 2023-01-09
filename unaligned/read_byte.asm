.text
.globl read_byte
	
# $a0 address
read_byte:
li $t0, 4
div $a0, $t0
mfhi $t1 # $t1 remainder
sub $a0, $a0, $t1 # $t2 word aligned address
lw $t3, ($a0)
li $t4, 0xff # bit mask 
mul $t5, $t1, 8
sllv $t4, $t4, $t5 # move the bit mask into place
and $t3, $t3, $t4
srlv $v0, $t3, $t5
jr $ra