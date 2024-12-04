from task2 import czy_ukladanka, rozklad


words = []
words_file = open("popularne_slowa2023.txt", "r", encoding="utf-8")
for line in words_file:
    words.append(line.strip('\n'))

def minus(s1, s2):
    res = ""
    rozklad_s1 = rozklad(s1)
    rozklad_s2 = rozklad(s2)
    for i in rozklad_s1:
        rozklad_s1[i] -= rozklad_s2[i]
    for i in rozklad_s1:
        tmp = rozklad_s1[i]
        res += tmp*i
    return res



def zagadka(name):
    tmp = name
    puzzle = ""
    counter = 0
    iteration = 0
    while True:
        if name in (" ", ""):
            break
        for i in words:
            if name in (" ", ""):
                break
            print(iteration, name, puzzle)
            iteration = iteration + 1
            if czy_ukladanka(name, i):
                puzzle += i
                puzzle += " "
                name = minus(name, i)
            if iteration == len(words):
                break
        return puzzle + name

if __name__ == "__main__":
    print(zagadka("Sławomir Nitras"))

