.data 
	pytanie: .asciiz "\nCo chcesz zrobic? (1. dodawanie, 2. odejmowanie, 3. mnozenie, 4. dzielenie, 5. wyjdz): "
	TwojWynik: .asciiz "Twoj wynik to: "
	PodajLiczbeJeden: .asciiz "Wpisz pierwsza liczbe: "
	PodajLiczbeDwa: .asciiz "Wpisz druga liczbe: "
	WpisalZero: .asciiz "\nNie dziel przez zero!\n"

.text
	la $ra loop
	
	loop:
		
		li $v0 4
		la $a0 pytanie	
		syscall			#zapytaj co chcesz robic
		
		li $v0 5
		syscall			#jaka operacje robimy
		
		move $s0 $v0		#wpisz do s0 co robimy
		
		beq $s0 5 Exit
		
		LiczbaPierwsza:
			
			li $v0 4
			la $a0 PodajLiczbeJeden
			syscall			#zadaj pytanie o liczbe
			
			la $ra LiczbaPierwsza
			
			li $v0 7
			syscall			#wczytaj pierwsza liczbe
			mov.d $f2 $f0		#wpisz pierwsza liczbe do f2
			
		LiczbaDruga:
			
			li $v0 4
			la $a0 PodajLiczbeDwa
			syscall			#zadaj pytanie o liczbe
			
			la $ra LiczbaDruga
			
			li $v0 7
			syscall			#wczytaj pierwsza liczbe
			mov.d $f4 $f0		#wpisz pierwsza liczbe do f4
		
		Operacje:
			beq $s0 1 Dodawanie
			beq $s0 2 Odejmowanie
			beq $s0 3 Mnozenie
			beq $s0 4 Dzielenie
			
			j loop
		
		Dodawanie:	
			add.d $f12 $f4 $f2	#stworz wynik dodawania
			
			j Wynik	
			
		
		Odejmowanie:
			sub.d $f12 $f2 $f4
			
			j Wynik
		
		Mnozenie:
			mul.d $f12 $f2 $f4
			
			j Wynik
		
		Dzielenie:
			jal SprawdzZero		#sprawdz czy dzielnik = 0
			
			div.d $f12 $f2 $f4
			
			j Wynik
		
		Wynik:
			li $v0 4
			la $a0 TwojWynik
			syscall			#wyswietl info wynik
			
			li $v0 3
			syscall			#wyswietl wynik
	
			j loop
			
		SprawdzZero:
			c.eq.d $f8 $f4
			bc1t Zero
			
			jr $ra
		
		Zero:
			li $v0 4
			la $a0 WpisalZero
			syscall			#wypisz ze dzieli przez 0
			
			j loop
		
	Exit:

.ktext 0x80000180
   	la $a0 msg  # address of string to print
   	li $v0 4  
   	syscall
   
   	jr $ra
.kdata	
	msg: .asciiz "Bledna liczba!\n"	