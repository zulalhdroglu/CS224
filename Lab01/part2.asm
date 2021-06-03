.data
	enter: .asciiz "Enter 4 integers ( a, b, c, d): "
	newline : .asciiz "\n"
	result: .ascii "Result:  "
.text
	main:	
	#Print the text
	li $v0, 4
	la $a0, enter
	syscall
	#print new line
	li $v0, 4
	la $a0, newline
	syscall
	
	#enter  a
	li $v0, 5
	syscall
	move $s0, $v0
	
	#enter  b
	li $v0, 5
	syscall
	move $s1, $v0
	
	#enter  c
	li $v0, 5
	syscall
	move $s2 , $v0

	#enter  d
	li $v0, 5
	syscall
	move $s3 , $v0
	
	#computation
	jal compute 
	move $v1, $v0
	
	#Print string result
	li $v0, 4
	la $a0, result
	syscall
	
	#print the result
	li $v0, 1
	move $a0, $v1
	syscall
	#exit the program
	li $v0, 10
	syscall
	
	compute:
		bgt $s2,$s1, reverse
		sub $t0, $s1,$s2 # b-c
		mul $t1, $s0, $t0 # a*(b-c)
		mflo $t3 # quotient 
		div $t1, $s3 #a*(b-c) / d
		mfhi $t2 #remainder
		move $v0, $t2
		jr $ra
	reverse: # since modulo result cannot be negative, Ireversed the order of subtraction
		sub $t0, $s2, $s1#c-b
		mul $t1, $s0, $t0 # a*(c-b)
		mflo $t3 # quotient 
		div $t1, $s3 #a*(c-b) / d
		mfhi $t2 #remainder
		move $v0, $t2
		jr $ra