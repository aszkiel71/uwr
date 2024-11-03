def kdigits(n):
    k = [0]*10
    while n > 0:
        k[n%10] += 1
        n = n//10
    result = 0
    for i in range(10):
        if k[i] != 0:
            result += 1
    return result

print(kdigits(101132222222501))



