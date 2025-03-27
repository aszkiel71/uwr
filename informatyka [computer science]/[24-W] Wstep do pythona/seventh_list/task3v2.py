def is_polish_character_in_word(word):
    polish_character = "ąćęłńóśżź"
    for i in word:
        if i.lower() in polish_character:
            return True
    return False


def is_word_in_popular_list(word, popular_words):
    return word.lower() in popular_words


popular_words = set()
with open("popularne_slowa2023.txt", "r", encoding='utf-8') as file:
    for line in file:
        popular_words.add(line.strip().lower())

with open("lalka-tom-pierwszy.txt", "r", encoding='utf-8') as file:
    text = file.read()

words = text.split()




max_len = 0
max_portion = ""
tmp_len = 0
tmp_portion = ""

for word in words:
    if not is_polish_character_in_word(word) and is_word_in_popular_list(word, popular_words):
        tmp_len += len(word)
        tmp_portion += word + " "
        if tmp_len > max_len:
            max_len = tmp_len
            max_portion = tmp_portion
    else:
        tmp_len = 0
        tmp_portion = ""

print(f"Najdłuższy fragment ma {max_len} znaków, a ten fragment to:\n{max_portion.strip()}")
