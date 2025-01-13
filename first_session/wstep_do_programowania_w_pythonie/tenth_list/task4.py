# a)

def subset(L):
    if not L:
        return {0}
    tmp = subset(L[1:])
    return tmp | {L[0] + s for s in tmp}

print(set(sorted(subset([1, 2, 3, 100]))))



# b)
def generate_seq(N, A, B, current = []):

    if A > B:       return generate_seq(N, B, A, current)

    if len(current) == N:       return [current]

    seq = []

    if current:     start = current[-1]
    else:           start = A

    for i in range(start, B + 1):
        seq.extend(generate_seq(N, A, B, current+[i]))
    return seq

for i in generate_seq(3, 1, 2):
    print(i)




""" 
a)
dla L = 1, 2, 3, 100:
wywolujemy dla [2, 3, 100]
dla L = [2, 3, 100]:
wywolujemy dla [3, 100]
dla L = [3, 100]:
wywolujemy dla [100]
dla L = [100]
wywolujemy dla []
dla L = []
zwracamy {0}

laczymy wyniki:
100 + s for s in {0}, laczymy razem z tmp czyli {0, 100}
nastepenie tmp = {0, 100}
potem 3 + s for s in {0, 100} czyli {3, 103}
zwracamy {0, 3, 100, 103}
nastepnie tmp = {0, 3, 100, 103}
potem 2 + s for s in {0, 3, 100, 103} = {2, 5, 102, 105}
zwracamy {0, 2, 3, 5, 100, 102, 103, 105}
potem tmp ^^^^
1 + s for s in {0, 2, 3, 5, 100, 102, 103, 105}} = P1, 3, 4, 6, 101, 103, 104, 106}
zwracamy {0, 1, 2, 3, 4, 5, 6, 100, 101, 102, 103, 104, 105, 106}
"""



"""
b)
(I)
current = [], start = 1
(II)
current = [1], start = 1
(III)
current = [1, 1], start = 1
(IV)
current = [1, 1, 1], len() == N, return : [1, 1, 1]

"""
