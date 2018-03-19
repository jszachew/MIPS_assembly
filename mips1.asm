#1
.data
#Niespodziany, małe litery na duże
prompt: .asciiz "Enter string:\n"
buff: .space 100
.text
.globl main
main:
	li $v0, 4
	la $a0, prompt
	syscall
	li $v0, 8
	la $a0, buff
	li $a1, 100
	syscall
	li $t0, 'a'
	li $t1, 'z'
	li $t2, 0x20
	la $t3, buff
	lb $t4, ($t3)
	beqz $t4, end
loop:
	blt $t4,$t0,next
	bgt $t4,$t1,next
	sub $t4,$t4,$t2
	sb $t4,($t3)
next:
	addi $t3,$t3,1
	lb $t4,($t3)
	bnez $t4,loop
end:
	li $v0, 4
	la $a0, buff
	syscall
	li $v0, 10
	syscall

#2
.data
#moje, wypisywanie od tyłu, nieoceniane
prompt: .ascizz "Enter string \n"
buff: .space 100
result: .space 100
.text
.globl main
main:
	li $v0, 4
	la $a0, prompt
	syscall
	
	li $v0, 8
	la $a0, buff
	li $a1, 100
	syscall
	
	la $t0, result
	la $t1, buff
	li $t2, 0
	lb $t3, ($t1)
	lb $t4, ($t1)
	
	beqz $t4, end
find_end:
	addi $t1, $t1, 1
	addi $t2, $t2, 1
	lb $t4, ($t1)
	bnez $t4, find_end
fix:
	lb $t5, ($t1)
	subi $t1, $t1, 1
	lb $t6, ($t1)
	subi $t1,$t1, 1 
	subi $t2, $t2, 1
loop:
	lb $t4, ($t1)
	sb $t4, ($t0)
	addi $t0, $t0, 1
	subi $t1, $t1, 1
	subi $t2, $t2, 1
	bnez $t2, loop
end:
	sb $t6, ($t0)
	addi $t0, $t0, 1
	sb $t5, ($t0)
	
	li $v0, 4
	la $a0, result
	syscall
	
	li $v0, 10
	syscall


#3
.data
#moje, podział na czwórki wypisywane od tyłu,ostatnia jeśli nie pełna zostaje, ocenione na maxa
prompt: .asciiz "Enter string \n"
buff: .space 100
.text
.globl main
main:
	li $v0, 4
	la $a0, prompt
	syscall
	
	li $v0, 8
	la $a0, buff
	li $a1, 100
	syscall
	
	la $t0, buff
		
	lb $t1,($t0)
	beqz $t1, end
loop:
	addi $t0, $t0, 1
	lb $t2, ($t0)
	beqz $t2, end
	addi $t0, $t0, 1
	lb $t3, ($t0)
	beqz $t3, end
	addi $t0, $t0, 1
	lb $t4, ($t0)
	beqz $t4, end
	addi $t0, $t0, 1
	lb $t5, ($t0)
	beqz $t5, end
	
	subi $t0, $t0, 4
	sb $t4, ($t0)
	addi $t0, $t0, 1
	sb $t3, ($t0)
	addi $t0, $t0, 1
	sb $t2, ($t0)
	addi $t0, $t0, 1
	sb $t1, ($t0)
	
	addi $t0, $t0, 1
	lb $t1, ($t0)
	bnez $t1, loop
end:
	li $v0, 4
	la $a0, buff
	syscall
	
	li $v0, 10
	syscall



#4
.data
#moje, ocenione na maxa, usuwanie z pierwszego stringa, znaków podanych w drugim
prompt: .asciiz "Enter string 1\n"
prompt2: .asciiz "Enter string with forbidden characters\n"
buff: .space 100
buff2: .space 100
.text
.globl main
main:
	li $v0, 4
	la $a0, prompt
	syscall
	
	li $v0, 8
	la $a0, buff
	li $a1, 100
	syscall
	
	li $v0, 4
	la $a0, prompt2
	syscall
	
	li $v0, 8
	la $a0, buff2
	li $a1, 100
	syscall
	
	la $t0, buff
	la $t1, buff
	la $t2, buff2
	
	lb $t3, ($t1)
	beqz $t3, end
	lb $t4, ($t2)
	beqz $t4, end
	li $t5, 0xa
loop:						#poruszanie się po buff
	beq $t3, $t4, next
	sb $t3, ($t0)
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	
	lb $t3, ($t1)
	bnez $t3, loop
	beqz $t3, loop2
next:						#pomijanie elementu
	addi $t1, $t1, 1
	lb $t3, ($t1)
	bnez $t3, loop
loop2:						#porusznie się po buff2
	sb $t3, ($t0)
	addi $t2, $t2, 1
	la $t0, buff
	la $t1, buff
	lb $t3, ($t1)
	beqz $t3, end
	lb $t4, ($t2)
	bne $t4, $t5, loop
end:
	li $v0, 4
	la $a0, buff
	syscall
	
	li $v0, 10
	syscall


#5
.data
#nieocenione, usuwanie cyfr, i zamiana małych liter na duże
prompt: .asciiz "Enter string \n"
buff: .space 100
result: .space 100
.text
.globl main
main:
	li $v0, 4
	la $a0, prompt
	syscall
	
	li $v0, 8
	la $a0, buff
	li $a1, 100
	syscall
	
	li $t0, '0'
	li $t1, '9'
	li $t2, 'a'
	li $t3, 'z'
	li $t6, 0x20
	
	la $t4, buff
	la $t5, result
	
	lb $t7, ($t4)
	beqz $t7, end
loop:
	blt $t7, $t0, if_small
	bgt $t7, $t1, if_small
		
	addi $t4, $t4, 1
	lb $t7, ($t4)
	bnez $t7, loop	
if_small:
	blt $t7, $t2, next
	bgt $t7, $t3, next
	
	sub $t7, $t7, $t6
next:
	sb $t7, ($t5)
	addi $t4, $t4, 1
	addi $t5, $t5, 1
	lb $t7, ($t4)
	bnez $t7, loop
end:
	li $v0, 4
	la $a0, result
	syscall
	li $v0, 10
	syscall
