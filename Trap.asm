.data
	PodajLiczbe: .asciiz "Wpisz liczbe: "
.text
	jal loop
	
	loop:
		#add $s0 $zero $zero	#poczatek liczby
		
		li $v0 4
		la $a0 PodajLiczbe
		syscall			#zadaj pytanie o liczbe
		
		li $v0 7
		syscall			#wczytaj liczbe
	
		j loop


.ktext 0x80000180
   	la $a0 msg  # address of string to print
   	li $v0 4  
   	syscall
   
   	jr $ra
.kdata	
	msg: .asciiz "Jestes glupi\n"