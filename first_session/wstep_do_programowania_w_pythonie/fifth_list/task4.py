def usun_duplikaty(L):
    pairs = []
    for i in range(len(L)):
        pairs.append((i, L[i]))

    pairs.sort(key=lambda pairs: pairs[1])  # sorting by values


    without_duplicates = []
    last_value = 0
    for index, value in pairs:
        if value != last_value:
            without_duplicates.append((index, value))
            last_value = value


    without_duplicates.sort()

    result = []
    for index, value in without_duplicates:
        result.append(value)

    return result



print(usun_duplikaty([1, 2, 3, 3, 11, 1, 2, 3, 8, 2, 2, 2, 9, 9, 4]))
