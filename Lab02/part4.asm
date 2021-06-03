.data 
	pattern: .asciiz "Enter your pattern:      "
	length:  .asciiz "Length of pattern (bit): "
	searched:.asciiz "Enter searched number:   "
	newLine: .asciiz "\n"
	numOfPattern: .asciiz "Number of pattern:       "
	
.text
	main:
		li $v0, 4
		la $a0, searched
		syscall
		
		#enter searched number
		li $v0, 5
		syscall
		addi $t1, $v0,0
		
		#hexadecimal display
		li $v0, 34
		move $a0, $t1
		syscall
		#new line 
		li $v0, 4
		la $a0, newLine
		syscall
		
		li $v0, 4
		la $a0, pattern
		syscall
		
		#enter pattern 
		li $v0, 5
		syscall
		move $t0, $v0
		
		#hexadecimal display
		li $v0, 34
		move $a0, $t0
		syscall
		
		#new line 
		li $v0, 4
		la $a0, newLine
		syscall
		
		#lenght 
		li $v0, 4
		la $a0, length
		syscall
		
		#enter the length 
		li $v0, 5
		syscall
		move $t2, $v0
		
		addi $a0, $t0,0 #pattern
		addi $a1, $t1,0# searched
		addi $a2, $t2,0 #length
		
		jal patternCounter
		move $v1, $v0
		
		li $v0, 4
		la $a0, numOfPattern
		syscall
		
		li $v0, 1
		move $a0, $v1
		syscall
		
		#exit
		li $v0, 10
		syscall
#====================================================================================================================
	patternCounter:
		addi $sp,$sp, -28
		sw $s6, 24($sp)
		sw $s5, 20($sp)
		sw $s4, 16($sp)
		sw $s3, 12($sp)
		sw $s0, 8($sp)
		sw $s1, 4($sp)#contoller 
		sw $s2, 0($sp)
		
		addi $s5, $a1,0 #searched number 
		
		#li $s6, 32
		li $s2, 32#total number of bits
		sub $s6, $s2, $a2
		div $s2, $a2
		mflo $s0 #number of maximum loops 
		sllv $a0, $a0, $s6
		#add $s7, $a2, $s6
		loop:
			bge $s4, $s0, finish#checks if it reached to max number of cycle
			#addi $s5, $a1,0 #searched number 
			sllv $s5, $s5, $s6
			or $s1, $a0, $s5 #take the number
			srlv $a1, $a1, $a2
			beq $s1, $a0, increase #compare it with the pattern
			addi $s5, $a1,0
			addi $s4,$s4, 1
			#beqz $s1, return
			j loop
	        
		increase:
			bne $s1, $s5, jumpBack
			addi $s4,$s4, 1
			addi $s5, $a1,0
			addi $s3, $s3, 1 #increase the number of pattern in the searched number
			#beqz $s1, return
            j loop
            
         jumpBack:
         	addi $s5, $a1,0
         	addi $s4,$s4, 1
         	j loop
         				
		finish:
			addi $v0, $s3, 0
			lw $s2, 0($sp)
			lw $s1, 4($sp)#contoller 
			lw $s0, 8($sp)
			lw $s3, 12($sp)
			lw $s4, 16($sp)
			sw $s5, 20($sp) 
			sw $s6, 24($sp)
			addi $sp,$sp, 28
			jr $ra
		
	
		
		
