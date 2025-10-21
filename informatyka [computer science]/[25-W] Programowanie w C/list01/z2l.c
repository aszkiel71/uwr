#include <stdio.h>
#define ll long long



int rev[15];

int solve(ll x) {
  if (x % 10 == 0) {
    return 0;
  }

  ll dummy = x;
  int ptr = 14;

  while (x > 0) {
    int rem = x % 10;
    x /= 10;
    rev[ptr] = rem;
    ptr--;
  }

  int dyszka = 1;
  ll sum = dummy;
  ll sum2 = 0;

  for (int i = 1 + ptr; i < 15; i++) {
    sum2 += (ll)(dyszka * rev[i]);
    dyszka *= 10;
  }

  sum = sum + sum2;

  if (sum == 0) return 0;

  while (sum > 0) {
    int remain = sum % 10;
    if (remain % 2 == 0) {
      return 0;
    }
    sum /= 10;
  }
  return 1;
}

int main() {
  ll k;
  scanf("%lld", &k);
  ll cnt = 0;

  for (ll i = 1; i <= k; i++) {
    cnt += solve(i);
  }
  printf("%lld", cnt);
}
