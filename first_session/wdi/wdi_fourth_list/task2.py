def nwd(n, m):
    if n < m:
        k = m
        m = n
        n = k
    while m > 0:
        k = n % m
        n = m
        m = k
    return n

def nww(n, m):
    return((n*m)/(nwd(n, m)))

def irreducible(a, b):
    return(a/nwd(a, b), b/nwd(a, b))

