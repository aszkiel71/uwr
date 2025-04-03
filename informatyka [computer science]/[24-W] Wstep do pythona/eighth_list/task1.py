import random
import string
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
    czestosc = dd(int)  # Defaultowo na 0
    for line in open(plik_brown):
        for word in line.strip().split():
            czestosc[word.lower()] += 1
    return czestosc


czestosc_brown = wczytaj_czestosc_brown('brown.txt')


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

zdanie = 'być czy nie to być, kochać piłka ręka'.split()

print(tlumacz(zdanie))
