EXTRA_DIST = mysql-udf-http.h
INCLUDES = -I$(top_builddir)/include $(MYSQL_INC) $(DEPS_CFLAGS) $(LIBCURL_CPPFLAGS) $(LIBCURL)

lib_LTLIBRARIES = mysql-udf-http.la
mysql-udf-http_la_SOURCES = mysql-udf-http.c
mysql-udf-http_la_LDFLAGS = -module
mysql-udf-http_la_LIBADD = $(DEPS_LIBS) $(LIBCURL)
