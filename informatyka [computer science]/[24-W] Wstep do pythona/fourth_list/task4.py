def is_palindrom(n):
    if str(n) == str(n)[::-1]:
        return True
    return False

def sito_eratostenesa(n):
    numbers = [0] * (n + 1)
    numbers[0], numbers[1] = 1, 1

    for i in range(2, n + 1):
        if numbers[i] == 0:
            for j in range(i * 2, n + 1, i):
                numbers[j] = 1

    return numbers



def palindromy(a, b):
    if a > b:
        a += 1
    else:
        b += 1

    tab = sito_eratostenesa (max(a, b))
    result = []
    for i in range(min(a, b), max(a, b), 1):
        if tab[i] == 0 and is_palindrom(i):
            result.append(i)
    return result
print(palindromy(10**8, 2))