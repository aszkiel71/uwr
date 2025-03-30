# WOJCIECH ASZKIEŁOWICZ ZADANIE 1 LISTA 1
# pycharm (nieistotne)
# na poczatku imperatywnie

def silnia_imp(n):
    res = 1
    for i in range(1, n+1):
        res *= i
    return res


# funkcjonalnie

def silnia_fun(n):
    return 1 if n == 0 or n == 1 else silnia_fun(n - 1) * n

# symbol newtona, imperatywnie

def binom_imp(n, k):
    return silnia_imp(n) // (silnia_imp(k) * silnia_imp(n - k))

# symbol newtona, funkcjonalnie

def binom_fun(n, k):
    return 1 if k == 0 or k == n else binom_fun(n - 1, k - 1) + binom_fun(n - 1, k)

# wypisanie n-tego wierszy pascala

def pascal_row(n):
    row = []
    for k in range(n + 1):
        row.append(binom_imp(n, k))
    return row

def display_pascal_row(n):
    return pascal_row(n)


print(display_pascal_row(5))
print(display_pascal_row(6))
print(display_pascal_row(132))
