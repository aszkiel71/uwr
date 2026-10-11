#include "csapp.h"

#define BUFFSIZE 4096

int main(void) {
  int n;
  char buf[BUFFSIZE];

  while ((n = read(STDIN_FILENO, buf, BUFFSIZE)) > 0)
    if (write(STDOUT_FILENO, buf, n) != n)
      app_error("write error");

  if (n < 0)
    app_error("read error");

  exit(0);
}
