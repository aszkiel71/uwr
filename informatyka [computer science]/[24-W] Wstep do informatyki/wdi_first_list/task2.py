tab = [14, 2, 55]
max_value = tab[0]
min_value = tab[0]
i = 0

while i < 3:
    if tab[i] < min_value:
        min_value = tab[i]
    if tab[i] > max_value:
        max_value = tab[i]
    i += 1

print(f"Najmniejsza wartosc : {min_value}, najwieksza : {max_value}")
