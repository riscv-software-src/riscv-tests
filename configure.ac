AC_INIT(riscv-tests, 1.0)

cross_compiling=yes
AC_PROG_CC

AC_ARG_WITH(xlen,
        [AS_HELP_STRING([--with-xlen=XLEN],
                [Set XLEN, the X-register bit width (default is 64)])],
        AC_SUBST(XLEN, $withval),
        AC_SUBST(XLEN, 64)
        )

ac_enable_threads=unset
AC_ARG_ENABLE(threads,
        AS_HELP_STRING([--enable-threads],
        [enable test for multi-thread.]),
[case "${enableval}" in
  yes)  ac_enable_threads=1 ;;
  no)   ac_enable_threads=0 ;;
esac])dnl

if test "${ac_enable_threads}" = unset; then
  ac_enable_threads=1
fi

AC_DEFINE_UNQUOTED(ENABLE_THREADS,
  $ac_enable_threads,
  [Define to 1 if you want to test with multi-thread.])

AC_CONFIG_HEADERS(config.h:config.in)

AC_OUTPUT(
    Makefile
)
