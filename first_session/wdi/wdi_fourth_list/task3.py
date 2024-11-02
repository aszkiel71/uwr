from task2 import nwd

def max_factor(n, a):
    result = 1
    for i in range(n-1):
        print(a[i], a[i+1], nwd(a[i], a[i+1]))
        if nwd(a[i], a[i+1]) > result:        result = nwd(a[i], a[i+1])
    return result

print(max_factor(3, [25, 125, 15]))