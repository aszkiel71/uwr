#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <time.h>

// Naive modular reduction counter
int mod_reduce(uint64_t *a, uint64_t b) {
    int reductions = 0;
    if (*a >= b) {
        *a = *a % b;


        reductions = 1;
    }
    return reductions;
}

// Fast modular exponentiation with timing side-channel
uint64_t fast_pow(uint64_t base, uint64_t d, uint64_t N, int *mul_count) {
    uint64_t result = base;
    int reductions = 0;
    int h = 0;

    int len = 64 - __builtin_clzll(d);
    for (int j = 1; j < len; j++) {
        result = (result * result);
        reductions += mod_reduce(&result, N);

        if ((d >> (len - j - 1)) & 1) {
            result = result * base;
            (*mul_count)++;  // Count multiplication for timing leak
            reductions += mod_reduce(&result, N);
            h++;
        }
    }
    return result;
}

// RSA decryption wrapper for timing
uint64_t dec(uint64_t c, uint64_t d, uint64_t N, int *mul_count) {
    return fast_pow(c, d, N, mul_count);
}

// Simulated attack: collect decrypt timings
void timing_attack(uint64_t d_real, uint64_t N) {
    uint64_t message = 123;
    int trials = 100;
    int guessed_bits = 0;

    printf("Bit position | Avg muls (bit=1) | Avg muls (bit=0) | Guessed bit | Actual bit\n");
    printf("--------------------------------------------------------------------------\n");

    for (int i = 0; i < 16; i++) {
        int count1 = 0, sum1 = 0;
        int count0 = 0, sum0 = 0;

        for (int j = 0; j < trials; j++) {
            uint64_t d_test0 = d_real & ~((uint64_t)1 << i); // bit=0
            int mul_count0 = 0;
            dec(message, d_test0, N, &mul_count0);
            sum0 += mul_count0;
            count0++;

            uint64_t d_test1 = d_real | ((uint64_t)1 << i); // bit=1
            int mul_count1 = 0;
            dec(message, d_test1, N, &mul_count1);
            sum1 += mul_count1;
            count1++;
        }

        float avg1 = (float)sum1 / count1;
        float avg0 = (float)sum0 / count0;
        int actual_bit = (d_real >> i) & 1;
        int guessed_bit = (avg1 > avg0) ? 1 : 0;

        if (guessed_bit == actual_bit) {
            guessed_bits++;
        }

        printf("Bit %2d       |     %.2f       |     %.2f       |      %d       |     %d\n",
               i, avg1, avg0, guessed_bit, actual_bit);
    }

    printf("\nSummary: Guessed %d / 16 bits of private exponent d correctly.\n", guessed_bits);
}


int main() {
    // Use fixed primes for simplicity
    uint64_t p = 499;
    uint64_t q = 547;
    uint64_t N = p * q;
    uint64_t phi = (p - 1) * (q - 1);
    uint64_t e = 65537;

    // Compute modular inverse d (private exponent)
    uint64_t d = 93713;  // Precomputed for this p, q, e

    // Run timing attack
    timing_attack(d, N);

    return 0;
}
