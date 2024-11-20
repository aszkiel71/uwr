def zlicz_liczby_dzielnikow(n):
    dzielniki = [0] * (n + 1)
    for i in range(1, n + 1):
        for j in range(i, n + 1, i):
            dzielniki[j] += 1
    return dzielniki[1:]

def zlicz_wystapienia(n):
    tablica = zlicz_liczby_dzielnikow(n)
    wystapienia = {}
    for liczba in tablica:
        if liczba in wystapienia:
            wystapienia[liczba] += 1
        else:
            wystapienia[liczba] = 1
    return sorted(wystapienia.items())

print(zlicz_wystapienia(5*(10**6)))
