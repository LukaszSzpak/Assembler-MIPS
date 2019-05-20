.data
	TekstJawny: .space 50
	Klucz: .space 9
	Pytanie: .asciiz "Szyfrujemy czy deszyfrujemy ? (S - szyfrowanie, D - deszyfrowanie)\n"
	JakiTekst: .asciiz "\nPodaj tekst do szyfrowania:\n"
	JakiKlucz: .asciiz "\nPodaj klucz:\n"
	Wynik: .asciiz "\nWynik dzialania:\n"
	
.text
	PytankoDoUzytkownika:
		li $v0 4
		la $a0 Pytanie
		syscall			#pytanie co robimy
		
		li $v0 12
		syscall 		#wpisanie do robimy
		move $t7 $v0 		#wpisanie znaku do t7
		
	WczytajTekst:
		li $v0 4
		la $a0 JakiTekst
		syscall			#wyswitl pytanie o tekst
		
		li $v0 8
		li $a1 50
		la $a0 TekstJawny 	
		syscall			#wczytaj tekst jawny
	
	WczytajKlucz:
		li $v0 4
		la $a0 JakiKlucz
		syscall			#wyswitl pytanie o klucz
		
		li $v0 8
		li $a1 9
		la $a0 Klucz
		syscall			#wczytaj klucz
	
	WyswietlInformacjeOWyniku:
		li $v0 4
		la $a0 Wynik
		syscall			#napis wynik
		
	Ustawienie:
		li $t0 0 		#licznik petli i = 0
		la $a1 TekstJawny	#wpisz tekst jawny do a1
		la $a2 Klucz		#wpisz klucz do a2
	
	loop:
		beq $t0 50 exit 	#wyskocz jak skonczy sie string
		
		add $s0 $a1 $t0
		lb $s1 0($s0) 		#wpisz do s1 char
		
		addi $t0 $t0 1 		#i++
		
		blt $s1 65 UwagaMozliwaLiczba
		bgt $s1 122 loop 	#pierwsze sprawdzenie czy sie miesic
		
		bge $s1 97 Upper	#je¿eli ma³a litera to zrob duza
		ble $s1 90 UstawienieLicznikaKlucza	#je¿eli duza to do roboty 
		
		j loop
		
	Upper:
		addi $s1 $s1 -32 	#odjecie 32 spowoduj duza literke
		j UstawienieLicznikaKlucza
	
	UstawienieLicznikaKlucza:
		
		bge $t1 8 Zeruj		#jezeli licznik poza to zeruj
		add $s0 $a2 $t1
		lb $s2 0($s0)			#wpisz do s2 znak szyfru
		
		addi $t1 $t1 1		#licznik klucza ++
		
		bge $s2 91 UstawienieLicznikaKlucza 	#jezeli inne niz literka to zeruj
		blt $s2 65 UstawienieLicznikaKlucza
		
		beq $t7 83 Szyfruj
		beq $t7 68 Deszyfruj
		
		j PytankoDoUzytkownika 	#bledne dzia³anie
	
	Zeruj:
		li $t1 0
		
		j UstawienieLicznikaKlucza
		
	Szyfruj:		
		add $s1 $s1 -65		#znaki od 0 do 25 dla jawnego
		add $s2 $s2 -65		#znaki od 0 do 25 dla klucza
		
		add $s3 $s1 $s2		#utworz znak koncowy w s3
		
		ble $s3 25 Wyswietl 	#jak sie miesci do 25 to wieswietl
		add $s3 $s3 -26		#jak nie to reszta przez 26
		
		j Wyswietl
	
	Deszyfruj:
		
	
	Wyswietl:
		add $s3 $s3 65		#stworz kod ASCII
		
		li $v0 11
		move $a0 $s3
		syscall			#wyswietlanie znaku
		
		j loop
	
	UwagaMozliwaLiczba:
		blt $s1 48 loop 	#nie liczba
		bgt $s1 90 loop		#nie liczba
		j WyswietlLiczbe	#wyswietlamy bo liczba
		
	WyswietlLiczbe:
		li $v0 11
		move $a0 $s1
		syscall			#wyswietlanie znaku
		
		j loop
	
	exit:	