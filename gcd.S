.global gcd
# a in %edi, b in %esi; result in %eax
gcd:
    cmpl $0, %esi       # %esi - 0
    je .L_done          # if %esi - 0 = 0 or %esi = 0 -> jump to .L_done

    # compute a % b
    movl %edi, %eax     # %eax = a
    cltd                # Sign-extend %eax into %edx:%eax
    idivl %esi          # Divide %edx:%eax by b (%esi). Quotient in %eax, Remainder in %edx

    # recursive: gcd(b, a % b)
    movl %esi, %edi            # a_new = b
    movl %edx, %esi            # b_new = a % b
    jmp .L_loop                # Jump back to loop

.L_done:
    movl %edi, %eax     # %eax = %edi or result = a 
    retq                # return a


# greatest common divisor via Euclid's algorithm (recursive)
# int gcd(int a, int b){
#     if(b == 0)
#         return a;
#     /* recursive call */
#     return gcd(b, a % b);
# }
