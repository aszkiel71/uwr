def selection_sort(a, n):
    counter = 0
    for i in range(n):
        min_index = i
        for j in range(i+1, n):
            if a[j] < a[min_index]:
                min_index = j

        counter += 1
        a[i], a[min_index] = a[min_index], a[i]
    return a, counter

k = 1000
array = []
for i in range(1000):
    array.append(i)

print(selection_sort(array, k))

