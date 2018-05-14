	.data
start:	
	.asciiz	"What max number you want?\n"
newNumber:
	.asciiz ", "

	.text
	
	.globl	main
main:
	li	$s0, 1		# $s0: set is prime
	li	$s1, 0		# $s1: set is NOT prime
	
	la	$a0, start	#<-
	li	$v0, 4		#  | cout<<"What max number you want?\n"
	syscall			#<- 
	
	li	$v0, 5		#<-
	syscall			#  |
	move	$t2, $v0	#<- cin>>n
	
	ble	$t2, 1, exit	#if(n<=1) retrun 1;

				# allocate heap memory
	move	$a0, $t2	#<- 
	li	$v0, 9		#  |
	syscall			#<- G = new bool[n];
	
	move	$t0, $v0	# $t0 - first allocated byte adress
	
	move	$t7, $t2	# loop from $t6 (begin of heap) to $t7 (begin of heap + n)
	addu	$t7, $t7, $t0	# end of heap
	move	$t6, $t0	#beginning of heap
	
	sb	$s1, ($t6)
	addiu	$t6, $t6, 1	#avoid getting 1 as prime number	
	
setDefault:
	addiu	$t6, $t6, 1		#<- set default that every number is prime
	sb	$s0, ($t6)		#  |
	bne	$t6, $t7, setDefault 	#<-
	
	li	$t3, 2		#start with powers of 2

#	BEGINNING OF MAIN ALGORITHM	#

	mulu	$s2, $t3, $t3		# p*p
	bgt	$s2, $t2, endOfMain	# p*p>n?
loop1:						
	move	$t4, $t3		#q=p
loop2:
	mulu	$t5, $t3, $t4		#x=q*p
loop3:
	bgt 	$t5, $t2, loop4		#if(x>n) goto: loop4
	
	addu    $s2, $t0, $t5		#move x'th number address from G to $s2 (offset)
	sb  	$s1, ($s2)		#set 0 (false) to x'th nuber in G  G[x]=false
	mulu   	$t5, $t5, $t3		#x=x*p
	ble     $t5, $t2, loop3 	#is x<=n?
	# </loop3>
loop4:
	addiu   $t4, $t4, 1		#<-
    	addu  	$s2, $t0, $t4		#  |while(G[++q]==false);
    	lb  	$s3, ($s2)		#  |
    	beq 	$s3, 0, loop4		#<-
	# </loop4>
	mulu	$s2, $t3, $t4		# 
	ble	$s2, $t2, loop2		#is p*q<=n?
	# </loop2>
loop5:
	addiu   $t3, $t3, 1		#<-
   	addu  	$s2, $t0, $t3		#  |while(G[++p]==false);	
    	lb  	$s3, ($s2)		#  |
	beq	$s3, 0, loop5		#<-
	# </loop5>
	
	mulu	$s2, $t3, $t3
	ble	$s2, $t2, loop1		#is p*p<=n?
	# </loop1>
#	END OF MAIN AGLORITHM		#

endOfMain:
	move	$t7, $t2	#<- loop from $t6 (begin of heap) to $t7 (begin of heap + n)
	addu	$t7, $t7, $t0	#  |
	move	$t6, $t0	#<-
	
printNumbers:
	addiu	$t6, $t6, 1 	#<-
	lb	$s3, ($t6)	#  | for(i = 1; i <= n; i++)
	bne	$s3, $s0, notPrime#| if(!S[i]) goto notPrime;
				#  |	
	move	$s4, $t6	#  | else
	subu	$s4, $s4, $t0	#<-  //substract beginning of heap
				  
	move	$a0, $s4  	#<- 
	li	$v0, 1		#  | cout<<i  
	syscall			#<-  
	
	li $v0, 4		#<- 
	la $a0, newNumber	#  | cout<<", "
	syscall			#<-
	
notPrime:
	bne	$t6, $t7, printNumbers # if(i!=n) goto printNumbers
	
exit:
	li	$v0, 10		# end
	syscall

	# G - $t0 -array of bytes with information of it's primest (size n)
	# n - $t2 -maxium (finding prime numbers from 2 to n)
	# p - $t3 -temp using for algorithm
	# q - $t4 - ---||---
	# x - $t5 - ---||---
	# $t6 - beginnig of iteration
	# $t7 - end of iteration ($t6 + n)
