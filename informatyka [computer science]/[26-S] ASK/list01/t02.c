#include <stdio.h>

int main () {
    int x;
    scanf("%d", &x);
    x ^= x >> 16;
    x ^= x >> 8;
    x ^= x >> 4;
    x ^= x >> 2;
    x ^= x >> 1;
    x &= 1;

}
