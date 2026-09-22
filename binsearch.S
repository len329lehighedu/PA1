.global binsearch

binsearch:
    movl $0, %eax               # lo (%eax) = 0
    leal -1(%rsi), %ecx         # hi (%ecx) = n - 1

.Lloop:
    cmpl %ecx, %eax             # Compare lo (%eax) with hi (%ecx)
    jg .Lnot_found              # If lo > hi, target is not in array

    # Compute mid = lo + (hi - lo) / 2
    movl %ecx, %r8d             # %r8d = hi
    subl %eax, %r8d             # %r8d = hi - lo
    sarl $1, %r8d               # %r8d = (hi - lo) / 2
    addl %eax, %r8d             # %r8d = mid (lo + offset)

    # Load arr[mid] (each int is 4 bytes, so scale factor is 4)
    movl (%rdi,%r8,4), %r9d     # %r9d = arr[mid]

    # Compare arr[mid] with target
    cmpl %edx, %r9d
    je .Lfound                  # If arr[mid] == target, return mid
    jl .Lless                   # If arr[mid] < target, search upper half

.Lgreater:
    # If arr[mid] > target: search lower half (hi = mid - 1)
    leal -1(%r8), %ecx          # hi = mid - 1
    jmp .Lloop

.Lless:
    # If arr[mid] < target: search upper half (lo = mid + 1)
    leal 1(%r8), %eax           # lo = mid + 1
    jmp .Lloop

.Lfound:
    movl %r8d, %eax             # Return mid
    retq

.Lnot_found:
    movl $-1, %eax              # Return -1
    retq

# binary search over a sorted int array; returns the index of target, or -1
# int binsearch(int *arr, unsigned n, int target){
#     int lo = 0;
#     int hi = (int)n - 1;
#     while(lo <= hi){
#         int mid = lo + (hi - lo) / 2;
#         if(arr[mid] == target)
#             return mid;
#         else if(arr[mid] < target)
#             lo = mid + 1;
#         else
#             hi = mid - 1;
#     }
#     return -1;
# }
