#include <iostream>
#include <cmath>
#include <vector>
#include <map>
  using namespace std;


  bool isPrime(int n)
  {
    if (n <= 1)
      return false;
    if (n == 2)
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

  int am_of_f(int n){

    vector<bool> sieve(n/2 +1,true);
    sieve[0] = sieve[1] = false;
    for(int i=2;i<=n/2 +1;i++){
      if(sieve[i]==true){
        for(int j=i*i;j<=n/2 +1;j+=i){
          sieve[j]=false;
        }
      }
    }

    map <int, int> factorization;


    for(int i=2;i<=n;i++){
      if(n == 1)
        break;
      if(sieve[i]==true && (n % i == 0)){
        while(n % i == 0)
        {
          n /= i;
          factorization[i]++;
        }
      }
    }
    int result = 1;
    for(const auto &it : factorization){
      result = result * (it.second + 1);
    }
    return result;
  }



  int main() {
    int t;
    cin>>t;
    while(t--){
      int n;
      cin>>n;
      if(isPrime(n))
      {
        cout << 2 << endl;
      }
      else
        cout << am_of_f(n) << endl;
    }
    return 0;
  }
