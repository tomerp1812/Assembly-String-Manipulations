#209549542 Tomer Peisikov
#Exersice 3
#Compile with: gcc main.s

.section	   .rodata	   #read only data section
      
format_printf_pstrings_length:   .string "first pstring length: %d, second pstring length: %d\n"
format_printf_length_string:     .string "length: %d, string: %s\n"
format_printf_compare_result:    .string "compare result: %d\n"
format_printf_old_char_new_char: .string "old char: %c, new char: %c, first string: %s, second string: %s\n"
format_printf_invalid:           .string "invalid option!\n"
format_scanf_char:	        .string " %c"
format_scanf_int:                .string "%d"

      .align 8              #aligning to multiplies of 8
.L10:
      .quad .CASE_31
      .quad .CASE_32_33
      .quad .CASE_32_33
      .quad .DEFAULT
      .quad .CASE_35
      .quad .CASE_36
      .quad .CASE_37
.text                       #the beginnig of the code
.globl run_func
.type run_func, @function
#function that gets 3 arguments
#rdi = option, rsi = pstring1, rdx = pstring2
#and with switch case goes to user's option and 
#runs the function it asked to do.
run_func:
    pushq   %rbp            #saving the old frame pointer.
    movq    %rsp, %rbp      #creating the new frame pointer.
    
    # Set up the jump table access
    movq    %rdi, %rcx      # Compute xi = x-31
    subq    $31, %rcx
    cmpq    $6,%rcx         # Compare xi:6
    ja      .DEFAULT        # if >, goto default-case
    jmp     *.L10(,%rcx,8)  # Goto jt[xi]
    
    movq    %rbp, %rsp      #restoring the old stack pointer.
    popq    %rbp            #restoring the old frame pointer.
    ret                     #returning to the function that called us.
    
.CASE_31:                   #case user pressed 31 (pstrlen).
    
    pushq   %r12            #save callee register
    movq    %rdx, %r12      #r12 points to pstr2
    pushq   %r13            #save callee register
    movq    %rsi, %r13      #r13 points to pstr1
    pushq   %r14            #save callee register
    pushq   %r15            #save callee register
    movq    %rsi, %rdi      #rdi <- pstring1
    call    pstrlen         #calling pstrlen with 1 argument
    movq    %rax, %r14      #saving the return argument from pstrlen
    movq    %r13, %rsi      #restore pointer to pstr1
    movq    %r12, %rdx      #restore pointer to pstr2
    movq    %rdx, %rdi      #rdi <- pstring2
    call    pstrlen         #calling pstrlen with 1 arguemnt
    movq    %rax, %r15      #saving the return argument from pstrlen  
    movq    %r13, %rsi      #restore pointer to pstr1
    movq    %r12, %rdx      #restore pointer to pstr2
    xorq    %rax, %rax      #rax = 0
    movq    $format_printf_pstrings_length, %rdi
    movq    %r14, %rsi      #1st arguemnt to printf
    movq    %r15, %rdx      #2nd argument to printf
    call    printf
    
    popq    %r15            #restore r15,14,13,12
    popq    %r14                
    popq    %r13
    popq    %r12
    movq    %rbp, %rsp      #restoring the old stack pointer.
    popq    %rbp            #restoring the old frame pointer.
    ret

.CASE_32_33:                #case user pressed 32 or 33 (replaceChar).
    
    pushq   %r12            #save callee register
    movq    %rsi, %r12      #r12 points to pstr1
    pushq   %r13
    movq    %rdx, %r13      #r13 points to pstr2
    pushq   %r14
    pushq   %r15
    
    subq    $16, %rsp       #making place for 2 characters.
    movq    $format_scanf_char, %rdi    
    leaq    -48(%rbp), %rsi #move rsi pointer to the stack pointer position.
    xorq    %rax, %rax      #rax = 0
    call    scanf
    movb    (%rsp), %r14b   #old character -> %r14b
    andq    $255, %r14      #zeroies all garbage data (above first 8 bits)
    leaq    -48(%rbp), %rsi             #move rsi pointer to the stack pointer position.
    movq    $format_scanf_char, %rdi    #format of %c.
    xorq    %rax, %rax      #rax = 0
    call    scanf
    movb    (%rsp), %r15b   #new character -> %r15b
    andq    $255, %r15      #zeroies all garbage data (above first 8 bits)
    addq    $16, %rsp       #decrease the stuck pointer.
    movq    %r12, %rdi      #pstring1
    movq    %r14, %rsi      #old character
    movq    %r15, %rdx      #new character
    call    replaceChar
    movq    %r13, %rdi      #pstring2
    movq    %r14, %rsi      #old character
    movq    %r15, %rdx      #new character
    call    replaceChar
    
    movq    %r12, %rcx      #rcx <- pstr1
    incq    %rcx            #rcx <- pstr1.str
    movq    %r13, %r8
    incq    %r8             #pstr2.str
    movq    $format_printf_old_char_new_char, %rdi
    movq    %r14, %rsi      #old char
    movq    %r15, %rdx      #new char
    call    printf

    popq    %r15            #restore r15,14,13,12
    popq    %r14
    popq    %r13
    popq    %r12
      
    popq    %rbp            #restoring the old frame pointer.
    xorq    %rax, %rax
    ret                     #returning to the function that called us.

.CASE_35:                   #case user pressed 35 (pstrijcpy).

    pushq   %rbx            #save callee
    pushq   %r13
    movq    %rdx, %r13      #save pointer to str2
    pushq   %r12
    movq    %rsi, %r12      #save pointer to str1
    subq    $8, %rsp        #making place for 2 ints.
    movq    $format_scanf_int, %rdi    #format of %d.
    leaq    -32(%rbp), %rsi            #move rsi pointer to the stack pointer position.
    xorq    %rax, %rax      #rax = 0
    call    scanf
    
    movq    (%rsp), %rbx    #scanf -> rbx
    
    movq    $format_scanf_int, %rdi    #format of %d.
    leaq    -32(%rbp), %rsi            #move rsi pointer to the stack pointer position.
    xorq    %rax, %rax      #rax = 0
    call    scanf
    
    movq    (%rsp), %r9
    movq    %r12,%rdi       #rdi = str1     
    movq    %r13,%rsi       #rsi = str2
    movq    %rbx,%rdx       #rdx = i
    movq    %r9,%rcx        #rcx = j
    call    pstrijcpy
    
    
    movq    %rdi, %r12      #save pointer to str1           
    movq    %rsi, %r13      #save pointer to str2
    movq    (%rdi), %rsi
    andq    $255, %rsi      #rsi <- str1.length
    movq    %rdi, %r8       
    incq    %r8
    movq    %r8, %rdx       #rdx <- str1.str
    movq    $format_printf_length_string, %rdi
    xorq    %rax, %rax      #rax = 0
    call    printf
    movq    %r13, %rsi      #restore pointer to str2
    movq    %r12, %rdi      #restore pointer to str1
    movq    %rsi, %r8       
    incq    %r8             #r8 <- pstr2.str
    movq    %r8, %rdx
    movq    (%rsi), %r8     
    andq    $255, %r8       #r8 <- pstr2.length
    movq    %r8, %rsi
    movq    $format_printf_length_string, %rdi
    xorq    %rax, %rax      #rax = 0
    call    printf
    movq    %r12, %rdi      #restore pstr1
    movq    %r13, %rsi      #restore pstr2
    popq    %r12            #restore calees
    popq    %r13
    popq    %rbx
    
    addq    $8, %rsp
    movq    %rbp, %rsp      #restoring the old stack pointer.
    popq    %rbp            #restoring the old frame pointer.
    ret

.CASE_36:                   #case user pressed 36 (swapCase).

    pushq   %r12
    movq    %rdx, %r12      #r12 points to pstring2
    push    %r13
    movq    %rsi, %r13      #r13 points to pstring1
   
    movq    %r13, %rdi      #rdi <- pstring1
    call    swapCase
    movq    (%r13), %rsi
    andq    $255, %rsi      #rsi <- pstring1.length
    movq    %r13, %rdx      
    incq    %rdx            #rdx <- pstring1.str
    movq    $format_printf_length_string, %rdi
    xorq    %rax, %rax
    call    printf
    movq    %r12, %rdi      #rdi <- pstring2
    call    swapCase
    movq    (%r12), %rsi
    andq    $255, %rsi      #rsi <- pstring2.length
    movq    %rdi, %rdx
    incq    %rdx
    movq    $format_printf_length_string, %rdi
    xorq    %rax, %rax      #rax = 0
    call    printf
    
    popq    %r13            #restore callee
    popq    %r12
    movq    %rbp, %rsp      #restoring the old stack pointer.
    popq    %rbp            #restoring the old frame pointer.
    ret  
    
.CASE_37:                   #case user pressed 37 (pstrijcmp)

    pushq   %rbx            #save callee rbx, r13, r12
    pushq   %r13
    movq    %rdx, %r13      #r13 <- pstr2
    pushq   %r12
    movq    %rsi, %r12      #r12 <- pstr1
    subq    $8, %rsp        #making place for 2 ints.
    movq    $format_scanf_int, %rdi    #format of %d.
    leaq    -32(%rbp), %rsi            #move rsi pointer to the stack pointer position.
    xorq    %rax, %rax      #rax = 0
    call    scanf
    
    movq    (%rsp), %rbx    
    andq    $255, %rbx      #rbx = i
    
    movq    $format_scanf_int, %rdi    #format of %d.
    leaq    -32(%rbp), %rsi            #move rsi pointer to the stack pointer position.
    xorq    %rax, %rax      #rax = 0
    call    scanf
    
    movq    (%rsp), %r9
    andq    $255, %r9       #r9 = j
    movq    %r12,%rsi       #rsi <- pstr1
    movq    %r13, %rdx      #rdx <- pstr2
    movq    %rsi,%rdi       #rdi <- pstr1
    movq    %rdx,%rsi       #rsi <- pstr2
    movq    %rbx,%rdx       #rdx <- i
    movq    %r9,%rcx        #rcx <- j
    call    pstrijcmp  
    movq    $format_printf_compare_result, %rdi
    movq    %rax, %rsi      #compare result -> rsi
    xorq    %rax, %rax      #rax = 0
    call    printf
    
    addq    $8, %rsp        #decrease stuck pointer
    popq    %r12            #restore callees
    popq    %r13
    popq    %rbx
    movq    %rbp, %rsp      #restoring the old stack pointer.
    popq    %rbp            #restoring the old frame pointer.
    ret 
    
.DEFAULT:                   #default case
    pushq   %r12            #save callees
    pushq   %r13
    movq    %rsi, %r12      #save pstr1, pstr2
    movq    %rdi, %r13
    movq    $format_printf_invalid, %rdi
    xorq    %rax, %rax      #rax = 0
    call    printf
    movq    %r13, %rdi      #restore pstr1, pstr2
    movq    %r12, %rsi
    popq    %r13            #restore callees
    popq    %r12
    movq    %rbp, %rsp      #restoring the old stack pointer.
    popq    %rbp            #restoring the old frame pointer.
    ret
   