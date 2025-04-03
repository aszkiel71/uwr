def factorial_representation(n):

    factorials = []
    i, fact = 1, 1
    while fact <= n:
        factorials.append(fact)
        i += 1
        fact *= i

    representation = []
    for fact in reversed(factorials):
        j = n // fact
        representation.append(j)
        n %= fact




    return representation


n = 1000
print(f"Silniowa reprezentacja liczby {n} to: {factorial_representation(n)}")
