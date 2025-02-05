x = int(input("Podaj pierwsza wartosc :  "))
y = int(input("Podaj druga wartosc :  "))

def modulo(a, b):
    if a > b:
        q = a//b
        return a-q*b
    else:
        q = b//a
        return b-q*a

def NWD(x, y):

    if x > y:
        bigger = x
        smaller = y
    else:
        smaller = x
        bigger = y
        
    i = 1
    while i <= smaller:
        if modulo(bigger, i) == 0 and modulo(smaller, i) == 0:
            tmp_nwd = i
        i += 1

    return(tmp_nwd)
print((x*y)/NWD(x, y))
