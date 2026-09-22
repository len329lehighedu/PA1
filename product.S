.global product
# a in %rdi, b in %rsi, c in %rdx, size in %ecx
product:
    movq $0, %r8               # i = 0
    movl %ecx, %ecx            # Zero-extend size to 64-bit (%rcx)

.L_loop:
    cmpq %rcx, %r8             # Compare i (%r8) with size (%rcx)
    jge .L_done                # If i >= size, exit loop

    # Load a[i] and b[i], multiply, and store into c[i]
    movss (%rdi, %r8, 4), %xmm0  # %xmm0 = a[i] (4-byte float)
    movss (%rsi, %r8, 4), %xmm1  # %xmm1 = b[i] (4-byte float)
    mulss %xmm1, %xmm0           # %xmm0 = a[i] * b[i]
    movss %xmm0, (%rdx, %r8, 4)  # c[i] = %xmm0

    addq $1, %r8               # i++
    jmp .L_loop

.L_done:
    retq

# Product of two vectors in C
# void product(float *a, float *b, float *c, unsigned size){
#    for(int i=0; i<size; i++){
#        c[i] = a[i] * b[i];
#    }
# }
