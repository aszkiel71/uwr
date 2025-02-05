def z2(n,k):
    if k>=n:
        return 1
    if n % k==0 and k>1:
        return 1+z2(n/k, k)
    return z2(n,k+1)

print(z2(10, 1))
print(z2(10, 2))
print(z2(30, 1))
print(z2(72, 1))
print(z2(2048, 1))
print(z2(2048, 4))

def z2b(n):
    return z2(n, 1)
# wyjscie: liczba niekoneicznie roznych dzielnikow pierwszych w rozkladzie na czynniki pierwsze

