.global secondMax
# v1 in %di, v2 in %si, v3 in %dx, v4 in %cx  (signed 16-bit); result in %ax
secondMax:
  
  # compare v1, v2
  cmpw %si, %di           # %di - %si or v1 - v2
  jns .check_v1v2_true    # jump to .check_v1v2_true if v1 - v2 >= 0 or v1 >= v2
  # else (v1 < v2)
  movw %si, %r8w          # %r8w = %si or first = v2
  movw %di, %ax           # %ax = %di or second = v1
  jmp .check_v3

.check_v1v2_true:
  movw %di, %r8w
  movw %si, %ax  

.check_v3:
  cmpw %r8w, %dx           # %dx - %r8w or v3 - first
  jle .v3_else_if

  # if (v3 > first)
  movw %r8w, %ax          # %ax = %r8w (second = first)
  movw %dx, %r8w          # %r8w = %dx (first = v3)
  jmp .check_v4

.v3_else_if:
  cmpw %ax, %dx           # %dx - %ax (or v3 - second)
  jle .check_v4           # jump to .check_v4 if v3 - second <= 0 or v3 <= second

  # else if v3 > second
  movw %dx, %ax           # %ax = %dx (second = v3)

.check_v4:
  cmpw %r8w, %cx          # %cx - %r8w (v4 - first)
  jle .v4_else_if         # jump to .v4_else_if if v4 - first <= 0 or v4 <= first

  # If (v4 > second)
  movw %r8w, %ax          # %ax = %r8w (second = first)
  movw %cx, %r8w          # %r8w = %cx (first = v4)
  jmp .done

.v4_else_if:
  cmpw %ax, %cx           # %cx - %ax (v4 - second)
  jle .done               # if v4 - second <= 0 or v4 <= second -> return

  # if (v4 > second)
  movw %cx, %ax           # %ax = %cx (second = v4)
.done:
  retq



# short secondMax(short v1, short v2, short v3, short v4){
#     short first, second;
#     if(v1 >= v2){ first = v1; second = v2; }
#     else        { first = v2; second = v1; }
#     if(v3 > first)       { second = first; first = v3; }
#     else if(v3 > second) { second = v3; }
#     if(v4 > first)       { second = first; first = v4; }
#     else if(v4 > second) { second = v4; }
#     return second;
# }
