def ebs(a, b):
    # niezmiennik -> result = a^(b-k)
    # O(n) = log(n)
    n,k = a, b
    result = 1
    #print(result, a**(b-k))
    while k != 0:
        if k % 2 != 0:
            result *=n
            k -= 1
        else:
            n *= n
            k = k//2
    #print(result, a ** (b - k))
    return result

print(ebs(2,155))