	.data
text0:	.asciiz "Enter strng: \n"	# definicja stringu, kt??ry zostanie wypisany na konsoli
text1:	.asciiz "Enter characters: \n"
buf0:	.space 100
znaki: 	.space 100					# definicja bufora na wczytywany string
result:	.space 100		
	.text
	.globl main
	
main:
	la $a0, text0					# za??adowanie adresu string`a 'text0', jako argument wywo??ania systemowego kt??re wypisze string na konsoli
	li $v0, 4						# za??adowanie numeru procedury systemowej, kt??ra zostanie uruchomiona - numer 4 odpowiada procedurze piszÄ?cej na konsoli
	syscall							# przekazanie sterowania do systemu operacyjnego, system operacyjny wypisze na konsoli string kt??ry znajduje siÄ? pod adresem za??adowanym do rejestru a0
	
	la $a0, buf0					# za??adowanie adresu bufora 'buf0', jako argument wywo??ania systemowego kt??re wczyta string z konsoli
	li $a1, 100						# ile maksymalnie znak??w system operacyjny mo??e wczytaÄ? do bufora (pamiÄ?tamy, ??e string musi byÄ? zako??czony warto??ciÄ? 0)
	li $v0, 8						# za??adowanie numeru procedury systemowej - numer 8 odpowiada procedurze czytajÄ?cej z konsoli
	syscall	
	
	la $a3, result
	
	la $a0, text1					# za??adowanie adresu string`a 'text0', jako argument wywo??ania systemowego kt??re wypisze string na konsoli
	li $v0, 4						# za??adowanie numeru procedury systemowej, kt??ra zostanie uruchomiona - numer 4 odpowiada procedurze piszÄ?cej na konsoli
	syscall							# przekazanie sterowania do systemu operacyjnego, system operacyjny wypisze na konsoli string kt??ry znajduje siÄ? pod adresem za??adowanym do rejestru a0
	
	la $a0, znaki					# za??adowanie adresu bufora 'buf0', jako argument wywo??ania systemowego kt??re wczyta string z konsoli
	li $a1, 100						# ile maksymalnie znak??w system operacyjny mo??e wczytaÄ? do bufora (pamiÄ?tamy, ??e string musi byÄ? zako??czony warto??ciÄ? 0)
	li $v0, 8						# za??adowanie numeru procedury systemowej - numer 8 odpowiada procedurze czytajÄ?cej z konsoli
	syscall	
	move $a2, $a0 #a2- znaki
	li $t3, 0 #t3 ilosc znakow podanych do usuniecia
	la $a1, buf0  #a1- string wejsciowy
	
count:
	lb $t4, ($a2)
	beqz $t4, xcount 
	addi $t3, $t3, 1
	addi $a2, $a2, 1
	j count
xcount:	
	#addi $t3, $t3, -1
	sub $a2, $a2, $t3
	#move $a0, $t3
	#li $v0, 1
	#syscall
loop:
	lb $t1, ($a1)
	beqz $t1, end
loopChar:
	lb $t2, ($a2)
	beqz $t2, loopIncN
	beq $t1, $t2, loopIncY
	addi $a2, $a2, 1  
	j loopChar	
loopIncN:
	sb $t1, ($a3)
	addi $a1, $a1, 1
	addi $a3, $a3, 1
	la $a2, znaki
	j loop
loopIncY:
	addi $a1, $a1, 1
	addi $t3, $t3, -1	
	la $a2, znaki
	j loop
	
end:	
	li $t5, 0
	sb $t5, ($a3)
	la $a0, result
	li $v0, 4
	syscall
	
	li $v0, 10						# wywo??anie systemowe numer 10 powoduje zako??czenie dzia??ania programu
	syscall	