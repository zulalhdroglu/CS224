 .data 
 # display array, show min and max values and whether symmetric or not
	array: .word 3,2,4,6
	notSymm: .asciiz "Array is not symmetric!\n" 
	arraySize: .word 4
	contents: .asciiz"Array: "
	newLine: .asciiz "\n"
	space: .asciiz " "
	empty: .asciiz "It is an empty array! \n"
	symm: .asciiz "Array is symmetric!\n "
	min: .asciiz "\nMin: "
	max: .asciiz "Max: "
	noArr: .asciiz "No Array to display! \n"
	
.text 
	li $v0, 4
	la $a0, contents
	syscall
	
	la $a0, array
	lw $a1, arraySize
	#diplayArray
	jal display
	#add new line
	li $v0, 4
	la $a0,newLine
	syscall 
	#check symmetry
	jal checkSymmetry
	move $t0, $v0
	#if the output of the symmetry is 1, It is symmetric Or  it is not 
	beq $t0, $zero, msgNo
	bgt $t0, $zero, msg
	msgNo:
		li $v0, 4
		la $a0, notSymm					# add space after
		syscall
	#jump find min max
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
	
	li $v0, 10
	syscall
	
	
	msg:#same processes afte msgNo repeated for msg
		li $v0, 4
		la $a0, symm		
		syscall
	
	jal findMinMax
	move $t2, $v0#min
	move $t3, $v1 #max
	
	li $v0, 4
	la $a0, min
	syscall
	
	li $v0, 1
	move $a0, $t2
	syscall
	
	li $v0, 4
	la $a0,newLine
	syscall
	
	li $v0, 4
	la $a0, max
	syscall
	
	li $v0, 1
	move $a0, $t3
	syscall
	#exit
	li $v0, 10
	syscall
#===============================================================================================================
	
	display:#allocate the memory
		addi $sp, $sp, -12
		sw $s0, 8($sp)
		sw $s1, 4($sp)
		sw $s2, 0($sp)
		
		addi $s2, $a1, 0
		mul $s2, $s2, 4
		
	loop:
		beq $s0, $s2, done # we have used arraySize *4 for s2 since eah word has 4 bytes
		lw $s1, array($s0) #s1 stores current element
		addi $s0, $s0, 4
		#display the current element
		li $v0, 1
		move $a0, $s1
		syscall
		#space between array elements
		li $v0, 4
		la $a0, space
		syscall
		j loop
	done: #allocate the memory
		lw $s2, 0($sp)
		lw $s1, 4($sp)
		lw $s0, 8($sp)
		addi $sp, $sp, 12
		jr $ra
	
#=======================================================================================================================
	checkSymmetry: #allocate the memory
		addi $sp, $sp, -16
		sw $s0, 12($sp)
		sw $s1, 8($sp)
		sw $s2, 4($sp)
		sw $s3, 0($sp)
		
		subi $s1, $a1, 1
		sll $s1, $s1, 2 #s1 points to the end index of the array
	while:
		bge $s0, $s1,palindrome #if the index of the word bigger than the index comes from back of the array, apply palindrome
		lw $s2, array($s0)
		lw $s3, array($s1)
		addi $s0, $s0, 4
		subi $s1,$s1, 4
		bne $s2, $s3, notPalin#if they are not equal to each other, apply NotPalin
		j while
	
	palindrome:
		addi $v0, $zero,1 #v0 is 1 since it is palindrome
		j pop
	notPalin:
		addi $v0, $zero,0 #v0 is 0 since it is not palindrome
		j pop
	pop:	#allocate the memory 
		sw $s3, 0($sp)
		sw $s2, 4($sp)
		sw $s1, 8($sp)
		sw $s0, 12($sp)
		addi $sp, $sp, 16
		jr $ra
#=================================================================================================================	
	findMinMax: #allocate the memory
		addi $sp, $sp, 20
		sw $s5, 16($sp)
		sw $s0, 12($sp)
		sw $s1, 8($sp)
		sw $s2, 4($sp)
		sw $s3, 0($sp)
		
		addi $s1, $a1, 0
		sll $s1, $s1, 2 #arraySize*4 It ise used to check whether current indes reached to end or not
		lw $s3, array($zero)#min
		lw $s4, array($zero)#max
		addi $s7, $a1,-1
	search:
		#beqz $s1, noArray
		beq $s7, $0, return
		lw $s5, array($s0)#loads the current element to s5
		bgt $s5, $s4, maximum#it checks whether current is bigger than the stored one
		here: ble $s5, $s3, minimum#it checks whether current is smaller than the stored one
		addi $s0,$s0,4
		subi $s7, $s7, 1
		j search
	maximum:
		addi $s4, $s5, 0 #store the value to max
		addi $s0,$s0,4
		subi $s7, $s7, 1
		j search
	minimum:
		addi $s3, $s5, 0 #store the value to min
		addi $s0,$s0,4
		subi $s7, $s7, 1
		j search
	#noArray:
		
	return:
		addi $v0, $s3,0 #min
		addi $v1, $s4,0 #max
		sw $s3, 0($sp)#allocate the memory
		sw $s2, 4($sp)
		sw $s1, 8($sp)
		sw $s0, 12($sp)
		sw $s4, 16($sp)
		addi $sp, $sp, 20
		jr $ra
#==========================================================================================================
	
	
	
	
	
	
	
	
	
	
	
	
	
