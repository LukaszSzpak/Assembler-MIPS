.data
	operacja: .asciiz "Wybierz operacje (1 - potega, 2 - silnia): "
	czyKolejne: .asciiz "\nCzy chcesz ponownie skorzystac z programu? (0 - nie, 1 - tak): "
	pytx: .asciiz "Podaj x: "
	pytn: .asciiz "Podaj n: "
	wynik: .asciiz "Wynik to: "
	blad: .asciiz "\nPrzekroczono zakres !\n"

.text
	begin:
    #zapytaj co robimy
    li $v0 4
    la $a0 operacja
    syscall
    #wczytaj co robimy
    li $v0 5
    syscall
    beq $v0 1 preparepower
    beq $v0 2 preparefac
    j begin
	
	preparepower:
    #zapytaj o x
    li $v0 4
    la $a0 pytx
    syscall
    #wczytaj x
    li $v0 5
    syscall
    move $t1 $v0
    #zapytaj o n
    li $v0 4
    la $a0 pytn
    syscall
    #wczytaj n
    li $v0 5
    syscall
    move $t0 $v0
    #sprawdz poprawnosc n
    bltz $t0 preparepower
    #dla n = 0
    beq $t0 0 faczero
    #przypisz x do t2
    addi $t2 $t1 0
	
	power:
    #t2 bedzie wynik, t0 aktualny n, t1 x
    beq $t0 1 print
    mul $t2 $t2 $t1
    sub $t0 $t0 1
    #sprawdz hi
    mfhi $s0
    bnez $s0 powererror
    j power
	
	powererror:
    #wyswietl error
    li $v0 4
    la $a0 blad
    syscall
    #skocz do pobrania danych
    j preparepower
	
	preparefac:
    #zapytaj o x
    li $v0 4
    la $a0 pytx
    syscall
    #wczytaj x
    li $v0 5
    syscall
    move $t0 $v0
    #skocz jezeli ujemna
    bltz $t0 preparefac
    #skocz jezeli 0
    beq $t0 0 faczero
    #ustaw 1 w wyniku
    addi $t2 $zero 1
	
	fac:
    #t2 wynik, t0 x pomnijeszany
    beq $t0 1 print
    mul $t2 $t2 $t0
    sub $t0 $t0 1
    #sprawdz czy poza zakresem
    bltz $t2 facerror
    j fac
	
	faczero:
    #dla podane argumentu 0 silni
    li $t2 1
    j print
	
	facerror:
    #wyswietl error
    li $v0 4
    la $a0 blad
    syscall
    #skocz do pobrania danych
    j preparefac
	
	print:
    #wyswietl wynik
    li $v0 1
    addi $a0 $t2 0
    syscall
	
	pytaj:
    #zapytaj czy jeszcze raz
    li $v0 4
    la $a0 czyKolejne
    syscall
    #wczytaj odpowedz
    li $v0 5
    syscall
    #sprawdz czy jeszcze raz
    beq $v0 1 begin
