.global commonPrefix
# a in %rdi, b in %rsi; result (prefix length) in %eax
commonPrefix:
  movq $0, %rax # n = 0

.L_loop:
  # addressing mode
  movb (%rdi, %rax, 1),%dl                      # %dl = a[n]
  movb (%rsi, %rax, 1),%cl                      # %cl = b[n]
  # check condition: a[n] != 0 && a[n] == b[n]
  cmpb $0, %dl                                  # %dl - 0  
  je .L_done                                    # if %dl = 0 (or a[n] == '\0') -> out of loop
  cmpb %cl, %dl                                 # %dl - %cl
  jne .L_done                                   # if %dl - %cl != 0 or %dl != % cl or a[n] != [b] -> out of loop
  addq $1, %rax                                 # %rax = %rax + 1
  jmp .L_loop                                   # continue the while loop

.L_done:
  retq                                          # return %rax

# length of the longest common prefix of two null-terminated strings
# int commonPrefix(char *a, char *b){
#     int n = 0;
#     while(a[n] && a[n] == b[n])
#         n++;
#     return n;
# }
