slowa = []
with open("popularne_slowa2023.txt", "r", encoding ='utf8') as file:
    for line in file:
        slowa.append(line.strip())

def rozklad(a):
    result = ""
    for i in a:
        result += i
    result2 = ""
    for i in sorted(result):
        result2 += i
    return result2

anagramy = {}
for slowo in slowa:
    klucz = rozklad(slowo)
    if klucz in anagramy:
        anagramy[klucz].append(slowo)
    else:
        anagramy[klucz] = [slowo]

wyniki = []
for klucz, lista_slow in anagramy.items():
    if len(lista_slow) >= 5:
        wyniki.append(lista_slow)

for grupa in wyniki:
    for slowo in grupa:
        print(slowo, end=" ")
    print()
