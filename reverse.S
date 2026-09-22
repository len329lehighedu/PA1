.global reverse
# list in %rdi (array of char*), n in %esi
reverse:
  movq $0, %rcx         # i = 0
  
  # Calculate n / 2 and store it in %rax as a fixed bound
  movl %esi, %eax       # %eax = n
  shrq $1, %rax         # %rax = n >> 1 (n / 2)

.Check:
  cmpq %rax, %rcx       # %rcx - %rax = i - n/2
  jge .done             # If i >= n / 2, exit loop

.Loop:
  # Calculate index j = n - i - 1 directly in %rdx
  movl %esi, %edx       # %rdx = n
  subq %rcx, %rdx       # %rdx = n - i
  subq $1, %rdx         # %rdx = n - i - 1 = j

  # Swap list[i] and list[j]
  movq (%rdi, %rcx, 8), %r8   # temp = list[i]
  movq (%rdi, %rdx, 8), %r9   # %r9 = list[j]
  movq %r9, (%rdi, %rcx, 8)   # list[i] = list[j]
  movq %r8, (%rdi, %rdx, 8)   # list[j] = temp

  addq $1, %rcx               # i++
  jmp .Check

.done:
  retq


# void reverse(char **list, unsigned n){
#     unsigned i = 0;
#     while (i < n/2){
#      char *temp = list[i];
#      list[i] = list[n-i-1];
#      list[n-i-1] = temp;
#      i++;
#     }
# }
