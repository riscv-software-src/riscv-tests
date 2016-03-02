AC_INIT(riscv-tests, 1.0)

cross_compiling=yes
AC_PROG_CC

AC_ARG_ENABLE([M], AS_HELP_STRING([--disable-M], [Do no build M tests]))
AS_IF([test "x$enable_M" != "xno"], [
  AC_SUBST(enable_M,yes)
])

AC_ARG_ENABLE([A], AS_HELP_STRING([--disable-A], [Do no build A tests]))
AS_IF([test "x$enable_A" != "xno"], [
  AC_SUBST(enable_A,yes)
])

AC_ARG_ENABLE([F], AS_HELP_STRING([--disable-F], [Do not build F tests]))
AS_IF([test "x$enable_F" != "xno"], [
  AC_SUBST(enable_F,yes)
])

AC_OUTPUT(
    Makefile
)
