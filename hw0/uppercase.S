.section .data
input_string:   .asciz "The @quick #Brown-Fox, jumped over the91 lazy dog!"

        # tohost/fromhost are data locations used by Spike
        .align 8
tohost: .byte 0
        .align 8
fromhost: .byte 0

        
        .section .text
        .globl _start
_start:
        # Load the address of the input string into a0
        la a0, input_string
        li a5, 0

loop:
        # Your code here!
        lb a1, 0(a0)            # load bte at current addy from a0 into a1
       # beqz a1, end_program     # if byte is NULL aka reached end of string
        beq a1, a5, end_program
        jal check_char          # call check byte
        sb a1, 0(a0)            # store updated byte into og string addy
        addi a0, a0, 1          # go to next char in string
        j loop


check_char:
        # check byte and determine which ascii char it is
        # update w uppercase version 
        # return to start
        
        li a2, 32               # lowercase - uppercase ascii = 32
        li a3, 97               # 97 = smallest lowercase letter a
        li a4, 123              # 128 = smallest lowercase letter z
        blt a1, a3, ignore      # check if byte < 97, then already uppercase
        bge a1, a4, ignore      # check if byte >= 122 aka not a alphabet character
        addi a1, a1, -32        # convert lowercase to uppercase by subtracting 32
        j ret_check_char        # return to _start

ignore:
        j ret_check_char

ret_check_char:
        ret
        
end_program:
        # jump here when you're done
        j end_program
