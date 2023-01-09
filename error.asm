.text
.globl show_error_and_quit
show_error_and_quit:
bgtz $a0, custom_error_message
la $a0, default_error_str
custom_error_message:
li $v0, 4
syscall
li $v0, 10
syscall