def ebs(a, b):
    counter = 0
    result = 1
    while b > 0:
        if b % 2 == 1:
            result *= a
        counter += 1
        a *= a
        b = b//2
    return result, counter



def ebs_rec(a, b):
    counter = 0
    if b == 0:
        return 1
    if b % 2 == 1:
        counter += 1
        return a*(ebs_rec(a*a, b//2))
    counter += 1
    return ebs(a*a, b/2), counter

print(ebs(2, 2048))