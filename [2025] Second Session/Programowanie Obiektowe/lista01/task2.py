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
