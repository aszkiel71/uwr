import matplotlib.pyplot as plt
import random
import math

from collections import defaultdict as dd


def permutuj(N):
    L = list(range(N))
    random.shuffle(L)
    return tuple(L)


def nasz_permutuj(N):
    L = list(range(N))

    for n in range(2 * N):
        i = random.randint(0, N - 1)
        j = random.randint(0, N - 1)
        L[i], L[j] = L[j], L[i]
    return tuple(L)


licznik = dd(int)
M = 100000

for i in range(M):
    # licznik[permutuj(4)] += 1
    licznik[nasz_permutuj(4)] += 1

etykiety = []
wartosci = []

for k, v in licznik.items():
    etykiety.append(str(k))
    wartosci.append(v)

plt.bar(etykiety, wartosci, width=0.8, alpha=1)
plt.xticks(rotation=90)
plt.show()