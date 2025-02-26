#include <iostream>

using namespace std;

int x, y;

void ext_euklides(int a ,int b){
  if (b!=0){
    ext_euklides(b, a%b);
    int hlp = y;
    y = x - a/b*y;
    x = hlp;

  }
}

int gcd(int a, int b)
{
  if (b==0) return a;
  return gcd(b, a%b);
}

int main() {
    int t;
    cin>>t;
    while(t--) {
      x = 1, y = 0;
      int a, b;
      cin>>a>>b;
      ext_euklides(a, b);
      cout<<x<<" "<<y<<" "<<gcd(a, b)<<endl;
    }
    return 0;
}
