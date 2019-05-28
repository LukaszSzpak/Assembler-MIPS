.data 
	jeden: .asciiz "Jeden"
	dwa: .asciiz "Dwa"

.text

	main:
	li $v0 4
	la $a0 jeden
	syscall
	
	jal proba
	
	la $a0 dwa
	syscall
	
	j exit
	
	proba:
	jr $ra
	
	exit:
