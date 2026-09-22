.global area
# a in %edi, b in %esi, c in %edx; result in %eax
area:
    # Compute p = (a+b+c)/2
    movl %edi, %r8d         # %r8d = a
    addl %edi, %r8d         # %r8d = a + b
    addl %edx, %r8d         # %r8d = a + b + c 
    shrl $1, %r8d           # %r8d = %r8d >> 1 = (a+b+c)/2 = p 

    # compute p = p * (p-a) * (p-b) * (p-c)

    # compute p - a
    movl %r8d, %ecx            # %ecx = p
    subl %edi, %ecx            # %ecx = p - a
    # compute p - b
    movl %r8d, %r9d            # %r9d = p
    subl %esi, %r9d            # %r9d = p - b
    # compute p - c
    movl %r8d, %r10d           # %r10d = p
    subl %edx, %r10d           # %r10d = p - c

    # Compute p = p * (p - a) * (p - b) * (p - c)
    imull %ecx, %r8d           # p = p * (p - a)
    imull %r9d, %r8d           # p = p * (p - b)
    imull %r10d, %r8d          # p = p * (p - c)

    # Call r_sqrt(p)
    movl %r8d, %edi            # 
    jmp r_sqrt                 # jump directly to r_sqrt

  
# Recursive helper function: int r_sqrt(int x)
# x in %edi; return value in %eax
r_sqrt:
    # Base cases
    cmpl $0, %edi
    jl .L_neg                  # jump to .L_neg if  return -1
    cmpl $2, %edi
    jl .L_base                 # if x < 2 -> return x

    # Preserve %rbx across recursive function call
    pushq %rbx
    movl %edi, %ebx            # Preserve x in %ebx

    # Recursive call: r_sqrt(x >> 2)
    sarl $2, %edi              # %edi = x >> 2
    call r_sqrt                # Result in %eax

    # small_cand = r_sqrt(x >> 2) << 1
    shll $1, %eax              # %eax = small_cand

    # large_cand = small_cand + 1
    leal 1(%rax), %ecx         # %ecx = large_cand

    # If (large_cand * large_cand > x) return small_cand;
    movl %ecx, %edx            # %edx = large_cand
    imull %ecx, %edx           # %edx = large_cand * large_cand
    cmpl %ebx, %edx            # %edx - %ebx = large_cand * large_cand - x
    jg .L_return_small         # jump to .L_return_small if large_cand * large_cand - x > 0 or large_cand * large_cand > x 

    # Else return large_cand (%ecx)
    movl %ecx, %eax

.L_return_small:
    popq %rbx                  # Restore %rbx
    retq

.L_neg:
    movl $-1, %eax             # return -1
    retq

.L_base:
    movl %edi, %eax            # return x
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
