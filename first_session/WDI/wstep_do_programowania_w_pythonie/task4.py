from losowanie_fragmentow import losuj_fragment
#for i in range(5):
    #print(losuj_fragment())

def losuj_haslo(n):
    haslo = ""
    while n != len(haslo):
        left = n - len(haslo)
        tmp = losuj_fragment()
       # print(left, n, tmp, len(tmp))
        if left >= len(tmp) and left - len(tmp) != 1:
            haslo += tmp
    return haslo

print("Dla n = 8 : ")
for i in range(1, 11):
    print(f"{i}. -> {losuj_haslo(8)}")
print("\nDla n = 10 : ")
for i in range(1, 11):
    print(f"{i}. -> {losuj_haslo(10)}")
