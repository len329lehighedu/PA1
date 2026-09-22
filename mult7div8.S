.global mult7div8
# a in %dil (signed char), overflow pointer in %rsi
# Returns mult / 8 in %al (sign-extended to %eax)
mult7div8:
  # Compute mult = 7 * a
  movb %dil, %al             # %al = a
  movb $7, %cl               # %cl = 7
  imulb %cl                  # %ax = %al * 7 (8-bit result in %al)

  # Check overflow condition: (a > 0 && mult < 0) || (a < 0 && mult > 0)
  movb $0, (%rsi)            # Default: *overflow = 0

  cmpb $0, %dil              # Compare a with 0
  jge .L_a_non_negative      # If a >= 0, check non-negative branch

.L_a_negative:
  # If a < 0, overflow happens if mult > 0
  cmpb $0, %al
  jle .L_divide              # If mult <= 0, no overflow
  movb $1, (%rsi)            # *overflow = 1
  jmp .L_divide

.L_a_non_negative:
  jle .L_divide              # If a == 0, no overflow
  # If a > 0, overflow happens if mult < 0
  cmpb $0, %al
  jge .L_divide              # If mult >= 0, no overflow
  movb $1, (%rsi)            # *overflow = 1

.L_divide:
  # Compute mult / 8
  cbw                        # Sign-extend %al into 16-bit %ax
  movb $8, %cl               # Divisor = 8
  idivb %cl                  # Divide %ax by 8: Quotient in %al, Remainder in %ah

  movsbl %al, %eax           # Sign-extend result %al to %eax for return
  retq


# char mult7div8(char a, char *overflow){
#     char mult = (7 * a);
#     if(a > 0 && mult < 0 || a < 0 && mult > 0)
#       *overflow = 1;
#     else
#       *overflow = 0;
#     return mult/8;
# }
