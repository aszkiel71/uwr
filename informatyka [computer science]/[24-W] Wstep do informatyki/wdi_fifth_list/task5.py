def T(n, m):
    if n != 0 and m == 0:
        return n
    if n == 0 and m == 0:
        return m
    return T(n-1, m) + 2*T(n, m-1)

def fTrec(n, m):
    pass

