from task2 import nwd


def max_factor(n, a):
    result = a[0]
    for i in range(n):
        result = nwd(a[i], result)
    return result
print(max_factor(6, [25, 25, 125, 25, 10, 15]))

