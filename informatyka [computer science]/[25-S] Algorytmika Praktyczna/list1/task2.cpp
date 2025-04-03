#include <iostream>
#include <vector>
using namespace std;

const long long MOD = 1000000007;
const int MAX_N = 1000000;

vector<long long> fact(MAX_N + 1, 1);
vector<long long> inv_fact(MAX_N + 1, 1);

int x = 1, y = 0;
void ext_euklides(int a, int b) {
    if (b != 0) {
        ext_euklides(b, a % b);
        int hlp = y;
        y = x - (a / b) * y;
        x = hlp;
    }
}

long long mod_inv(long long a, long long m) {
    x = 1, y = 0;
    ext_euklides(a, m);
    return (x % m + m) % m;
}

void precompute_factorials() {
    for (long long i = 2; i <= MAX_N; i++) {
        fact[i] = (fact[i - 1] * i) % MOD;
    }
    inv_fact[MAX_N] = mod_inv(fact[MAX_N], MOD);
    for (long long i = MAX_N - 1; i >= 1; i--) {
        inv_fact[i] = (inv_fact[i + 1] * (i + 1)) % MOD;
    }
}

long long binomial_theorem(long long a, long long b, long long p) {
    if (b > a)      return 0;
    return (((fact[a] * inv_fact[b]) % p) * inv_fact[a - b]) % p;
}

int main() {
    ios::sync_with_stdio(0);
    cin.tie(0);
    cout.tie(0);


    precompute_factorials();

    int t;
    cin >> t;
    while (t--) {
        long long a, b;
        cin >> a >> b;
        cout << binomial_theorem(a, b, MOD) << "\n";
    }
    return 0;
}