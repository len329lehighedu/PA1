.global gcd
# a in %edi, b in %esi; result in %eax
gcd:
    cmpl $0, %esi              # Base case: if (b == 0)
    je .L_base_case            # Return a

    # Compute a % b
    movl %edi, %eax            # %eax = a
    cltd                       # Sign-extend %eax into %edx:%eax
    idivl %esi                 # Quotient in %eax, Remainder in %edx

    # Set up arguments for recursive call: gcd(b, a % b)
    movl %esi, %edi            # 1st arg: b
    movl %edx, %esi            # 2nd arg: a % b
    call gcd                   # Recursive call gcd(b, a % b)
    retq                       # Return result from recursive call

.L_base_case:
    movl %edi, %eax            # Return a
    retq


# greatest common divisor via Euclid's algorithm (recursive)
# int gcd(int a, int b){
#     if(b == 0)
#         return a;
#     /* recursive call */
#     return gcd(b, a % b);
# }
