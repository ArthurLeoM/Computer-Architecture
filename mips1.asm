            .data
msg_success:      .asciiz "\r\nSuccess! Location: "
msg_failure:      .asciiz "\r\nFail!\r\n"
s_end:            .asciiz "\r\n"
buf:              .space 256

            .text
            .globl main
main:       la $a0, buf # address of input buffer
            la $a1, 256 # maximum spaces that can be accomodated
            li $v0, 8 # read string
            syscall

readchar:   li $v0, 12 # read character
            syscall
            addi $t7, $0, 63 # '?' means an exit
            sub $t6, $t7, $v0
            beq $t6, $0, exit 
            add $t0, $0, $0
            la $s1, buf

loop:       lb $s0, 0($s1)
            sub $t1, $v0, $s0
            beq $t1, $0, success # Found means a success
            beq $s0, $0, fail # Checked to the end of string means a failure
            addi $t0, $t0, 1
            addi $s1, $s1, 1
            j loop

success:    la $a0, msg_success
            li $v0, 4 # print string
            syscall
            addi $a0, $t0, 1
            li $v0, 1 # print integer
            syscall
            la $a0, s_end # print end of line
            li $v0, 4
            syscall
            j readchar

fail:       la $a0, msg_failure
            li $v0, 4
            syscall
            j readchar

exit:       li $v0, 10
            syscall