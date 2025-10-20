#include <stdbool.h>
#include <stdio.h>
bool sieve[1000002];
int ps[1000002];
void compute_sieve() {
  sieve[0] = 1;
  sieve[1] = 1;
  sieve[2] = 0;
  for (int i = 2; i * i < 1000002; i++) {
    if (!sieve[i]) {
      for (int j = i * i; j < 1000002; j += i) {
        sieve[j] = 1;
      }
    }
  }
}

void compute_ps() {
  ps[0] = 0;
  for (int i = 1; i < 1000002; i++) {
    ps[i] = ps[i - 1] + !sieve[i];
  }
}

void solve() {
  int a, b;
  scanf("%i%i", &a, &b);
  int res = ps[b] - ps[a - 1];
  printf("%i\n", res);
}

int main() {
  int q;
  scanf("%i", &q);
  compute_sieve();
  compute_ps();
  while (q--) solve();
}
