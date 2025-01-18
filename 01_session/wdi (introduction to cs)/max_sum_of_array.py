def max(n, a):
    i = 0
    s = 0
    n = len(a)
    ms = a[0]
    while i < n:
        s += a[i]
        if s > ms:      ms = s
        i += 1
    return ms

