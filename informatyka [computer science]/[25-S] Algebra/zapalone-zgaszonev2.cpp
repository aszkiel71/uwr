/*Zadanie 9. Rozważmy grę, rozgrywającą się na prostokątnej planszy n × 1. Na wejściu każde pole jest
zapalone lub zgaszone. W pojedynczym ruchu możemy dotknąć konkretnego pola, co powoduje zmianę (tj.
z zapalonego na zgaszone i odwrotnie) na tym polu i na sąsiednich. Celem gry jest zgaszenie wszystkich pól.
Dla jakich wartości n wygrana jest zawsze możliwa?
Podaj prosty algorytm, który rozwiązuje grę, jeśli jest to możliwe (istnieje algorytm zachłanny.)
*/

#include <iostream>
using namespace std;
void display(bool plansza[], int n){
    for(int i=0;i<n;i++)
        cout << plansza[i] << " ";
}

bool isWin(bool plansza[], int n){
    for(int i=0;i<n;i++)
    {
        if(!plansza[i])
            return false;
    }
    return true;
}



int main() {
    ios_base::sync_with_stdio(false);
    cin.tie(nullptr);
    cout.tie(nullptr);
    int n; cin >> n;
    bool plansza[n] = {false};
    int counter = 0;
    bool flague = 1;
    while (!isWin(plansza, n))
    {

        for(int i=0;i<n;i++){
            if(isWin(plansza,n))
            {
                break;
            }
            if (!plansza[i]){
              if(i == 0){
                plansza[i+1] = !plansza[i+1];
                plansza[i] = true;
              }
              else{
                if(i < n){
                plansza[i] = true;
                plansza[i+1] = !plansza[i+1];
                if(i < n-1){
                  plansza[i+2] = !plansza[i+2];
                }
              }
            }
        }
            counter++;
            cout << "okrazenie nr " << counter << "\n";
            display(plansza, n); cout << endl;
    }


    }



    return 0;
}
