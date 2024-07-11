#209549542 Tomer Peisikov
#Exersice 3
#Compile with: gcc main.s

.data

.section .rodata           #read only data section

format_printf_invalid_input:   .string "invalid input!\n"
    
.text
.globl pstrlen
.type pstrlen, @function
#The function accepts a pointer to Pstring and returns the length of the string.
pstrlen:
    pushq   %rbp           #saving the old frame pointer.
    movq    %rsp, %rbp     #creating the new frame pointer.
    
    movq    (%rdi), %rax   #rax = &rsi (the address)
    andq    $255, %rax     #rax = str.length
     
    movq    %rbp, %rsp     #restoring the old stack pointer.
    popq    %rbp           #restoring the old frame pointer.
    ret                    #returning to the function that called us.

.globl replaceChar
.type replaceChar, @function
#The function receives a pointer to a Pstring and two chars, and replaces each instance of oldChar with newChar.
#The function returns the pointer pstr (after changing the string).
replaceChar:

    pushq   %rbp           #saving the old frame pointer.
    movq    %rsp, %rbp     #creating the new frame pointer.
    
    movq    (%rdi), %rax 
    andq    $255, %rax     #gets the length of the string.
    movq    %rdi, %r8

.loop_replace_char:

    incq    %r8            #increase the pointer by 1
    cmpq    $0, %rax       #if the counter is 0 means no more chars left.
    je      .endOfReplaceChar           #jump to end of function
    movb    (%r8), %r9b    
    cmpb    %r9b, %sil
    je      .replaceThechar             #if str[i] == oldChar -> Goto replaceChar
    decq    %rax                        #decrease counter
    jmp     .loop_replace_char          #goes to next iteration
    
.replaceThechar:
    
    movb    %dl, (%r8)      #puts the char to where r8 points to.
    decq    %rax            #decrease counter
    jmp     .loop_replace_char          #next iteration
    
.endOfReplaceChar:

    movq    %rdi, %rax 
    movq    %rbp, %rsp      #restoring the old stack pointer.
    popq    %rbp            #restoring the old frame pointer.
    ret                     #returning to the function that called us.

.globl pstrijcpy
.type pstrijcpy, @function
#The function receives two pointers to Pstring, copies the substring src[i:j](including) into dst[i:j]
#(including) and returns the pointer to dst. If the indexes i or j exceed the limits of src or dst, 
#dst does not be change and the message printed: "invalid input!\n"
pstrijcpy:

    pushq   %rbp            #saving the old frame pointer.
    movq    %rsp, %rbp      #creating the new frame pointer.

    movq    (%rdi), %r8         
    movq    (%rsi), %r9    
    andq    $255, %r8      #r8 = str1.length
    andq    $255, %r9      #r9 = str2.length
    cmpq    %rdx, %rcx     #compare i,j 
    jb      .invalidInput            #jump to invalidInput if i > j 
    cmpq    %r8, %rdx      #compare i,str1.length
    jae     .invalidInput            #jump to invalidInput if i > str1.length
    cmpq    %r8, %rcx      #compare i,str2.length
    jae     .invalidInput            #jump to invalidInput if i > str2.length
    cmpq    %r9, %rdx      #compare j,str1.length
    jae     .invalidInput            #jump to invalidInput if j > str1.length
    cmpq    %r9, %rcx      #compare j,str2.length
    jae     .invalidInput            #jump to invalidInput if j > str2.length 
    cmpq    $0, %rdx       #compare i >= 0
    jb      .invalidInput  #Goto invalidInput if i < 0
    cmpq    $0, %rcx       #compare j >= 0 
    jb      .invalidInput  #Goto invalidInput if j < 0
    
    movq    %rcx, %rax     #rax = j
    subq    %rdx, %rcx     #rcx = j - i, %rdx = i
    movq    %rdi, %r10      
    movq    %rsi, %r11   
    incq    %r10           #r10 = pstr1.str
    incq    %r11           #r11 = pstr2.str
    addq    %rdx, %r10     #increment the pointer to point on str1[i]
    addq    %rdx, %r11     #increment the pointer to point on str2[i]
    
.pstrcopyLoop:
    
    cmpq    $-1, %rcx      
    je      .endOfpstrijcpy           #jump if j is less than i, that means we finished counting all the range
    movb    (%r11), %r9b              #copies str2[i] -> str1[i]  
    movb    %r9b, (%r10)
    decq    %rcx                      #decrease counter  
    incq    %r11                      #str1 + 1, str2 + 1  
    incq    %r10
    jmp     .pstrcopyLoop             #next iteration

.invalidInput:             #all the cases that user inputs invalid options.  

    pushq   %r12           #save calee
    movq    %rdi, %r12     #r12 <- pstr1  
    pushq   %r13           #save calee
    movq    %rsi, %r13     #r13 <- pstr2
    movq    $format_printf_invalid_input, %rdi
    xorq    %rax, %rax
    call    printf
    movq    %r12, %rdi     #restore pstr1,pstr2
    movq    %r13, %rsi
    popq    %r13           #restore callee r13,r12
    popq    %r12
    
.endOfpstrijcpy:
    
    movq    %rbp, %rsp     #restoring the old stack pointer.
    popq    %rbp           #restoring the old frame pointer.
    ret                    #returning to the function that called us.
    
.globl swapCase
.type swapCase, @function
#The function receives a pointer to a Pstring, 
#turns each uppercase English letter (A-Z) into a lowercase English letter (a-z)
#and vice versa - turns every lowercase English letter (a-z) into an uppercase English letter (A-Z)
#each none ASCII character not changed.
swapCase:

    pushq   %rbp           #saving the old frame pointer.
    movq    %rsp, %rbp     #creating the new frame pointer.
    
    movq    %rdi, %r8      
    andq    $255, %r8      #pst.length -> r8 (counter)
    movq    %rdi, %r9      #pst.str -> r9
    
.swapCaseLoop:

    cmpq    $0, %r8        #compare counter to 0
    je      .endOfswapCase
    movb    (%r9), %r10b
    cmpb    $97, %r10b     #if (str[i] < 97)
    jb      .upperCasejump           #jump to upperCasejump
    cmpb    $122, %r10b    #if (str[i] > 122)
    ja      .notAcharJump
    subb    $32, %r10b     #toUpperCase
    movb    %r10b, (%r9)   #str[i].toUpperCase
    incq    %r9            #str + 1 
    decq    %r8            #counter--     
    jmp     .swapCaseLoop

.upperCasejump:
    
    cmpb    $65, %r10b     #if (str[i] < 65)
    jb      .notAcharJump  #jumps if not an ASCII char 
    cmpb    $90, %r10b     #if (str[i] > 90) 
    ja      .notAcharJump  #jumps if not an ASCII char 
    addb    $32, %r10b     #toLowerCase
    movb    %r10b, (%r9)   #str[i].toLowerCase
    
.notAcharJump:

    incq    %r9            #increase pointer
    decq    %r8            #counter-- 
    jmp     .swapCaseLoop  #another iteration
    
.endOfswapCase:
        
    movq    %rbp, %rsp     #restoring the old stack pointer.
    popq    %rbp           #restoring the old frame pointer.
    ret  

.globl pstrijcmp
.type pstrijcmp, @function
#The function receives two pointers to Pstring and compares between str[i:j]->pstr1 (including) and str[i:j]->pstr2
#(including):
#1)returns 1 if pstr1[i:j] larger lexicographicly than pstr2[i:j]
#2)returns -1 if pstr1[i:j] smaller lexicographicly than pstr2[i:j]
#3)returns 0 if pstr1[i:j] equals to lexicographicly pstr2[i:j]
#If the indices i or j exceed the limits of src or dst, the return value is -2 and
#The message:"invalid input!\n"
pstrijcmp:

    pushq   %rbp           #saving the old frame pointer.
    movq    %rsp, %rbp     #creating the new frame pointer.

    movq    (%rdi), %r8    
    movq    (%rsi), %r9    
    andq    $255, %r8      #r8 = str1.length
    andq    $255, %r9      #r9 = str2.length
    cmpq    %rdx, %rcx     #compare i,j 
    jb      .loop_replace           #jump to loop_replace if i > j 
    cmpq    %r8, %rdx      #compare i,str1.length
    jae     .loop_replace           #jump to loop_replace if i >= str1.length
    cmpq    %r8, %rcx      #compare i,str2.length
    jae     .loop_replace           #jump to loop_replace if i >= str2.length
    cmpq    %r9, %rdx      #compare j,str1.length
    jae     .loop_replace           #jump to loop_replace if j >= str1.length
    cmpq    %r9, %rcx      #compare j,str2.length
    jae     .loop_replace           #jump to loop_replace if j >= str2.length 
    cmpq    $0, %rdx       #compare i to 0
    jb      .loop_replace           #jump to loop_replace
    cmpq    $0, %rcx       #compare j to 0
    jb      .loop_replace           #jump to loop_replace
    
    movq    %rcx, %rax     #rax = j
    subq    %rdx, %rcx     #rcx = j - i, %rdx = i
    movq    %rdi, %r10     
    movq    %rsi, %r11   
    incq    %r10           #r10 <- pstr1.str
    incq    %r11           #r11 <- pstr2.str 
    addq    %rdx, %r10     #increment the pointer to point on str1[i]
    addq    %rdx, %r11     #increment the pointer to point on str2[i]
    
.loop_replace3:

    movb    (%r10), %r8b   #r8 = str1[i]
    movb    (%r11), %r9b   #r9 = str2[i] 
    cmpb    %r8b, %r9b     #compare str1[i] tp str2[i] 
    jne     .loop_replace2
    incq    %r10           #str1++, str2++ 
    incq    %r11
    decq    %rcx           #counter-- 
    cmpq    $-1, %rcx      #if rcx < 0 means we finished counting the scope 
    jne     .loop_replace3
    movq    $0, %rax       #str1[i:j] = str2[i:j] ---> return 0 
    jmp     .loop_replace1
    
.loop_replace2:
    
    cmpb    %r8b, %r9b     #str1[i] == str2[i]
    ja      .loop_replace4
    movq    $1, %rax       #str1[i:j] > str2[i:j] 
    jmp     .loop_replace1
     
.loop_replace4:
    
    movq    $-1, %rax      #str1[i:j] < str2[i:j]
    jmp     .loop_replace1
    
.loop_replace:

    subq    $8, %rsp       #increases the stuck to modulo 16 
    movq    $format_printf_invalid_input, %rdi
    xorq    %rax, %rax     #rax = 0 
    call    printf          
    addq    $8, %rsp       #decreasees back the stuck 
    movq    $-2, %rax      #return -2 

.loop_replace1:

    movq    %rbp, %rsp     #restoring the old stack pointer.
    popq    %rbp           #restoring the old frame pointer.
    ret  


