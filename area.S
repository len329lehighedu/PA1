.global area
# a in %edi, b in %esi, c in %edx; result in %eax
area:
    # Compute p = (a + b + c) / 2
    movl %edi, %r8d             # %r8d = a
    addl %esi, %r8d             # %r8d = a + b 
    addl %edx, %r8d             # %r8d = a + b + c 
    shrl $1, %r8d               # %r8d = (a + b + c) / 2 = p 

    # Compute p - a, p - b, p - c
    movl %r8d, %ecx             # %ecx = p
    subl %edi, %ecx             # %ecx = p - a

    movl %r8d, %r9d             # %r9d = p
    subl %esi, %r9d             # %r9d = p - b

    movl %r8d, %r10d            # %r10d = p
    subl %edx, %r10d            # %r10d = p - c

    # Compute p = p * (p - a) * (p - b) * (p - c)
    imull %ecx, %r8d             # p = p * (p - a)
    imull %r9d, %r8d             # p = p * (p - b)
    imull %r10d, %r8d            # p = p * (p - c)

    # Call r_sqrt(p)
    movl %r8d, %edi             # Pass product as argument to r_sqrt
    jmp r_sqrt                  # Jump directly to r_sqrt


# Recursive helper function: int r_sqrt(int x)
# x in %edi; return value in %eax
r_sqrt:
    # Base cases
    cmpl $0, %edi
    jl .L_neg                  # Jump to .L_neg if x < 0

    cmpl $2, %edi
    jl .L_base                 # If x < 2, return x

    # Preserve %rbx across recursive call
    pushq %rbx
    movl %edi, %ebx            # Preserve x in %ebx

    # Recursive call: r_sqrt(x >> 2)
    sarl $2, %edi              # %edi = x >> 2
    call r_sqrt                # Result in %eax

    # small_cand = r_sqrt(x >> 2) << 1
    shll $1, %eax              # %eax = small_cand

    # large_cand = small_cand + 1
    leal 1(%rax), %ecx         # %ecx = large_cand

    # If (large_cand * large_cand > x) return small_cand
    movl %ecx, %edx            # %edx = large_cand
    imull %ecx, %edx           # %edx = large_cand * large_cand
    cmpl %ebx, %edx            # Compare (large_cand * large_cand) with x
    jg .L_return_small         # Jump if large_cand^2 > x

    # Else return large_cand (%ecx)
    movl %ecx, %eax

.L_return_small:
    popq %rbx                  # Restore %rbx
    retq

.L_neg:
    movl $-1, %eax             # Return -1
    retq

.L_base:
    movl %edi, %eax             # Return x
    retq



# int area(int a, int b, int c){
#     int p = (a + b + c)/2;
#     p = p * (p-a) * (p-b) * (p-c);
#     return sqrt(p);
# }
# calculate recursively the square root of an int (in C)
# int r_sqrt(int x){
#    if(x < 0)
#        return -1;
#    if (x < 2)
#        return x;
#   /* recursive call */
#    int small_cand = r_sqrt(x >> 2) << 1;
#    int large_cand = small_cand + 1;
#    if (large_cand * large_cand > x)
#        return small_cand;
#    else
#        return large_cand;
# }
