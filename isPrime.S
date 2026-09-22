.global isPrime
# n in %edi; result in %eax (1 = prime, 0 = not prime)
isPrime:
    cmpl $2, %edi
    jl .not_prime            # If n < 2 -> not a prime number (return 0)
    je .is_prime             # If n == 2 -> is a prime number (return 1)

    # Check n % 2 == 0
    movl %edi, %eax          # Copy n ingo %eax for mod
    cltd                     # (%edx:%eax = n)
    movl $2, %ecx
    idivl %ecx               # %edx:%eax / 2. remainder -> %edx
    cmpl $0, %edx            # %edx - 0
    je .not_prime            # if %edx = 0 -> jump to not_prime and return 0

    movl $3, %ecx            # i = 3
  .L_loop:
    # Calculate iˆ2 and compare to n
    movl %ecx, %eax          # %eax = i
    imull %ecx, %eax         # %eax = i * i
    cmpl %edi, %eax          # %eax - %edi = iˆ2 - n
    jg .is_prime             # if iˆ2 > n -> out of for loop, return 1

    # Check n % i == 0
    movl %edi, %eax          # Copy n into %eax
    cltd                     # 
    idivl %ecx               # (%edx:%eax) mod (%ecx) (n % i), remainder at %edx
    cmpl $0, %edx            # %edx - 0
    je .not_prime            # %edx = 0 -> return 0

    addl $2, %ecx            # increment i+=2
    jmp .L_loop              # continue for loop

  .is_prime:
      movl $1, %eax            # return 1
      ret

  .not_prime:
      movl $0, %eax            # return 0
      ret


# int isPrime(int n){
#     if(n < 2)
#         return 0;
#     if(n % 2 == 0)
#         return n == 2;
#     /* only test odd divisors i while i*i <= n */
#     for(int i = 3; i * i <= n; i += 2){
#         if(n % i == 0)
#             return 0;
#     }
#     return 1;
# }
