.data
	newLine : .asciiz"\n"
	decNum:     .asciiz "Decimal Number: "
	reverseNum: .asciiz "Reverse Number: "
	hexNum:     .asciiz "Hex Number:     " 
.text
	main:
		li $v0, 4
		la $a0, decNum
		syscall
		#get a number from the user
		li $v0, 5
		syscall
		move $a1, $v0 #move it to a1
		
		li $v0, 4
		la $a0, hexNum
		syscall
		#display the hex version of it 
		li $v0, 34 
		move $a0, $a1
		syscall 

		jal reverseBit
		
		move $v1, $v0
		#new line 
		li $v0, 4
		la $a0, newLine
		syscall
		#display text
		li $v0, 4
		la $a0, reverseNum
		syscall
		#display the result hex
		li $v0, 34
		move $a0, $v1
		syscall
		
		jal exit
#=============================================================================================================		
	reverseBit: #allocate the memory
		addi $sp, $sp , -20
		sw $s3, 16($sp)
		sw $s3, 12($sp)
		sw $s2, 8($sp)
		sw $s1, 4($sp)
		sw $s0, 0($sp)
		
		addi $a2, $zero, 31
		addi $s0, $a1,0
		j loop
	
    loop:
    	blt $a2, 0, finish
		andi $s1, $s0,1#store least significant bit
		srl $s0, $s0,1 #shift 1 bit to the right
		sllv $s1, $s1,$a2#shift to the left for the specific place 
		or $s2, $s2, $s1 #add with previous value of the number 
		sub $a2, $a2,1
   		j loop                                                
   		  
    finish:#allocate the memory
    	addi $v0, $s2, 0
    	lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		addi $sp, $sp , 20
    	jr $ra	  
    exit:
		li $v0, 10
		syscall
	    
	    
		
		
