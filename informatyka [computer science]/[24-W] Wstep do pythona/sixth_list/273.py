def p(n):
    if n == 1:  return 0.3
    if n > 1:   return p(1) + 0.7*p(n-1)



def koniunkcja(m, n):
    if m and n:     return True
    return False

def alternatywa(m, n):
    if m or n:      return True
    return False

def implikacja(m, n):
    return alternatywa(not m, n)

def rownowaznosc(m, n):
    if m == n:  return True
    return False

def nand(m, n):
    return not koniunkcja(m, n)

p, q = 1, 1
phi = rownowaznosc(not (alternatywa(p, q)), koniunkcja(not p, not q))

print(phi)