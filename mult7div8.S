.global mult7div8

mult7div8:
    # 1. Compute mult = 7 * a using 8-bit multiplication
    movb %dil, %al              # Load 'a' into %al
    movb $7, %cl                # Load constant 7 into %cl
    imulb %cl                   # %ax = 7 * a. Lower 8 bits (%al) holds 'mult'

    # 2. Set default overflow status to 0 (false)
    movb $0, (%rsi)             # *overflow = 0

    # 3. Check for 8-bit signed overflow condition:
    #    overflow occurs if (a > 0 && mult < 0) OR (a < 0 && mult > 0)
    cmpb $0, %dil               # Compare 'a' with 0
    jge .L_a_non_negative       # Jump if a >= 0

.L_a_negative:
    # Case: a < 0. Overflow if mult (%al) > 0
    cmpb $0, %al                # Compare 'mult' with 0
    jle .L_divide               # If mult <= 0, no overflow -> proceed to divide
    movb $1, (%rsi)             # Set *overflow = 1
    jmp .L_divide               # Proceed to divide

.L_a_non_negative:
    je .L_divide                # If a == 0, no overflow -> proceed to divide
    # Case: a > 0. Overflow if mult (%al) < 0
    cmpb $0, %al                # Compare 'mult' with 0
    jge .L_divide               # If mult >= 0, no overflow -> proceed to divide
    movb $1, (%rsi)             # Set *overflow = 1

.L_divide:
    # 4. Perform signed division: mult / 8
    # Sign-extend 8-bit mult (%al) into 16-bit %ax for idivb
    cbw                         # Convert byte in %al to word in %ax
    movb $8, %cl                # Load divisor 8 into %cl
    idivb %cl                   # %ax / %cl -> Quotient in %al, Remainder in %ah

    # 5. Prepare 32-bit return value
    movsbl %al, %eax            # Sign-extend 8-bit quotient (%al) into %eax
    retq


# char mult7div8(char a, char *overflow){
#     char mult = (7 * a);
#     if(a > 0 && mult < 0 || a < 0 && mult > 0)
#       *overflow = 1;
#     else
#       *overflow = 0;
#     return mult/8;
# }
