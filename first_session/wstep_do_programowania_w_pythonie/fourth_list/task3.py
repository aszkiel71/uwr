import random

def randperm(n):
    randlist = list(range(n))
    for i in range(0, n-1, 1):
        j = random.randint(0, i)
        randlist[i], randlist[j] = randlist[j], randlist[i]
    return randlist

print(randperm(10))
