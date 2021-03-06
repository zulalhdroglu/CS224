.data 
	space: .asciiz"  "
	iterative: .asciiz "Duplicated list( non-recursive ): \n"
	dataVal:        .asciiz "\n\nThe data value:  "
	currentAddress: .asciiz "\nCurrent address: " 
	nextAddress:    .asciiz "\nNext address:    "
.text 
	li $v0, 4
	la $a0, iterative
	syscall 
	
	li $a0, 5
	jal linkedList
	
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
	   		
	   		jal duplicateList

	   		lw	$ra, 0($sp)
			lw	$s4, 4($sp)
			lw	$s3, 8($sp)
			lw	$s2, 12($sp)
			lw	$s1, 16($sp)
			lw	$s0, 20($sp)
			addi $sp, $sp, 24
			jr	$ra
#********************************************************************************************************************
	duplicateList:
		addi $sp, $sp, -24
		sw	$s0, 20($sp)
		sw	$s1, 16($sp)
		sw	$s2, 12($sp)
		sw	$s3, 8($sp)
		sw	$s4, 4($sp)
		sw	$ra, 0($sp)
		
		addi $s0, $a0, 0 #the initial address of the linked list
		
		lw $s3, 0($s0) # address of the next node 
	    lw $s2, 4($s0) #value of current node 
		#create new node 
		li	$a0, 8
	    li	$v0, 9
	    syscall
	    
	   	addi $s1, $v0,0 #points to initial address of the list
	   	addi $s4, $v0,0 #initial address
	    
		#put linked list's first element 
	   	sw $s2, 4($s1)
	   	
	   	while:
	   		beqz $s3, finish
	   		#create new node 
	   		li	$a0, 8
	        li	$v0, 9
	        syscall
	        
	        sw $v0,0($s1)#next node address 
	        move $s1, $v0 
			move $s0, $s3 #next node 
			lw $s3, 0($s0) 
			lw $s2, 4($s0) #original valu
			sw $s2, 4($s1) #copy of the original value
			j while
	     finish:
	     	sw $zero, 0($s1)
	     	
	     	move $v0, $s4 #address of the linked list
	     	addi $a0, $v0,0 #address of the linked list is argumant of print 
	     	
	     	jal print 
	     	
	     	lw	$ra, 0($sp)
	     	lw	$s4, 4($sp)
	     	lw	$s3, 8($sp)
	     	lw	$s2, 12($sp)   
	        lw	$s1, 16($sp)
	        lw	$s0, 20($sp)
		 	addi $sp, $sp, 24
		 	jr $ra
#====================================================================================================================
	print:
		addi $sp, $sp, -16
		sw	$s0, 12($sp)
		sw	$s1, 8($sp)
		sw	$s2, 4($sp)
		sw	$ra, 0($sp)
		
		addi $s0, $a0, 0 #initial address of the list 
		
		lw $s1, 0($s0) #next node address
		lw $s2, 4($s0) #current value 
		
		loop:
			beqz $s1, return
			
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
	     	lw	$s2, 4($sp)   
	        lw	$s1, 8($sp)
	        lw	$s0, 12($sp)
		 	addi $sp, $sp, 16
		 	jr $ra
#==========================================================================================================
		
		
		
		
		
		
		
		
		
		
