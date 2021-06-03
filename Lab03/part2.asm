#this program gives the result of division
.data 
	dividend: .asciiz "Enter dividend: "
	divisor:  .asciiz "Enter divisor:  "
	continue: .asciiz "\nPress 1 to continue or 0 to stop execution!\n"
	quotient: .asciiz "Quotient: "
	warning: .asciiz "Divisor cannot be 0!\n"
.text
	main:
	jal getNumbers
	addi $t0, $v1, 0
	
	li $v0, 4
	la $a0, quotient
	syscall
	#show the result
	li $v0,1
	move $a0, $t0
	syscall
	
	li $v0, 4
	la $a0, continue
	syscall
	
	li $v0,5
	syscall
	move $t1, $v0
	
	beqz $t1, exit
	li $v1,0
	j getNumbers #using jump helps program to return jal getNumbers

	exit:
	li $v0, 10
	syscall
#==================================================================================================================
	getNumbers:
		addi $sp, $sp, -12
		sw $ra, 8($sp)
		sw $s1, 4($sp)
		sw $s0, 0($sp)
		
		#show text
		li $v0, 4
		la $a0, dividend
		syscall
		#enter number
		li $v0, 5
		syscall
		addi $s0, $v0, 0
		
		#show text
		li $v0, 4
		la $a0, divisor
		syscall
		#enter number
		li $v0, 5
		syscall
		addi $s1, $v0, 0
		
		addi $a0, $s0, 0#dividend
		addi $a1, $s1, 0#divisor
		
		jal recursiveSub
		
		#restore the memory
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $ra ,8($sp)
		addi $sp, $sp, 12
		jr $ra
#*****************Recursion********************************************************************************************
	recursiveSub:
		addi $sp, $sp, -12
		sw $ra, 8($sp)
		sw $s1, 4($sp)#divisor
		sw $s0, 0($sp)#quotient
	
		li $s0,0 #initialize s0
		bgt $a1, $a0, return #at the beginning of the execution divisor is greater than dividend
		addi $s1, $a1,0 #divisor
		beqz $s1, msg
		sub $a0, $a0,$s1
		addi $s0, $zero,1 #s0 = 1 
		bgt $a1, $a0, return
		jal recursiveSub
		pop:
		add $v1, $v1, $s0
		lw $s0, 0($sp)
		lw $ra, 8($sp)
		lw $s1, 4($sp)#divisor
		addi $sp, $sp, 12
		jr $ra
		
	return:
		#jr $ra originally this was here but when s0 is equal to 1, it didnot show s0 
		j pop
		
	msg: 	
		li $v0, 4
		la $a0, warning 
		syscall
		jr $ra
		
			
		
		
		
		
		
