from task2 import nwd



def max_factor(n, a):
    result = 1
    for i in range(n-1):
        tmp = nwd(a[i], a[i+1])
        if tmp > result:
            for j in range(n):
                if a[j] >= tmp and a[j] % tmp == 0:
                    result = tmp
                else:
                    break

    return result



