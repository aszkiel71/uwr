def usun_duplikaty(L):
    pairs = []
    for i in range(len(L)):
        pairs.append((i, L[i]))

    # sortowanie po wartosicach (po drugiej wartosci w krotce (tablicy dwuwymiarowej))
    for i in range(len(pairs)):
        for j in range(i + 1, len(pairs)):
            if pairs[i][1] > pairs[j][1]:
                pairs[i], pairs[j] = pairs[j], pairs[i]

    # usuwanie duplikatow
    without_duplicates = []
    last_value = None
    for index, value in pairs:
        if value != last_value:
            without_duplicates.append((index, value))
            last_value = value

    # sorotwanie po indeksach
    for i in range(len(without_duplicates)):
        for j in range(i + 1, len(without_duplicates)):
            if without_duplicates[i][0] > without_duplicates[j][0]:
                without_duplicates[i], without_duplicates[j] = without_duplicates[j], without_duplicates[i]

    result = []
    for index, value in without_duplicates:
        result.append(value)

    return result


print(usun_duplikaty([1, 2, 3, 3, 11, 1, 2, 3, 8, 2, 2, 2, 9, 9, 4]))
