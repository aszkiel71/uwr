n = -13
k = 8
tmp_n = n

i = 0
tab = [""]*k
tab2 = [""]*k
left = k

if n < 0:
    n = n*-1
while n > 0:
    tab[i] = n%2
    n = n//2
    i+=1
    left -= 1

tmp = left
for i in range(k-left, 0, -1):
    tab2[tmp] = tab[i-1]
    tmp += 1

for i in range(left):
    tab2[i] = 0

tab3 = [""]*k

if tmp_n < 0:
    for i in range(k):
        if tab2[i] == 0:
            tab3[i] = 1
        else:
            tab3[i] = 0


    tmp_k = k-1
    while True:
        if tab3[tmp_k] == 0:
            tab3[tmp_k] = 1
            break
        else:
            tab3[tmp_k] = 0
            tmp_k -= 1

    print(tab3)
else:
    print(tab2)

