	.data
text0:	.asciiz "Enter strng: \n"	# definicja stringu, kt??ry zostanie wypisany na konsoli
buf0:	.space 100					# definicja bufora na wczytywany string
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
	
	move $a1, $a0
	
	li $t0, 0 #t0- ile znakow jest w ciagu
	la $a2, result

countLoop:
	lb $t1, ($a0)
	beqz $t1, fix
	addi $a0, $a0, 1
	addi $t0, $t0, 1
	j countLoop
fix:
	addi $t0, $t0, 0 #fixing the nauber of letters
	addi $a0, $a0, -1

mainLoop:
	
	beqz $t0, end
	lb $t1, ($a0)
	sb $t1, ($a2)
	addi $t0, $t0, -1
	addi $a0, $a0, -1
	addi $a2, $a2, 1
	j mainLoop
	
end:	
	li $t5, 0
	sb $t5, ($a2)
	la $a0, result
	li $v0, 4
	syscall
	
	li $v0, 10						# wywo??anie systemowe numer 10 powoduje zako??czenie dzia??ania programu
	syscall	