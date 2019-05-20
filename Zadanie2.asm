.data
	TekstJawny: .space 50
	Klucz: .space 9
	
.text
	
	WczytajTekst:
		li $v0 8
		li $a1 50
		la $a0 TekstJawny 	
		syscall			#wczytaj tekst jawny
	
	WczytajKlucz:
		li $a1 9
		la $a0 Klucz
		syscall			#wczytaj klucz
		
	Ustawienie:
		li $t0 0 		#licznik petli i = 0
		la $a1 TekstJawny	#wpisz tekst jawny do a1
		la $a2 Klucz		#wpisz klucz do a2
	
	loop:
		beq $t0 50 exit 	#wyskocz jak skonczy sie string
		
		add $s0 $a1 $t0
		lb $s1 0($s0) 		#wpisz do s1 char
		
		addi $t0 $t0 1 		#i++
		
		blt $s1 65 loop
		bgt $s1 122 loop 	#pierwsze sprawdzenie czy sie miesic
		
		bge $s1 97 Upper	#je¿eli ma³a litera to zrob duza
		ble $s1 90 Akcja	#je¿eli duza to do roboty 
		
		j loop
		
	Upper:
		addi $s1 $s1 -32 	#odjecie 32 spowoduj duza literke
		j Akcja
	
	Akcja:
	
		#szyfrowanie lub deszyfrowanie	
		j UstawienieLicznikaKlucza
	
	UstawienieLicznikaKlucza:
		
		ble $t1 7 Szyfruj	#jezeli licznik sie jeszcze miesci to szyfruj
		
		li $t1 0 		#licznik klucza  = 0
		j Szyfruj
		
	Szyfruj:
		add $s0 $a2 $t1
		lb $s2 0($s0)		#wpisz do s2 znak szyfru
		
		add $s1 $s1 -65		#znaki od 0 do 25 dla jawnego
		add $s2 $s2 -65		#znaki od 0 do 25 dla klucza
		
		add $s3 $s1 $s2		#utworz znak koncowy w s3
		
		ble $s3 25 Wyswietl 	#jak sie miesci do 25 to wieswietl
		add $s3 $s3 -26		#jak nie to reszta przez 26
		
		j Wyswietl
		
	
	Wyswietl:
		add $s3 $s3 65		#stworz kod ASCII
		
		li $v0 11
		move $a0 $s3
		syscall			#wyswietlanie znaku
		
		j loop
	
	exit:	