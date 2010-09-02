AC_INIT(src/mysql-udf-http.c)
AC_CONFIG_AUX_DIR(config)
AM_CONFIG_HEADER(src/curl_config.h)

AM_INIT_AUTOMAKE("mysql-udf-http", 1.0 )

AC_PROG_CC
AC_PROG_LIBTOOL
LIBTOOL="$LIBTOOL --preserve-dup-deps"
AC_SUBST(LIBTOOL)dnl

sinclude(config/ac_mysql.m4)
sinclude(config/ac_curl.m4)
MYSQL_CONFIG_TEST
LIBCURL_CHECK_CONFIG

AC_SUBST(MYSQL_CONFIG)
AC_SUBST(MYSQL_INC)
AC_SUBST(MYSQL_LIB)
AC_SUBST(LIBCURL)
AC_SUBST(LIBCURL_CPPFLAGS)

PKG_CHECK_MODULES(DEPS, libcurl >= 7.15)
AC_SUBST(DEPS_CFLAGS)
AC_SUBST(DEPS_LIBS)

AC_C_CONST
AC_TYPE_SIZE_T
AC_CHECK_HEADERS(limits.h syslimits.h)
AC_OUTPUT(Makefile src/Makefile)
