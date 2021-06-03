.data 
	recursive: .asciiz "\nDuplicated list (recursive):\n"
	space: .asciiz "  "
	dataVal:        .asciiz "\n\nThe data value:  "
	currentAddress: .asciiz "\nCurrent address: " 
	nextAddress:    .asciiz "\nNext address:    "
.text
	li $v0, 4
	la $a0, recursive 
	syscall
	
	li $a0, 5
	jal linkedList
	
	add $t0,$v0,$0
	add $a0,$t0,$0
	
	jal duplicateList
	   		
	addi $t1,$v0,0
	addi $t2,$v1,0
	
	add $a0,$t1,$0
	add $a1,$t2,$0
	
	jal print
	
	#exit 
	li $v0, 10
	syscall 
#=====================================================================================================================
	linkedList:
		addi $sp, $sp, -24
		sw	$s0, 20($sp)
		sw	$s1, 16($sp)
		sw	$s2, 12($sp)
		sw	$s3, 8($sp)
		sw	$s4, 4($sp)
		sw	$ra, 0($sp) 
		
		move $s0, $a0 #number of nodes 
		li $s1, 1 #node counter 
		#each node is 8 bytes
		li	$a0, 8
	    li	$v0, 9
	    syscall
	    
	    move $s2, $v0#points to head of the list
	    move $s3, $v0#points to head of the list
	    addi $s4, $zero, 1 #initial data value is 1
	    
	    sw	$s4, 4($s2)	# Store the data value.
	   addNode:
	   		beq $s1, $s0, done
	   		addi $s1, $s1,1
	   		#create new node 
		    li	$a0, 8
	        li	$v0, 9
	        syscall
	        
	        sw $v0, 0($s2)
	        move	$s2, $v0         
	        addi $s4, $s4,1 #increase the data value
	        sw $s4, 4($s2)
	        j addNode 
	   done:
	   		sw $zero, 0($s2)
	   		move $v0, $s3 #beginning
	   		move $a0, $v0 #initial address
	   		move $a1, $v0
	   		
	   		lw	$ra, 0($sp)
			lw	$s4, 4($sp)
			lw	$s3, 8($sp)
			lw	$s2, 12($sp)
			lw	$s1, 16($sp)
			lw	$s0, 20($sp)
			addi $sp, $sp, 24
			jr	$ra
#**************Recursive*********************************************************************************************
	duplicateList:
		addi $sp, $sp, -28
		sw $s5, 24($sp)
		sw	$s0, 20($sp)
		sw	$s1, 16($sp)
		sw	$s2, 12($sp)
		sw	$s3, 8($sp)
		sw	$s4, 4($sp)
		sw	$ra, 0($sp)
		#store the initial address 
		addi $s1, $a1, 0
		beq $a0, $s1, initial
		#load data
	    lw $s3, 0($a0)
	    lw $s2, 4($a0)
		#new node
		li	$a0, 8
	    li	$v0, 9
	    syscall
	    #store the next addres 
	    sw $v0, 0($v1)
	    move $v1, $v0 #next address
		#store data 
		sw $s2, 4($v1)
		#move 
		addi $a0, $s3,0
		beqz $a0, back
		jal duplicateList
		pop:
		addi $v0, $s5,0 #saves initial address
	    lw	$ra, 0($sp)
	    lw	$s4, 4($sp)
	    lw	$s3, 8($sp)
	    lw	$s2, 12($sp)   
	    lw	$s1, 16($sp)
	    lw	$s0, 20($sp)
	    lw $s5, 24($sp)
		addi $sp, $sp, 28
		jr $ra
		
		back:
	    sw $zero, 0($v1)
	    j pop
		
		initial:
		lw $s2, 4($a0)
		lw $s3, 0($a0)
		#new node 
		li	$a0, 8
	    li	$v0, 9
	    syscall
	    move $v1, $v0
	    move $s5, $v0
	    sw $s2, 4($v1)
	    addi $a0, $s3,0
	    j duplicateList
#====================================================================================================================
	print:
		addi $sp, $sp, -16
		sw	$s0, 12($sp)
		sw	$s1, 8($sp)
		sw	$s2, 4($sp)
		sw	$ra, 0($sp)
		
		addi $s0, $a0, 0 #initial address of the list 
		addi $s3, $a1,0
		
		lw $s1, 0($s0) #next node address
		lw $s2, 4($s0) #current value 
		
		loop:
			beq $s0,$s3, return
			
			li $v0, 4
			la $a0, dataVal
			syscall

			li $v0, 1
			move $a0, $s2
			syscall
			
			li $v0, 4
			la $a0, currentAddress
			syscall
			
			li $v0, 34
			move $a0, $s0
			syscall
			
			li $v0, 4
			la $a0, nextAddress
			syscall
			
			li $v0, 34
			move $a0, $s1
			syscall
			
			move $s0, $s1
			lw $s1, 0($s0) #next node address
			lw $s2, 4($s0) #current value 
			j loop
			
		return:
			li $v0, 4
			la $a0, dataVal
			syscall

			li $v0, 1
			move $a0, $s2
			syscall
			
			li $v0, 4
			la $a0, currentAddress
			syscall
			
			li $v0, 34
			move $a0, $s0
			syscall
			
			li $v0, 4
			la $a0, nextAddress
			syscall
			
			li $v0, 34
			move $a0, $s1
			syscall
			
			lw	$ra, 0($sp)
			lw	$ra, 0($sp)
	     	lw	$s2, 4($sp)   
	        lw	$s1, 8($sp)
	        lw	$s0, 12($sp)
		 	addi $sp, $sp, 16
		 	jr $ra
#==========================================================================================================
