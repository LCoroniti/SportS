#include "prog.h"
#include "val/str.h"
#include "val/real.h"
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
// Add individual opcodes or native functions here

NATIVE(SIZE) {
    val_t *v = ARG(0);
    int len = val_len(v);
    return v_num_new_int(len);
}

NATIVE(myadd) {
  val_t *v1 = ARG(0);
  val_t *v2 = ARG(1);

  return val_add(v1, v2);
}

OPCODE(MKFLOAT) {
  //I have the on the top of the stack the value before the point and on the second the value after the point
    val_t *v1 = POP;
    val_t *v2 = POP;
    //I have to convert the two values to string and then concatenate them
    val_t *str1 = val_conv(T_STR, v1);
    val_t *str2 = val_conv(T_STR, v2);
    //create a val_t with the point
    val_t *strp = v_str_new_cstr(".");
    //I have to concatenate the two strings
    val_t *str3 = val_add(str1, strp);
    str3 = val_add(str3, str2);
    val_t *v3 = val_conv(T_REAL,str3);
    PUSH(v3);
}

OPCODE(mymul) {
  val_t *v1 = POP;
  val_t *v2 = POP;
  PUSH(val_mul(v1, v2));
}


