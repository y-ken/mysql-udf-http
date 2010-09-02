dnl ---------------------------------------------------------------------------
dnl Macro: MYSQL_CONFIG
dnl ---------------------------------------------------------------------------
AC_DEFUN([MYSQL_CONFIG_TEST], [
  AC_MSG_CHECKING(for mysql_config)
  AC_ARG_WITH(mysql,
  [[  --with-mysql[=mysql_config]      
                        Support for the MySQL.]],
  [
    if test -n "$withval"; then
      if test "$withval" = "yes"; then
        for i in /usr/bin /usr/local/bin /usr/local/mysql/bin ; do
          if test -f "$i/mysql_config"; then
            MYSQL_CONFIG="$i/mysql_config"
          fi
        done
        if test "$MYSQL_CONFIG" = ""; then
          AC_MSG_ERROR(["could not find mysql_config 1"])
        fi
      else
        MYSQL_CONFIG="$withval"
        if test ! -f "$MYSQL_CONFIG"; then
          AC_MSG_ERROR(["could not find mysql_config 2 : $MYSQL_CONFIG"])
        fi
      fi
    else
      for i in /usr/bin /usr/local/bin /usr/local/mysql/bin ; do
        if test -f "$i/mysql_config"; then
          MYSQL_CONFIG="$i/mysql_config"
        fi
      done
      if test -z "$MYSQL_CONFIG"; then
        AC_MSG_ERROR(["could not find mysql_config 3"])
      fi
    fi
    
    AC_DEFINE([MYSQL_ENABLED], [1], [Enables MySQL])
    MYSQL_INC="`$MYSQL_CONFIG --cflags`"
    MYSQL_LIB="`$MYSQL_CONFIG --libs`"
    AC_MSG_RESULT(["$MYSQL_CONFIG"])
  ],
  [
    AC_MSG_ERROR(["could not find mysql_config 3"])
  ])
])

dnl ---------------------------------------------------------------------------
dnl Macro: MYSQL_CONFIG
dnl ---------------------------------------------------------------------------
