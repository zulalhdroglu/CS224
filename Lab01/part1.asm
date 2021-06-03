.data 
	palin: .ascii "\nIt is symmetrical"
	array: .word 1,3,5,2,1	
	disArray: .asciiz "The array is:\n"
	arraySize: .word 5
	notPal: .ascii "\nIt is not symmetrical "
	newLine: .ascii "\n"
	space: .ascii" "
.text
	addi $t0, $zero, 0 
	lw $t1, arraySize #It is checks the array from last 
    addi $t1, $t1, -1
	sll $t1, $t1, 2#It multiples the array size with 4
	addi $t3,$zero, 0
	addi $t4, $zero, 0
	
	li $v0, 4
	la $a0, disArray
	syscall
	
	#It displays the array elemnts 
	show:
		beq $t0, 20, done # we have 5 elements in the array. and each has 4 bytes, so 20 is used
		lw $t6, array($t0) #t6 stores current element
		addi $t0, $t0, 4
		#display the current element
		li $v0, 1
		move $a0, $t6
		syscall
		#space between array elements
		li $v0, 4
		la $a0, space
		syscall
		j show 

	done:
	# It updates t0 to 0
    addi $t0, $zero, 0 #index of word
    #new line
    li $v0, 4
    la $a0, newLine
	
	while:
		bge $t0, $t1,palindrome #if the index of the word bigger than the index comes from back of the array, apply palindrome
		lw $t3, array($t0)
		lw $t4, array($t1)
		addi $t0, $t0, 4
		subi $t1,$t1, 4
		bne $t3, $t4, notPalin#if they are not equal to each other, apply NotPalin
		j while
#ends the program
exit:
    li	$v0, 10
	syscall
palindrome:
	li $v0,4
	la $a0, palin#display symmetric message
	syscall
	j exit
	
notPalin:
	li $v0,4
	la $a0, notPal#displays not symmetric message
	syscall
	j exit
