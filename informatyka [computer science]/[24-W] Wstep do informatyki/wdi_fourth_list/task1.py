def result1(n):
    if n%2 == 0:    return n
    else:           return -n

def result2(n):
    i = 1
    result = 0
    while i <= n:
        if i % 2 == 0: result += (1/i)
        else:          result -= (1/i)
        i += 1
    return result

def ebs(x, n):
    result = 1
    while n > 0:
        if n % 2 == 1:
            result *= x
        x *= x
        n //= 2
    return result

def result3(n, x):
    i = 1
    result = 0
    while i <= n:
        result += (i*ebs(x, i))
        i += 1
    return result

