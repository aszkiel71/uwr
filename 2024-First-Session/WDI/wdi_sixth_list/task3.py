def bubble_sort(a, n):
    counter = 0
    for i in range(n):
        for j in range(n-i-1):
            if a[j] > a[j+1]:
                counter += 1
                a[j], a[j+1] = a[j+1], a[j]
    return a, counter

k = 1000
array = []
for i in range(1000):
    array.append(i)

print(bubble_sort(array, k))