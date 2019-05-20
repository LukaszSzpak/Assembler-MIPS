.data
	String: .space 50

.text
	
	li $v0 8	#wczytaj string
	la $a0 String	#gdzie ma zapisac wczytanego stringa
	li $a1 50 	#max ilosc znakow
	syscall
	
	li $t0 0 	#zeruj licznik petli
	la $a0 String 	#wczytaj String do a0
	move $a1 $a0	#przenies do a1
	loop:
		beq $t0 50 exit 	#wyskocz jak skonczy sie string
		
		add $t1 $a1 $t0 	#wpisz i-ty znak do $t1
		
		lb $t3 0($t1)
		addi $t3 $t3 2
		
		move $a0 $t3 		#przenies i-ty wyraz stringa do a0
		li $v0 11
		syscall
		addi $t0 $t0 1		#inkrementuj licznik petli
		
		j loop		
	
	exit:	
