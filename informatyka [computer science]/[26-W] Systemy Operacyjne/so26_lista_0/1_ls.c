#include "csapp.h"
#include <dirent.h>

int main(int argc, char *argv[]) {
  DIR *dp;
  struct dirent *dirp;

  if (argc != 2)
    app_error("usage: ls directory_name");

  if ((dp = opendir(argv[1])) == NULL)
    app_error("can't open %s", argv[1]);
  while ((dirp = readdir(dp)) != NULL)
    printf("%s\n", dirp->d_name);

  closedir(dp);
  exit(0);
}
