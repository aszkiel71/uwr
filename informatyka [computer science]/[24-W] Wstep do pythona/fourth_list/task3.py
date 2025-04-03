import random

# https://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle

def randperm(n):
    randlist = list(range(n))
    for i in range(0, n, 1):
        j = random.randint(0, i)
        randlist[i], randlist[j] = randlist[j], randlist[i]
    return randlist

print(randperm(10**6))
