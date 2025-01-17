def square_sum(i, j):
    return i*i + j*j


def task4(n):
    results = [0]*n
    #T.C. = O(sqrt(n) * sqrt(n) + n) = O(2n) = O(n)
    i, j = 1, 1
    for k in range(1, n):
        for l in range(1, n):
            if square_sum(i, l) < n:
                results[square_sum(i, l)] = 1
            j += 1
            l = l*l
        i += 1
        k = k*k

    # T.C. := O(n)
    for i in range(n):
        if results[i] == 1:
            print(i)


print(task4(9))