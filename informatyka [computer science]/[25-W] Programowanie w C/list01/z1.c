#include <stdio.h>

void solve(int a1, int a2, int a3, int a4, int a5){
  for(int i = 0; i < a2*a4; i++){
      for(int j = 0; j < a1*a3; j++){
	 int x = j / a3, y = i/a4;
	 if((x+y)%2 ^ a5) printf("#"); // x%2 != y%2 := (x+y)%2
	 else printf(" ");
      }
      printf("\n");
  }
}


int main(){
   int a1, a2, a3, a4, a5;
   scanf("%i%i%i%i%i", &a1, &a2, &a3, &a4, &a5);
   // liczba pol (poziom, pion)
   // liczba znakow (poziom, pion)
   // 0, 1 -> lewy gorny zamalowany
   solve3(a1, a2, a3, a4, a5);
}
