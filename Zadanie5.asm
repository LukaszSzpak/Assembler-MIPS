.data
	enter: .asciiz "\n"
	linia: .asciiz "\n----------\n"
	kolumna: .asciiz " | "
	pusta: .ascii " "
	podajMiejsce: .asciiz "\nPodaj pozycje ( 1 - 9 ): "
	zajete: .asciiz "\nPozycja zajeta !\n"
	kompWygral: .asciiz "\nWygral komputer!\n"
	graczWygral: .asciiz "\nWygral gracz!\n"
	remis: .asciiz "\nRemis!\n"
	iloscRund: .asciiz "\nPodaj ilosc rund (1 - 5): "
	punktyGracz: .asciiz "\nPunkty gracza: "
	punktyKomp: .asciiz "\nPunkty komputera: "
	wybierzZnak: .asciiz "\nWybierz swoj znak (x lub o): "
.text
	gra:
		li $v0 4 
		la $a0 iloscRund
		syscall				#zapytaj o ilosc rund
		
		li $v0 5
		syscall 			#wczytaj ilosc rund
		
		bgt $v0 5 gra
		blt $v0 1 gra			#bledna ilosc rund
		
		move $t9 $v0 			#zapisz ilosc rund do #t9
		
		znak:
		li $v0 4 
		la $a0 wybierzZnak
		syscall				#zapytaj o znak
		
		li $v0 12
		syscall				#wpisz znak
		
		beq $v0 120 ustawKrzyzyk
		beq $v0 111 ustawKolko
		j znak
		
		poZnaku:
		jal zerujPlansze
	
		kolejnyRuch:
			beqz $t9 wyniki		#koniec gry, printuj wyniki
			
			j wyswietlPlansze
			
			poWysw:
		
			li $v0 4 
			la $a0 podajMiejsce
			syscall			#zapytaj o pozycje
			
			li $v0 5
			syscall			#wczytaj pozycje
			
			bgt $v0 9 kolejnyRuch
			blt $v0 1 kolejnyRuch	#pozcyja poza zakresem
			
			move $s5 $s6
			jal wstawZnak
			jal sprawdzWygrana
			
			jal sprawdzCzyPlanszaPelna
			jal kompGra
			jal sprawdzWygrana
			
			j kolejnyRuch
			
		kolejnaRunda:
			sub $t9 $t9  1
			jal zerujPlansze
			j kolejnyRuch

	sprawdzWygrana:
		add $v1 $t0 $t1
		add $v1 $v1 $t2
		beq $v1 360 wygralKrzyzyk
		beq $v1 333 wygralKolko		#piozimo gorny
		
		add $v1 $t3 $t4
		add $v1 $v1 $t5
		beq $v1 360 wygralKrzyzyk
		beq $v1 333 wygralKolko		#poziomo œrodkowy
		
		add $v1 $t6 $t7
		add $v1 $v1 $t8
		beq $v1 360 wygralKrzyzyk
		beq $v1 333 wygralKolko		#poziomo dolny
		
		add $v1 $t0 $t3
		add $v1 $v1 $t6
		beq $v1 360 wygralKrzyzyk
		beq $v1 333 wygralKolko		#pionowo lewy
		
		add $v1 $t1 $t4
		add $v1 $v1 $t7
		beq $v1 360 wygralKrzyzyk
		beq $v1 333 wygralKolko		#pionowo srodkowy
		
		add $v1 $t2 $t5
		add $v1 $v1 $t8
		beq $v1 360 wygralKrzyzyk
		beq $v1 333 wygralKolko		#pionowo prawy
		
		add $v1 $t0 $t4
		add $v1 $v1 $t8
		beq $v1 360 wygralKrzyzyk
		beq $v1 333 wygralKolko		#ukoœne od lewego gornego rogu
		
		add $v1 $t2 $t4
		add $v1 $v1 $t6
		beq $v1 360 wygralKrzyzyk
		beq $v1 333 wygralKolko		#ukoœne od prawego gornego rogu
	
		jr $ra
	
	wygralKolko:
		beq $s7 120 winGracz
		j winKomp
	
	wygralKrzyzyk:
		beq $s7 120 winKomp
		j winGracz
	
	winGracz:
		li $v0 4 
		la $a0 graczWygral
		syscall	
		
		addi $s1 $s1 1			#dodaj jeden do wyniki gracza
		j kolejnaRunda
	
	winKomp:
		li $v0 4 
		la $a0 kompWygral
		syscall	
		
		addi $s2 $s2 1			#dodaj jeden do wyniku komputera		
		j kolejnaRunda
		
	ustawKolko:
		li $s7 120			#dla komputera x
		li $s6 111			#dla gracza o
		
		j poZnaku
	
	ustawKrzyzyk:
		li $s6 120			#dla gracza x
		li $s7 111			#dla komputera o
	
		j poZnaku	
		
	sprawdzCzyPlanszaPelna:
		beq $t0 32 wroc
		beq $t1 32 wroc
		beq $t2 32 wroc
		beq $t3 32 wroc
		beq $t4 32 wroc
		beq $t5 32 wroc
		beq $t6 32 wroc
		beq $t7 32 wroc
		beq $t8 32 wroc
		
		li $v0 4 
		la $a0 remis
		syscall	
		
		j kolejnaRunda
		
		wroc:
			jr $ra
		
	
	wstawZnak:
					#wstawia z $s5
					#sprawdza z pozycja $v0 
		bne $v0 1 dwa
		bne $t0 32 pozycjaZajeta
		move $t0 $s5
		
		dwa:
		bne $v0 2 trzy
		bne $t1 32 pozycjaZajeta
		move $t1 $s5
		
		trzy:
		bne $v0 3 cztery
		bne $t2 32 pozycjaZajeta
		move $t2 $s5
		
		cztery:
		bne $v0 4 piec
		bne $t3 32 pozycjaZajeta
		move $t3 $s5
		
		piec:
		bne $v0 5 szesc
		bne $t4 32 pozycjaZajeta
		move $t4 $s5
		
		szesc:
		bne $v0 6 siedem
		bne $t5 32 pozycjaZajeta
		move $t5 $s5
		
		siedem:
		bne $v0 7 osiem
		bne $t6 32 pozycjaZajeta
		move $t6 $s5
 		
		osiem:
		bne $v0 8 dziewiec
		bne $t7 32 pozycjaZajeta
		move $t7 $s5
		
		dziewiec:
		bne $v0 9 sprawdzWygrana
		bne $t8 32 pozycjaZajeta
		move $t8 $s5
		
		jr $ra
		
	pozycjaZajeta:
		beq $s5 $s6 uzytZajeta
		j kompZajeta
	
	kompZajeta:
		j kompLoop
	
	uzytZajeta:
		li $v0 4 
		la $a0 zajete
		syscall			#pozycja zajeta
		
		j poWysw
		
	kompGra:
		li $s4 1		#ustaw na pierwsza pozycje
		move $v0 $s4
		move $s5 $s7		#ustaw znak dla komputera
		
		j wstawZnak
		
		kompLoop:
			addi $s4 $s4 1
			move $v0 $s4
			j wstawZnak
		
	
	wyswietlPlansze:
		li $v0 4
		la $a0 enter
		syscall
		
		li $v0 11
		move $a0 $t0
		syscall
		jal wyswietlKolumna
		
		li $v0 11
		move $a0 $t1
		syscall
		jal wyswietlKolumna
		
		li $v0 11
		move $a0 $t2
		syscall
		
		jal wyswietlLinie
		
		li $v0 11
		move $a0 $t3
		syscall
		jal wyswietlKolumna
		
		li $v0 11
		move $a0 $t4
		syscall
		jal wyswietlKolumna
		
		li $v0 11
		move $a0 $t5
		syscall
		
		jal wyswietlLinie
		
		li $v0 11
		move $a0 $t6
		syscall
		jal wyswietlKolumna
		
		li $v0 11
		move $a0 $t7
		syscall
		jal wyswietlKolumna
		
		li $v0 11
		move $a0 $t8
		syscall	
		
		j poWysw
			
	
	wyswietlLinie:
		li $v0 4
		la $a0 linia
		syscall
		
		jr $ra
		
	wyswietlKolumna:
		li $v0 4
		la $a0 kolumna
		syscall
		
		jr $ra
		
	zerujPlansze:
		la $s0 pusta
		lb $s0 ($s0)
		
		move $t0 $s0
		move $t1 $s0
		move $t2 $s0
		move $t3 $s0
		move $t4 $s0
		move $t5 $s0
		move $t6 $s0
		move $t7 $s0
		move $t8 $s0
		
		jr $ra
		
	wyniki:
		li $v0 4 
		la $a0 punktyGracz
		syscall
		
		li $v0 1
		move $a0 $s1
		syscall				#punkty gracza
		
		li $v0 4 
		la $a0 punktyKomp
		syscall
		
		li $v0 1
		move $a0 $s2
		syscall				#punkty komputera
	
		j exit
	exit:
