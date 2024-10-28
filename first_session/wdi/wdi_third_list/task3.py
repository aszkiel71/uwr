n = 17
k = 8

i = 0
if n >= 0:
    while i < k:
        print(n%2)
        n //= 2
        i += 1
else:
    tmp = -1*n
    