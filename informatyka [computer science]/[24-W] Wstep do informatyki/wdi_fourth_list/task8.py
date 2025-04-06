def is_similar(m, n):
    a = [0]*10
    b = [0]*10
    while m > 0:
        a[m%10] += 1
        m=m//10
    while n > 0:
        b[n%10] += 1
        n=n//10
    for i in range(10):
        if a[i] != b[i]:
            return False
    return True

print(is_similar(131342,21133))