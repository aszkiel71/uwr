x = int(input("Podaj pierwsza wartosc :  "))
y = int(input("Podaj druga wartosc :  "))

def NWD(x, y):

    if x > y:
        bigger = x
        smaller = y
    else:
        smaller = x
        bigger = y
        
    i = 1
    while i <= smaller:
        if bigger % i == 0 and smaller % i == 0:
            tmp_nwd = i
        i += 1

    return(tmp_nwd)
print((x*y)/NWD(x, y))
