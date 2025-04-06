#include <iostream>

using namespace std;



long long ebs(long long a, unsigned long long n) {
    long long MOD = 1000000000;
    long long result = 1;
    a %= MOD;

    while (n > 0) {
        if (n % 2 == 1) {
            result = (result * a) % MOD;
        }
        a = (a * a) % MOD;
        n /= 2;
    }
    return result;
}

int main() {
    long long a;
    unsigned long long n;
    cin >> a >> n;
    cout << ebs(a, n);
    return 0;
}
