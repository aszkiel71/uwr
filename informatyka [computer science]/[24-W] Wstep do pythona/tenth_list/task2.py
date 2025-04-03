from task1 import ceasar

def is_ceasar_pair(s1, s2):
    for k in range(1, 33):
        if ceasar(s1, k) == s2:
            return True
    return False


with open("popularne_slowa2023.txt", "r", encoding="utf-8") as file:
    data = {line.strip("\n") for line in file}



max_len = 0
max_words = []

#i = 0
for word in data:
    #print(f"Amount of operations: {i}")
    #i += 1
    if len(word) >= max_len:
        for k in range(1, 33):
            tmp_word = ceasar(word, k)
            if tmp_word in data and tmp_word != word:
                if len(word) > max_len:
                    max_len = len(word)
                    max_words = [word]  #resetowanie
                    print(f"New longest word was found: {word}")
                elif len(word) == max_len:   #dodawanie innych slow tej samej dlugosci
                    if word not in max_words:
                        max_words.append(word)
                        print(f"Word that has the same length as the longest: {word}")


print(f"Max len: {max_len}\nWords:  ")
print("\n".join(max_words))


