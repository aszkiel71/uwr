from math import sqrt # pierwiastek kwadratowy


def potega(a,n):
    wynik = 1  # zmienna lokalna
    for i in range(n):
       wynik = wynik * a   # albo: wynik *= a
    return wynik
   
def kwadrat(n):
    for i in range(n):
        print("*" * n)

def kwadrat2(n):
    for i in range(n):
        print (n * "#")


for i in range(5):
    print(f"Przebieg:{i}")
    print(20 * "-")
    kwadrat(3 + 2 * i)
    print()

for i in range(5, 10):
    print(f"Przebieg: {i}")
    print(20 * "-")
    kwadrat2(i - 2)  # rysujemy kwadrat z hashy o rozmiarze i-2
    print()  # pusty wiersz dla czytelności