import random
import string  # Do obsługi interpunkcji
from collections import defaultdict as dd

pol_ang = dd(lambda: [])

# Wczytywanie słownika polsko-angielskiego
for x in open('pol_ang.txt', encoding='utf-8'):
    x = x.strip()
    L = x.split('=')
    if len(L) != 2:
        continue
    pol, ang = L
    pol_ang[pol].append(ang)

# Funkcja do wczytywania częstości słów z brown.txt
def wczytaj_czestosc_brown(plik_brown):
    czestosc = dd(int)  # Defaultowo na 0
    for line in open(plik_brown):
        for word in line.strip().split():
            czestosc[word.lower()] += 1
    return czestosc

# Częstości słów z pliku brown.txt
czestosc_brown = wczytaj_czestosc_brown('brown.txt')

# Funkcja tłumacząca z preferencją dla popularnych słów
def tlumacz(polskie):
    wynik = []
    for s in polskie:
        slowo = s.strip(string.punctuation)
        interpunkcja = s[len(slowo):]

        if slowo in pol_ang:
            mozliwe = pol_ang[slowo]
            mozliwe.sort(key=lambda x: czestosc_brown[x.lower()], reverse=True)
            max_czestosc = czestosc_brown[mozliwe[0].lower()]
            najczestsze = [x for x in mozliwe if czestosc_brown[x.lower()] == max_czestosc]
            przetlumaczone = random.choice(najczestsze)
            wynik.append(przetlumaczone + interpunkcja)
        else:
            wynik.append(s)
    return ' '.join(wynik)

# Przykładowe zdanie do tłumaczenia
zdanie = 'Man kochać sport i mleko, innit, eratostenes, sito, siev, Polska.'.split()

print(tlumacz(zdanie))
