def podziel(s):
    s = s + " "
    splited = []
    word = ''
    switcher = 1
    for i in s:
        if i == ' ':
            splited.append(word)
            word = ""
            switcher = 0

        else:             switcher = 1

        if switcher == 1:
            word += i
    result = []
    for i in splited:
        if i != "":
            result.append(i)
    return result
print(podziel("   Askasj siema sa a      saAS  ssalk"))