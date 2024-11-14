def task7(n, m):
    if m <= 1:
        return 0

    i = 0
    power = n
    while power < m:
        i += 1
        power = power ** 2  # n^(2^i)


    low = 2 ** (i - 1)
    high = 2 ** i


    while low < high:
        mid = (low + high) // 2
        if n ** mid >= m:
            high = mid
        else:
            low = mid + 1

    return low

