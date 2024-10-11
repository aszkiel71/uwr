S = ['a', 'b']
T = ['a', 'a', 'b', 'c', 'd', 'a', 'b', 'a', 'D', 'a', 'b']
m = 1 # 2
n = 7 # 8
tmp = 0
counter = 0

for i in range(n-m):
    tmp_2 = i
    for j in range(m):
        if T[tmp_2] == S[j]:
            tmp = 1
        else:
            tmp = 0
    if tmp == 1:
        counter += 1

print(counter)