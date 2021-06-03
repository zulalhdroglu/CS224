.data
	array: .word -10, -5, -5, -3, 2
	space:.asciiz"                  "
	memoryAdress1: .asciiz " Memory Address          Array Element"
 	memoryAdress2: .asciiz"  Position(hex)            Value (int)"
 	memoryAdress3: .asciiz "======================================"
	arraysize: .word 5
	newLine: .asciiz"\n"
	a1: .word 7
	avrg: .asciiz"Average: "
	min: .asciiz "Min: "
	max: .asciiz "Max: "
.text
	lw $t5, arraysize
	sll $t5, $t5, 2 
	
	li $v0,4
	la $a0, memoryAdress1
	syscall
	
	li $v0,4
	la $a0, newLine
	syscall
	
	li $v0,4
	la $a0, memoryAdress2
	syscall
	
	li $v0,4
	la $a0, newLine
	syscall
	
	li $v0,4
	la $a0, memoryAdress3
	syscall
	
	li $v0,4
	la $a0, newLine
	syscall
	
	addi $t0, $zero, 0
	addi $s0, $zero, 0
	la $t4, array($zero)
loop: #Shows memory adresses
	beq $t0, $t5, average
	lw $t1, array($t0)
	#print memory(hex)
	li $v0, 34
    add $a0, $t4, $t0
    syscall
    li $v0,4
	la $a0, space
	syscall
	#print the value 
	li $v0, 1
	move $a0, $t1
	syscall
    #new line
    li $v0,4
	la $a0, newLine
	syscall
	add $s0, $s0, $t1 #sum of array
	addi $t0, $t0, 4
	
	j loop
	
average:
	lw $s1, arraysize#loads arraysize to s1
	div $s0, $s1 #sum of array/ arraysize
	mflo $s3
	
	li $v0,4
	la $a0, newLine
	syscall
	
	li $v0,4
	la $a0, avrg
	syscall
	
	li $v0,1
	move $a0, $s3
	syscall
	
	addi $t0, $zero,0
	lw $t6, array($zero)#initial vlue of t6 , it will be used for max value
	lw $t7, array($zero) #initial vlue of t7, it will be used for min value
	j findMinMax
	
findMinMax:
	beq $t0, $t5, display
	lw $s4, array($t0)
	bgt $s4, $t6, maximum
	here: ble $s4, $t7, minimum
	addi $t0,$t0,4
	j findMinMax

	
maximum:
	addi $t6, $s4,0
	addi $t0,$t0,4
	j findMinMax
minimum:
	addi $t7, $s4,0
	addi $t0,$t0,4
	j findMinMax
	
display:
	li $v0,4
	la $a0, newLine
	syscall
	
	li $v0,4
	la $a0, min
	syscall
	
	li $v0,1
	move $a0, $t7 #show min of the array
	syscall
	
	li $v0,4
	la $a0, newLine
	syscall
	
	li $v0,4
	la $a0, max
	syscall
	
	li $v0,1
	move $a0, $t6 #show max of the array
	syscall
	j exit
exit:
	li $v0, 10
	syscall
	
