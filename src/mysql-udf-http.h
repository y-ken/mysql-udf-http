#include <curl/curl.h>
/* Common definitions for all functions */
#define CURL_UDF_MAX_SIZE 1024*1024

#define VERSION_STRING "1.0\n"
#define VERSION_STRING_LENGTH 4

typedef struct st_curl_results st_curl_results;
struct st_curl_results {
  char *result;
  size_t size;
};
