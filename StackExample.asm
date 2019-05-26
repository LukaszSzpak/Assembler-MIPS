.data

.text
	li $v0 5
	syscall		#wczytaj int
	sw $v0 0($sp)	#zapisz pierwsza liczbe
	
	addi $sp $sp 4	#dodaj 4 do licznika stosu
	
	li $v0 5
	syscall		#wczytaj int
	sw $v0 0($sp)	#zapisz druga liczbe		


	
	li $v0 1	
	lw $a0 0($sp)
	syscall		#wyswietl druga liczbe
	
	addi $sp $sp -4
	
	lw $a0 0($sp)
	syscall		#wyswietl pierwsza liczbe