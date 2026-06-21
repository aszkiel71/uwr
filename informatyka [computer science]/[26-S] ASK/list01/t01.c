#include <stdio.h>

int main () {
    int i, k, x; scanf("%i%i%i", &x, &i, &k);
    unsigned int bit = x & (1 << i);
    x &= ~(1 << k);
    if (i < k) {
        x |= (bit << (k-i));
    }
    else if (i > k) {
        x |= (bit >> (k-i));
    }
    else x |= bit;
    // one liner:
    // x = (x & ~(1 << k)) | (((x >> i) & 1) << k);
    printf("%d", x);
    return 0;
}
