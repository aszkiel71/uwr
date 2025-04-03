def silnia(n):
    wynik = 1
    for i in range(1, n+1):
        wynik *= i
    return wynik


# 1 cyfr
# 2 cyfry
# 3 cyfry
# 4 cyfry
# 5 cyfr
# 6 cyfr
# 7 cyfr
# 8 cyfr
# 9 cyfr
# 10 cyfr


def koncowka(n):
    if len(str(silnia(n))) % 10 == 2 or len(str(silnia(n))) % 10 == 3 or len(str(silnia(n))) % 10 == 4:
        if len(str(silnia(n))) % 100 == 12 or len(str(silnia(n))) % 100 == 13 or len(str(silnia(n))) % 100 == 14:
            return False
        return True
    return False


for i in range(4, 101):
    if koncowka(i):     print(f"{i}! ma {len(str(silnia(i)))} cyfry")
    else:               print(f"{i}! ma {len(str(silnia(i)))} cyfr")
