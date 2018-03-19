	.data
text0:	.asciiz "Enter strng: \n"	# definicja stringu, kt??ry zostanie wypisany na konsoli
buf0:	.space 100					# definicja bufora na wczytywany string
	
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
loop:
	lb $t0, ($a0)
	beqz $t0, end
	addi $t0,$t0, -0x20
	sb $t0, ($a0)
	addi $a0, $a0, 1
	j  loop
	
end:
	la $a0, buf0					# podobnie jak na poczÄ?tku programu ??adujemy jako parametr wywo??ania adres bufora w kt??rym znajduje siÄ? przetwarzany string
	li $v0, 4						# numer wywo??ania 4 odpowiada procedurze wypisujÄ?cej wskazany string na konsoli
	syscall		

li $v0, 10						# wywo??anie systemowe numer 10 powoduje zako??czenie dzia??ania programu
	syscall	