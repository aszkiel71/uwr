T = ['a', 'b', 'a', 'a', 'c', "a"]
n = 6
n = n - 1
x = 'a'
counter = 0

while n >= 0:
    if x == T[n]:
        counter += 1
    n -= 1
print(counter)
