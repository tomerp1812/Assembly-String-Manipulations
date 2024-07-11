#209549542 Tomer Peisikov
#Exersice 3
#Compile with: gcc main.s

.data

.section	   .rodata		       #read only data section

format_scanf_int:	.string	"%d"	
format_scanf_string:	.string "%s"

.text                                   #the beginnig of the code
.global run_main
.type run_main, @function
run_main:
    pushq   %rbp                        #saving the old frame pointer.
    movq    %rsp, %rbp                  #creating the new frame pointer.
    
    subq    $528, %rsp                  #make place on stuck for 2 strings + 2 ints(which take 1 byte due to length of string) + 1 option.
    movq	    $format_scanf_int, %rdi    
    leaq    (%rsp), %rsi                #make rsi to point to the upper bound of the stuck.
    xorq	    %rax, %rax	               #rax = 0
    call    scanf                       #scan str1.length
    
    leaq    1(%rsp), %rsi               #rsi points to 1 byte below upper bound of stuck.
    movq    $format_scanf_string, %rdi  
    xorq    %rax, %rax                  #rax = 0
    call    scanf                       #scan string1
    
    leaq    256(%rsp), %rsi             #rsi points to start of struct 2
    movq    $format_scanf_int, %rdi     
    xorq    %rax,%rax                   #rax = 0    
    call    scanf                       #scan str2.length
    
    leaq    257(%rsp), %rsi             
    movq    $format_scanf_string, %rdi  
    xorq    %rax, %rax                  #rax = 0
    call    scanf                       #scan string2
    
    leaq    512(%rsp), %rsi             #point to address of rbp - 16
    movq    $format_scanf_int, %rdi     
    xorq    %rax, %rax          
    call    scanf                       #scan option
    
    leaq    512(%rsp), %rdi             #*(rsp + 512) -> rdi (option)
    leaq    (%rsp), %rsi                #*(rsp) -> rsi (pstr1)
    leaq    256(%rsp), %rdx             #*(rsp + 256) -> rdx (pstr2)
    
    movq    (%rdi), %rdi                
    andq    $255, %rdi                  #zeroies all garbage data (rdi = option)
    movb    (%rsi), %r8b                #*pstr1 -> r8b
    andq    $255, %r8                   #zeroies all garbage data (valids str1.length)
    movb    %r8b, (%rsi)                #str1.length -> *rsi
    movb    (%rdx), %r8b                #same as str1
    andq    $255, %r8
    movb    %r8b, (%rdx)
    
    
    
    call    run_func                    
    
    
    addq    $528, %rsp                    
    movq    %rbp, %rsp                  #restoring the old stack pointer.
    popq    %rbp                        #restoring the old frame pointer.
    ret                                 #returning to the function that called us.
    