            .data
upperw:     .asciiz            
            "Alpha ","Bravo ","China ","Delta ","Echo ","Foxtrot ",            
            "Golf ","Hotel ","India ","Juliet ","Kilo ","Lima ",            
            "Mary ","November ","Oscar ","Paper ","Quebec ","Research ",           
            "Sierra ","Tango ","Uniform ","Victor ","Whisky ","X-ray ",          
            "Yankee ","Zulu "
upper_off:  .word            
	     0,7,14,21,28,34,43,49,56,63,71, 
	     77,83,89,99,106,113,121,131,            
	     139,146,155,163,171,178,186
lowerw:     .asciiz            
	     "alpha ","bravo ","china ","delta ","echo ","foxtrot ",           
	     "golf ","hotel ","india ","juliet ","kilo ","lima ",            
	     "mary ","november ","oscar ","paper ","quebec ","research ",            
	     "sierra ","tango ","uniform ","victor ","whisky ","x-ray ",            
	     "yankee ","zulu "
lower_off:  .word            
            0,7,14,21,28,34,43,49,56,63,71,            
            77,83,89,99,106,113,121,131,         
            139,146,155,163,171,178,186
numbers:     .asciiz            
            "zero ", "First ", "Second ", "Third ", "Fourth ",            
            "Fifth ", "Sixth ", "Seventh ","Eighth ","Ninth "
numbers_off:   .word            
	     0,6,13,21,28,36,43,50,59,67
	     
	    .text
	    .globl main
main:       li $v0, 12 # read character
            syscall
            sub $t1, $v0, 63 # '?' means an exit
            beqz $t1, exit
            sub $t1, $v0, 48 # '0'
            slt $s0, $t1, $0 # t1 < 0 set  s0 = 1
            bnez $s0, others

            # is numbers?
            sub $t2, $t1, 10 # numbers
            slt $s1, $t2, $0 # t2 < 0 set s1 = 1
            bnez $s1, Number

            # is capital?
            sub $t2, $v0, 91
            slt $s3, $t2, $0 # v0 <= 'Z' set s3 = 1
            sub $t3, $v0, 64 
            sgt $s4, $t3, $0 # v0 >='A' set s4 = 1
            and $s0, $s3, $s4 # s3 == 1 && s4 == 1 
            bnez $s0, Capital

            # is lower?
            sub $t2, $v0, 123
            slt $s3, $t2, $0 # v0 <= 'z' set s3 = 1
            sub $t3, $v0, 96 
            sgt $s4, $t3, $0 # v0 >= 'a' set s4 = 1
            and $s0, $s3, $s4
            bnez $s0, Lower
            
            j others

Number:     add $t2, $t2, 10
            sll $t2, $t2, 2
            la $s0, numbers_off
            add $s0, $s0, $t2
            lw $s1, ($s0)
            la $a0, numbers
            add $a0, $a0, $s1
            li $v0, 4
            syscall
            j main

            # upper case word
Capital:    sub $t3, $t3, 1
            sll $t3, $t3, 2
            la $s0, upper_off
            add $s0, $s0, $t3
            lw $s1, ($s0)
            la $a0, upperw
            add $a0, $s1, $a0
            li $v0, 4
            syscall
            j main

            # lower case word
Lower:      sub $t3, $t3, 1
            sll $t3, $t3, 2
            la $s0, lower_off
            add $s0, $s0, $t3
            lw $s1, ($s0)
            la $a0, lowerw
            add $a0, $s1, $a0
            li $v0, 4
            syscall
            j main

others:     and $a0, $0, $0
            add $a0, $a0, 42 # '*'
            li $v0, 11 # print character
            syscall
            j main

exit:       li $v0, 10 # exit
            syscall