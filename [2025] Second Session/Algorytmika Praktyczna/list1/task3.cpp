#include <iostream>
#include <cmath>
#include <map>

using namespace std;


bool isPrime(int n){
    if(n < 2) return false;
    if (n == 2) return true;
    if (n % 2 == 0) return false;
    for (int i = 3; i <= sqrt(n); i += 2) {
        if (n % i == 0) return false;
    }
    return true;
}


int am_of_divisors(int n)
{


    if(isPrime(n)) return 2;
    map<int, int> factorization;


    for (int i = 2; i <= sqrt(n); i++)
    {
        while (n % i == 0)
        {
            n /= i;
            factorization[i]++;
        }
    }
    if (n > 1)
    {
        factorization[n]++;
    }

    int res = 1;
    for (const auto &it: factorization)
    {
        res *= (it.second + 1);
    }
    return res;
}


    int main() {
        int t;
        cin>>t;
        while(t--){
            int n;
            cin>>n;
            cout<<am_of_divisors(n)<<endl;
        }
        return 0;
    }

