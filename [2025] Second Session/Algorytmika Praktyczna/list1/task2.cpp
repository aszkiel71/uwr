#include <iostream>
#define M 1000000007
using namespace std;


int fac(int n)
{
    if (n <= 1)
    {
        return 1;
    }
    return (n * fac(n - 1)) % M;
}

int binomial_theorem(int n, unsigned int k)
{
    if(n==0 || k==0) return 1;
    if(k==1) return n;
    if(k==n) return k;
    return ( fac(n) / (fac(k)*fac(n-k))) % M;

}


int main() {
    int t;
    cin>>t;
    while(t--) {
      int a, b;
      cin>>a >> b;
        cout<<binomial_theorem(a, b)<<endl;
    }
    return 0;
}
