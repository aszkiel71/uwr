def G(n):
    if n == 0 or n == 1 or n == 2:
        return 1
    a, b, c = 1, 1, 1

    for i in range(3, n+1):
        next_value = a + b + c
        a, b, c = b, c, next_value

    return c

print(G(258))