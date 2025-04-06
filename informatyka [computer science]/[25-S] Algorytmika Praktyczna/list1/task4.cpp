#include <iostream>

using namespace std;


int ebs(int a, int n) {
    int result = 1;
    while (n > 0) {
        if (n % 2 == 1) {
            result = (result * a);
        }
        a = (a * a);
        n /= 2;
    }
    return result;
}

int isPrime(int n){
    if (n < 2)
        return false;
    if (n == 2 || n == 3)
        return true;
    if (n % 2 == 0 || n % 3 == 0)
        return false;
    for (int i = 5; i * i <= n; i += 6)
    {
        if (n % i == 0 || n % (i + 2) == 0)
            return false;
    }
    return true;
}


int gcd(int a, int b)
{
    if (b == 0)
        return a;
    return gcd(b, a % b);
}

bool isPrimePower(int n) {
    for (int p = 2; p * p <= n; p++) {
        if (n % p == 0) {
            while (n % p == 0)
                n /= p;
            return n == 1;
        }
    }
    return false;
}

int phi(int n) {
    if (n == 1)
        return 1;
    if (isPrime(n))
        return n - 1;

    if (isPrimePower(n)) {
        int p = 2;
        while (n % p != 0)
            p++;
        int k = 0, temp = n;
        while (temp % p == 0) {
            temp /= p;
            k++;
        }
        return ebs(p, k) - ebs(p, k - 1);
    }

    int a = 2;
    while (a < n / 2) {
        int b = n / a;
        if (gcd(a, b) == 1 && n % a == 0) {
            return phi(a) * phi(b);
        }
        a++;
    }
}



int main() {
    int t;
    cin>>t;
    while(t--) {
        int n;
        cin>>n;
        cout << phi(n) << endl;
    }
    return 0;
}
