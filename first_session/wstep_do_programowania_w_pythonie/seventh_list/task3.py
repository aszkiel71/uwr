def is_polish_character_in_word(word):
    polish_character = "ąćęłńóśżź"
    for i in word:
        if i.lower() in polish_character:   return True
    return False

tmp = []
with open("lalka-tom-pierwszy.txt", "r", encoding='utf-8') as file:
    for line in file:
        tmp.append(line.strip())

text = []
switcher = 1
tmp2 = ""

for i in range(len(tmp)):
    if switcher == 0:
        text.append(tmp2)
        tmp2 = ""
        switcher = 1
    for j in range(len(tmp[i])):
        # when switcher 0 we can add another word
        if tmp[i][j] in (" ", "", ",", "."):        switcher = 0
        if switcher == 1:           tmp2 += tmp[i][j]
        if switcher == 0:
            text.append(tmp2)
            tmp2 = ""
            switcher = 1
        if j == len(tmp[i]) - 1:
            switcher = 0



max_len = 0
max_portion = ""
tmp_max_len = 0
tmp_max_portion = ""



for i in text:
    if not is_polish_character_in_word(i):
        tmp_max_len += len(i)
        tmp_max_portion += i
        tmp_max_portion += " "
        if tmp_max_len > max_len:
            max_len = tmp_max_len
            max_portion = tmp_max_portion
    else:
        tmp_max_portion = ""
        tmp_max_len = 0


print(f"Najdluzszy fragment ma {max_len} znakow, a ten fragment to : \n{max_portion}")

#print(len(max_portion))