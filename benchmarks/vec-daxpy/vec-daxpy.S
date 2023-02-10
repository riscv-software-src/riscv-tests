    .text
    .balign 4
    .global vec_daxpy
# void
# vec_daxpy(size_t n, const double a, const double *x, const double *y, double* z)
# {
#   size_t i;
#   for (i=0; i<n; i++)
#     z[i] = a * x[i] + y[i];
# }
#
# register arguments:
#     a0      n
#     fa0     a
#     a1      x
#     a2      y
#     a3      z
vec_daxpy:
    vsetvli a4, a0, e64, m8, ta, ma
    vle64.v v0, (a1)
    sub a0, a0, a4
    slli a4, a4, 3
    add a1, a1, a4
    vle64.v v8, (a2)
    vfmacc.vf v8, fa0, v0
    vse64.v v8, (a3)
    add a2, a2, a4
    add a3, a3, a4
    bnez a0, vec_daxpy
    ret
