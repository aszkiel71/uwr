x = int(input("Podaj pierwsza liczbe : "))
y = int(input("Podaj druga liczbe : "))
result = 0

if x > y:
    bigger = x
    smaller = y
else:
    bigger = y
    smaller = x

tmp = smaller

while smaller <= bigger:
    if smaller == bigger:
        result = 1
    smaller += tmp

print(result)
