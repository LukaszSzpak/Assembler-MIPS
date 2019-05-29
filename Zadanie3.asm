.data	
	IlePolecen: .asciiz "Podaj ile polecen chcesz wpisac:"
	Polecenie: .asciiz "Podaj polecenie: (polecenie podajemy bez przecinków!)"
	PodajRejestr: .asciiz "Podaj rejestr:"
	PodajLiczbe: .asciiz "Podaj liczbe:"
	PodajLabel: .asciiz "Podaj label:"
	Poprawnie: .asciiz "\nDodano poprawnie!\n"
	Zajeta: .asciiz "Ilosc zajetej pamieci: "
	Stos: .asciiz "\nWyswietlam stos:\n"
	Enter: .asciiz "\n"
	WpisanePolecenie: .space 5
	Rejestr1: .space 5
	Rejestr2: .space 5
	Rejestr3: .space 5
	Liczba: .space 5
	Label: .space 5
	ADD: .asciiz "ADD "
	ADDI: .asciiz "ADDI "
	JUMP: .asciiz "J "
	NOOP: .asciiz "NOOP "
	MULT: .asciiz "MULT "
	JR: .asciiz "JR "
	JAL: .asciiz "JAL "
	
.text 
	start:
		li $v0 4
		la $a0 IlePolecen
		syscall 		#zapytaj o ilosc polecen
		
		li $v0 5
		syscall 		#wpisz ile polecen
		
		blt $v0 1 start		#mniej niz 1 to wpisz ponownie
		bgt $v0 5 start		#wiecej niz 5 to wpisz ponownie
	
		move $s0 $v0		#wpisz do s0 ilosc polecen
		li $s1 0		#i = 0
		
		move $s2 $sp		#trzymamy w s2 poczatek stosu
		
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

			li $v0 4
			la $a0 Poprawnie
			syscall 		#napisz dodano
			
			j loop
		
	Add:
		la $t4 Rejestr1
		jal CheckRegister
		la $s5 Rejestr1
		
		la $t4 Rejestr2	
		jal CheckRegister
		la $s4 Rejestr2
		
		la $t4 Rejestr3
		jal CheckRegister
		la $s3 Rejestr3
		
		move $t8 $s5
		jal AddToStack			#wpisz trzeci rejestr
		
		move $t8 $s4
		jal AddToStack			#wpisz drugi rejestr
		
		move $t8 $s3
		jal AddToStack			#wpisz pierwszy rejestr
		
		la $t8 WpisanePolecenie
		jal AddToStack			#wpisz polecenie
		
		j koniecpetli
		
	Addi:
		la $t4 Rejestr1
		jal CheckRegister
		la $s3 Rejestr1
		
		la $t4 Rejestr2
		jal CheckRegister
		la $s4 Rejestr2
		
		jal CheckNumber
		la $t8 Liczba
		jal AddToStack			#wpisz liczbe na stos
		
		move $t8 $s4
		jal AddToStack			#wpisz drugi rejestr
		
		move $t8 $s3
		jal AddToStack			#wpisz pierwszy rejestr
		
		la $t8 WpisanePolecenie
		jal AddToStack			#wpisz polecenie
		
		j koniecpetli
	
	J:	
		jal CheckLabel
		la $t8 Label
		jal AddToStack			#wpisz label na stos
		
		la $t8 WpisanePolecenie
		jal AddToStack			#wpisz polecenie
		
		j koniecpetli
	
	Noop:
		la $t8 WpisanePolecenie
		jal AddToStack			#wpisz polecenie
		
		j koniecpetli
	
	Mult:
		la $s5 Rejestr1
		jal CheckRegister
		la $s5 Rejestr1
		
		la $s5 Rejestr2
		jal CheckRegister
		la $t8 Rejestr2
		jal AddToStack			#wpisz pierwszy rejestr
		
		move $t8 $s5
		jal AddToStack			#wpisz pierwszy rejestr
		
		la $t8 WpisanePolecenie
		jal AddToStack			#wpisz polecenie
		
		j koniecpetli
	Jr:
		la $s5 Rejestr1
		jal CheckRegister		#wpisz pierwszy rejest
		la $t8 Rejestr1
		jal AddToStack
		
		la $t8 WpisanePolecenie		#wpisz polecenie
		jal AddToStack
		
		j koniecpetli
	Jal:
		jal CheckLabel
		la $t8 Label
		jal AddToStack			#wpisz label na stos
		
		la $t8 WpisanePolecenie	
		jal AddToStack			#wpisz polecenie
		
		j koniecpetli
	
	CheckRegister:
		li $v0 4
		la $a0 PodajRejestr
		syscall			#zapytaj o rejestr
		
		li $v0 8
		li $a1 5
		move $a0 $t4
		syscall			#wpisz rejestr
		
		lb $t5 ($t4)
		bne $t5 36 loop		#jezelnie nie $ to wywal
		
		addi $t4 $t4 1
		lb $t5 ($t4)		#wpisz drugi znak do s5
		
		addi $t4 $t4 1
		lb $t6 ($t4)		#wpisz trzeci znak do s6
		
		bne $t6 10 dwucyfrowa	#jezeli na 3 pozycji brak pustego
		
		bgt $t5 57 loop		#jezeli wiecej od 9 to siup
		blt $t5 50 loop		#jezeli mniej niz 2 to siup
		
		jr $ra
		
		dwucyfrowa:
		
		bgt $t5 50 loop		#jezeli wiecej od 2 to siup
		blt $t5 49 loop		#jezeli mniej niz 1 to siup
		
		bgt $t6 57 loop		#jezeli wiecej od 9 to siup
		blt $t6 50 loop		#jezeli mniej niz 2 to siup
		
		jr $ra	
	
	CheckNumber:
		li $v0 4
		la $a0 PodajLiczbe
		syscall			#zapytaj o liczbe
		
		li $v0 8
		li $a1 4
		la $a0 Liczba
		syscall			#wpisz liczbe
		
		la $t6 Liczba
		
		CheckNumberLoop:
			lb $t5 ($t6)	#wpisz kolejny znak
			beq $t5 10 EndCheckNumber	#jezeli koniec liczby to ok
			
			blt $t5 48 loop			#poni¿ej zero to siup
			bgt $t5 57 loop			#powyzej dzieiwec to siup
			
			addi $t6 $t6 1			#kolejny znak
			
			j CheckNumberLoop
			
		EndCheckNumber:
			jr $ra
				
	CheckLabel:
		li $v0 4
		la $a0 PodajLabel
		syscall			#zapytaj o label
		
		li $v0 8
		li $a1 6
		la $a0 Label
		syscall			#wpisz label
		
		jr $ra
		
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
		addi $t3 $zero 4
		
		StackLoop:
			beq $t3 -1 EndStack
			
			add $t2 $t8 $t3		
			lb $t2 ($t2)	
			sb $t2 ($sp)
			
			addi $sp $sp 1
			addi $t3 $t3 -1
			
			j StackLoop
		
		EndStack:
			jr $ra
	
	Exit:
		li $v0 4
		la $a0 Zajeta
		syscall			#napis zajeta pamiec
		
		li $v0 1
		sub $a0 $sp $s2
		syscall			#napisz ile pamieci
		
		li $v0 4
		la $a0 Stos
		syscall			#napis wyswietlam stos
		
		PrintLoop:
			beq $sp $s2 ExitExit
			
			
			addi $sp $sp -1
			lb $a0 ($sp)
			
			li $v0 11
			syscall
			
			j PrintLoop
			
	ExitExit:
