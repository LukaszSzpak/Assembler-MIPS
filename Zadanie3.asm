.data	
	IlePolecen: .asciiz "Podaj ile polecen chcesz wpisac:\n "
	Polecenie: .asciiz "\nPodaj polecenie:\n "
	WpisanePolecenie: .space 10
	Space: .asciiz " "
	ADD: .asciiz "ADD "
	ADDI: .asciiz "ADDI "
	JUMP: .asciiz "J "
	NOOP: .asciiz "NOOP "
	MULT: .asciiz "MULT "
	JR: .asciiz "JR "
	JAL: .asciiz "JAL "
	
.text 
	start:
		li $v0 5
		syscall 		#wpisz ile polecen
	
		move $s0 $v0		#wpisz do s0 ilosc polecen
		li $s1 0		#i = 0
		
		la $t9 Space		#wczytaj spacje do t9
		lb $t9 ($t9)		#wczytaj kod ascii do t9
	
	loop:
		bge $s1 $s0 Exit
		
		li $v0 4
		la $a0 Polecenie
		syscall 		#zapytaj o polecenie
		
		li $v0 8
		li $a1 10
		la $a0 WpisanePolecenie
		syscall			#wpisz polecenie
		
		la $t0 WpisanePolecenie	#wpisz to polecenie do t0
		
		#sprawdzamy add
		la $t1 ADD
		jal CheckString
		beq $t9 1 Add
		
		#sprawdzamy addi
		la $t1 ADDI
		jal CheckString
		beq $t9 1 Addi
		
		#sprawdzamy jump
		la $t1 JUMP
		jal CheckString
		beq $t9 1 J
		
		#sprawdzamy noop
		la $t1 NOOP
		jal CheckString
		beq $t9 1 Noop
		
		#sprawdzamy mult
		la $t1 MULT
		jal CheckString
		beq $t9 1 Mult
		
		#sprawdzamy jr
		la $t1 JR
		jal CheckString
		beq $t9 1 Jr
		
		#sprawdzamy jal
		la $t1 JAL
		jal CheckString
		beq $t9 1 Jal
		
		bne $t9 1 loop		#jak nic nie pasuje
		
		koniecpetli:
			addi $s1 $s1 1
			j loop
		
	Add:
		j Exit
	Addi:
	
	J:
	
	Noop:
	
	Mult:
	
	Jr:
	
	Jal:
	
	CheckString:
		
		lb $t2 ($t0)		#wczytaj kolejny znak polecenie	
		lb $t3 ($t1)		#wczytaj kolejny znak wzorca
		
		beq $t2 10 JumpRaTrue#jezeli koniec polecenia to ok
		
		bne $t2 $t3 JumpRaFalse	#jezeli rozne to nie
		
		addi $t0 $t0 1
		addi $t1 $t1 1
		
		j CheckString
		
	JumpRaTrue:
		bne $t3 32 JumpRaFalse	#polecenie sie skonczylo lecz we wzorcu cos jeszcze bylo i to nie jest spacja
		addi $t9 $zero 1	#jezeli prawda to t9 = 1
		jr $ra
		
	JumpRaFalse:
		addi $t9 $zero 0	#jezeli falsz to t9 = 0
		la $t0 WpisanePolecenie	#wpisz na nowo polecenie do kolejnego sprawdzenia
		jr $ra
	
	AddToStack:
		#dodaje rejestr t8 do stosu
	
	Exit:
