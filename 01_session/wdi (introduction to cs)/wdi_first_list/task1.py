tab = [14, 125, -5, 6]
i = 0
result = tab[0]

while i < 4:
    if tab[i] < result: 
        result = tab[i]
    i += 1
print(result)
