.global sum
# pointer to list head in %rdi; result in %rax
# struct ll { char *name; long value; struct ll *next; }
#   offset 0  : name
#   offset 8  : value
#   offset 16 : next
sum:
    movq $0, %rax   # total = 0

.L_loop:
    cmpq $0, %rdi       # %rdi - 0 (check ptr != null)
    je .L_done          # if %rdi = 0 (or ptr = null) -> out while loop, return total
    addq 8(%rdi), %rax  # get memory at %rdi + 8 and add to %rax (total += ptr->value)
    movq 16(%rdi), %rdi # get pointer's value at memory 16 + %rdi, put into %rdi (ptr = ptr->next)
    jmp .L_loop         # continue the loop 
.L_done:
    retq


# sum of the elements of a linkedlist in C
# long sum(struct ll *list){
#    long total = 0;
#    struct ll *ptr = list;
#    while(ptr){
#        total += ptr->value;
#        ptr = ptr->next;
#    }
#    return total;
# }
