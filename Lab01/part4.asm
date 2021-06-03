#part 4, calculation of A= (B * C + D / B - C ) % B

.data 
	equation: .asciiz " A = (B * C) / D + (D - C) % B \n"
	enter: .asciiz"Enter 3 integers (B, C, D):\n"
	result: .asciiz "A = "
	
.text
	#display equation
	li $v0, 4
	la $a0, equation
	syscall

	#display the text
	li $v0, 4
	la $a0, enter
	syscall
	
    #enter B
    li $v0, 5
    syscall
    add $s0, $v0, $zero
    
    #enter C
    li $v0, 5
    syscall
    add $s1, $v0, $zero
    
    #enter D
    li $v0, 5
    syscall
    add $s2, $v0, $zero
    
    #computation
	jal compute 
	
	#Print string result
	li $v0, 4
	la $a0, result
	syscall
	
	#print the result
	li $v0, 1
	move $a0, $t4
	syscall
	#exit the program
	li $v0, 10
	syscall
	
	compute:
		mult $s0, $s1 # B*C
		mflo $t1
		div $t1, $s2# (B*C)/D
		mflo $t2
		#bgt $s1, $s2, reverse
		sub $t3, $s2, $s1 #D-C
		div $t3, $s0 #(D-C) % B
		mfhi $t5
		add $t4, $t5, $t2 # (B*C)/D + (D-C)
		jr $ra
	
	
