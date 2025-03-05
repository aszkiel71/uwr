# WOJCIECH ASZKIEŁOWICZ ZADANIE 2        LISTA 1
# pycharm (nieistotne)
# imperatywnie
#
# pokazujemy jak ma program sie wykonac i jak sie zmieniaja dane

def gcd_imp(a, b):
    while b != 0:
        a, b = b, a%b
    return a

# funkcyjnie
#
# opisujemy tak jakby co chcemy osiagnac, a nie jak to osiagnac (mniej wiecej)
# rekurencja zamiast petli


def gcd_fun(a, b):
    return a if b == 0 else gcd_fun(b, a%b)


# to byly gcd
# teraz wzglednie pierwsze z 'n' mniejsze rowne 'n'

def coprime_imp(n):
    res = []
    for k in range(1, n+1):
        if gcd_imp(k, n) == 1:
            res.append(k)
    return res

def coprime_fun(n):
    return [k for k in range(1, n+1) if gcd_fun(n, k) == 1]

# test cases:

print(coprime_imp(10))
print(coprime_fun(10))
print(coprime_imp(29))
print(coprime_fun(29))

# nie wiem czy dobrze rozumiem polecenie wiec jakby co to ponizej inna wersja: wypisujemy wszystkie pary p, q <= n t.z. gcd(p, q) = 1
# jezeli juz wyzej dobrze zoruzmiaome poelcenie to dalsza czesc mozna zignorowac, dodaje ją dla pewnosci

def coprime_pairs_imp(n):
    result = []
    for p in range(1, n + 1):
        for q in range(1, n + 1):
            if gcd_imp(p, q) == 1:
                result.append((p, q))
    return result

def coprime_pairs_fun(n):
    return [(p, q) for p in range(1, n + 1) for q in range(1, n + 1) if gcd_fun(p, q) == 1]

print(coprime_pairs_imp(10))
print(coprime_pairs_fun(10))



