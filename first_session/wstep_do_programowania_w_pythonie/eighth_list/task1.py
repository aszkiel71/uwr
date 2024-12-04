import random
from collections import defaultdict as dd

pol_ang = dd(lambda: [])


for x in open('pol_ang.txt', encoding='utf-8'):
    x = x.strip()
    L = x.split('=')
    if len(L) != 2:
        continue
    pol, ang = L
    pol_ang[pol].append(ang)


def wczytaj_czestosc_brown(plik_brown):
    czestosc = dd(int)  # defaultowo na 0 sie ustawia
    for line in open(plik_brown):
        for word in line.strip().split():
            czestosc[word.lower()] += 1
    return czestosc

# Częstości słów z pliku brown.txt
czestosc_brown = wczytaj_czestosc_brown('brown.txt')

# Funkcja tłumaczaca z preferencja dla popularnych slow
def tlumacz(polskie):
    wynik = []
    for s in polskie:
        if s in pol_ang:
            # Pobiera tłumaczenia i sortuje wg czestosci w brown.txt
            mozliwe = pol_ang[s]
            mozliwe.sort(key=lambda x: czestosc_brown[x.lower()], reverse=True)
            # wybiera najbardziej popularne tlumaczenie lub losuje gdy jest ich tyle samo
            max_czestosc = czestosc_brown[mozliwe[0].lower()]
            najczestsze = [x for x in mozliwe if czestosc_brown[x.lower()] == max_czestosc]
            wynik.append(random.choice(najczestsze))
        else:
            wynik.append(s)  # tu jak nie znajdize tlumaczenia
    return ' '.join(wynik)

# Przykładowe zdanie do tłumaczenia
zdanie = 'Man kochać sport i mleko, innit, eratostenes, sito, siev, Polska'.split()

print(tlumacz(zdanie))


