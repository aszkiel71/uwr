#include <iostream>

using namespace std;

void ext_euklides(long long a, long long b, long long &x, long long &y) {
    if (b == 0) {
        x = 1;
        y = 0;
    } else {
        ext_euklides(b, a % b, x, y);
        long long temp = x;
        x = y;
        y = temp - (a / b) * y;
    }
}

long long mod_inv(long long a, long long m) {
    long long x, y;
    ext_euklides(a, m, x, y);
    return (x % m + m) % m;
}

int main() {
    ios_base::sync_with_stdio(0);
    cin.tie(0);
    cout.tie(0);

    int t;
    cin >> t;
    cout << mod_inv(55, 7) << endl;
    while (t--) {
        int k;
        cin >> k;

        int p[k], a[k];
        long long M = 1;


        for (int i = 0; i < k; i++) {
            cin >> p[i] >> a[i];
            M *= p[i];
        }

        long long A = 0;


        for (int i = 0; i < k; i++) {
            long long tmp_n = M / p[i];
            long long tmp_inv = mod_inv(tmp_n, p[i]);
            A += a[i] * tmp_n * tmp_inv;  // de facto A = suma ai * ei, gdzie ei = M/p[i] * (M/p[i])^-1 w pierscieniu p[i]
            A = A % M;

        }

        cout << A % M << "\n";
    }

    return 0;
}
