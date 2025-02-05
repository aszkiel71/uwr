def sito(n):
    s = ['']*(n+1)
    S = ['']*((n//2)+1)
    for i in range(n+1):
        s[i] = 1
    s[0] = 0
    s[1] = 0

    i = 2
    while i <= n:
        if s[i] == 1:
            for j in range(2*i, n+1, i):
                s[j] = 0
        i += 1

    ind = 0
    for i in range(n+1):
        if s[i] == 1:
            S[ind] = i
            ind += 1
    return S

