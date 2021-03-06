.data 
	arraySize: .asciiz "Please enter the size of the array: "
	space: .asciiz " "  
	printMsg: .asciiz "The array: "
	symm: .asciiz "\nArray is symmetric!\n "
	notSymm: .asciiz "\nArray is not symmetric!\n"
	empty: .asciiz "\nArray is empty!"  
	newLine: .asciiz "\n"
	newLine1: .asciiz "\n"
	min: .asciiz "\nMin: "
	max: .asciiz "Max: "

.text
	main:
	
	jal getArray
	
	addi $t0, $v0 ,0# address of the array
	addi $t1, $v1,0 #size of the array
	
	addi $a0, $t0,0 #address
	addi $a1, $t1,0 #size of the array
	
	jal findMinMax
	
	move $t2, $v0#min
	move $t3, $v1 #max
	#display text
	li $v0, 4
	la $a0, min
	syscall
	#display the min value
	li $v0, 1
	move $a0, $t2
	syscall

	li $v0, 4
	la $a0,newLine
	syscall
	#display text
	li $v0, 4
	la $a0, max
	syscall
	#display the max value
	li $v0, 1
	move $a0, $t3
	syscall
	
	addi $a0, $t0,0 #address
	addi $a1, $t1,0 #size of the array
	jal checkSymmetry
	
	j exit
	
	exit:
	li $v0, 10
	syscall
#=================================================================================================================
	getArray:
		addi $sp, $sp, -28
		sw $s5 , 24($sp) #user input
		sw $s4 , 20($sp) #controller of the array
		sw $s3 , 16($sp) #copy of initial address of the array
		sw $s2 , 12($sp) #initial address of the array
		sw $s1 , 8($sp) #arraysize *4
		sw $s0 , 4($sp) #array size
		sw $ra , 0($sp)
	
		li $v0, 4
		la $a0, arraySize
		syscall
		
		li $v0,5
		syscall
		addi $s0, $v0, 0 #array size
		
		sll $s1, $s0, 2 #size bytes of the array
	
		li $v0,9 #beginning address of the allocated array is set to $v0
		addi $a0, $s1,0
		syscall
		
		addi $s2, $v0, 0 #initial adress is moved to s2
		addi $s3, $s2, 0 
		addi $s4, $zero, 0
		
		loop:
			beq $s4, $s0, done 
			li $v0,5
			syscall
			addi $s5, $v0,0
			sw $s5, 0($s3)
			addi $s3, $s3,4
			addi $s4, $s4,1
			j loop
		done: 
			addi $a0, $s2, 0 #initial address
			addi $a1, $s0,0	 #size of the array
			
			jal print
			
			lw $ra , 0($sp)
			lw $s0 , 4($sp) #array size
			lw $s1 , 8($sp) #arraysize *4
			lw $s2 , 12($sp) #initial address of the array
			lw $s3 , 16($sp) #copy of initial address of the array
			lw $s4 , 20($sp) #controller of the array
			lw $s5 , 24($sp) #user input
			addi $sp, $sp, 28
			#restore stack pointer 
			jr $ra
			
			
#******************NESTED FUNCTION******************************************************************************			
		print:
			addi $sp, $sp, -24
			sw $s5, 20($sp)
			sw $s4, 16($sp)
			sw $s3, 12($sp)
			sw $s2, 8($sp)
			sw $s1, 4($sp)
			sw $s0, 0($sp)
			
			mul $s1, $a1,4  # array size * 4
			addi $s3, $a0, 0 #adress of the array
			addi $s0, $zero, 0
			
			addi $s4, $a0, 0 #adress of the array
			addi $s5, $a1,0
			
			#display the array
			li $v0, 4
			la $a0, printMsg
			syscall
			
		while:
			beq $s0, $s1, return
			lw $s2, 0($s3)
			
			li $v0, 1
			move $a0, $s2
			syscall
			
			li $v0, 4
			la $a0, space 
			syscall
			 
			addi $s0, $s0, 4
			addi $s3, $s3, 4
			j while 
			
		return:
			addi $v0, $s4,0
			addi $v1, $s5,0
			lw $s0, 0($sp)
			lw $s1, 4($sp)
			lw $s2, 8($sp)
			lw $s3, 12($sp)
			lw $s4, 16($sp)
			lw $s5, 20($sp)
			addi $sp, $sp, 24
			
			jr $ra
			
#=====================================================================================================================			
	
		checkSymmetry:
		addi $sp, $sp, -20
		sw $s4, 16($sp)
		sw $s0, 12($sp)
		sw $s1, 8($sp)
		sw $s2, 4($sp)
		sw $s3, 0($sp)
		
		addi $s3, $a0,0 #initial adress
		addi $s1, $a1, 0 #size of the array
		subi $s1, $s1, 1 #array size -1
		sll $s1, $s1, 2 #s1 points to the end index of the array
		add $s1, $s1, $s3
	check:
		bge $s3, $s1,palindrome #if the index of the word bigger than the index comes from back of the array, apply palindrome
		lw $s2, 0($s3)
		lw $s4, 0($s1)
		addi $s3, $s3, 4
		subi $s1,$s1, 4
		bne $s2, $s4, notPalin#if they are not equal to each other, apply NotPalin
		j check
	
	palindrome:
		li $v0, 4 #v0 is 1 since it is palindrome
		la $a0, symm
		syscall
		
		li $v0,4
		la $a0, newLine
		syscall
		j pop
	notPalin:
		li $v0, 4 #v0 is 1 since it is not palindrome
		la $a0, notSymm
		syscall
		
		li $v0,4
		la $a0, newLine
		syscall
		j pop
	pop:	#allocate the memory 
		sw $s3, 0($sp)
		sw $s2, 4($sp)
		sw $s1, 8($sp)
		sw $s0, 12($sp)
		addi $sp, $sp, 16
		jr $ra
#====================================================================================================================
	findMinMax: #allocate the memory
		addi $sp, $sp, -28
		sw $s7, 24($sp)
		sw $s6, 20($sp)
		sw $s5, 16($sp)
		sw $s0, 12($sp)
		sw $s1, 8($sp)
		sw $s2, 4($sp)
		sw $s3, 0($sp)
		
		addi $s6, $a0,0
		addi $s1, $a1, 0 #size
		beqz $s1, arrayEmpty
		sll $s1, $s1, 2 #arraySize*4 It ise used to check whether current indes reached to end or not
		lw $s3, 0($s6)#min
		lw $s4, 0($s6)#max
		addi $s7, $a1,0
	search:
		#beqz $s1, noArray
		ble $s7, $zero, finish
		lw $s5, 0($s6)#loads the current element to s5
		bgt $s5, $s4, maximum#it checks whether current is bigger than the stored one
		here: ble $s5, $s3, minimum#it checks whether current is smaller than the stored one
		addi $s6,$s6,4
		subi $s7,$s7,1
		j search
	maximum:
		addi $s4, $s5, 0 #store the value to max
		addi $s6,$s6,4
		subi $s7,$s7,1
		j search
	minimum:
		addi $s3, $s5, 0 #store the value to min
		addi $s6,$s6,4
		subi $s7,$s7,1
		j search
	#noArray:
	arrayEmpty:
		addi $v0, $0,0 #min
		addi $v1, $0,0 #max
		li $v0, 4
		la $a0, empty
		syscall
	
		sw $s3, 0($sp)#allocate the memory
		sw $s2, 4($sp)
		sw $s1, 8($sp)
		sw $s0, 12($sp)
		sw $s4, 16($sp)
		sw $s6, 20($sp)
		sw $s7, 24($sp)
		addi $sp, $sp, 28
		#jr $ra
		j exit
		
	finish:
		addi $v0, $s3,0 #min
		addi $v1, $s4,0 #max
		sw $s3, 0($sp)#allocate the memory
		sw $s2, 4($sp)
		sw $s1, 8($sp)
		sw $s0, 12($sp)
		sw $s4, 16($sp)
		sw $s6, 20($sp)
		sw $s7, 24($sp)
		addi $sp, $sp, 28
		jr $ra
			
			
		
		
		
