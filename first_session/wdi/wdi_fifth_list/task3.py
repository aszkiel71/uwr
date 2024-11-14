def gcd(n, m):
    if n == 0:
        return m
    if m == 0:
        return n



    result = 1

    while n != m:
        if n < m:
            n, m = m, n

        if n % 2 == 0 and m % 2 == 0:
            n //= 2
            m //= 2
            result *= 2
        elif n % 2 == 0:
            n //= 2
        elif m % 2 == 0:
            m //= 2
        else:
            n -= m


    print(n, result)
    return n*result

print(gcd(15, 125))