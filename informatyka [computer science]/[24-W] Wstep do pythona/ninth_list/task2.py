from collections import defaultdict, Counter
#from itertools import combinations

def load_file(file):
    words = []
    with open(file, "r", encoding="utf-8") as f:
        for line in f:
            words.append(line.strip().lower())
    return words

def znajdz_zagadke_trzy(name, words):
    name = name.lower().replace(" ", "")
    name_counter = Counter(name)

    word_dict = defaultdict(list)
    for word in words:
        key = ''.join(sorted(word))
        word_dict[key].append(word)


    for word1 in words:
        remaining_letters1 = name_counter - Counter(word1)
        if not remaining_letters1:
            continue
        for word2 in words:
            if word1 == word2:
                continue
            remaining_letters2 = remaining_letters1 - Counter(word2)
            if not remaining_letters2:
                continue

            remaining_key = ''.join(sorted(remaining_letters2.elements()))
            if remaining_key in word_dict:
                for word3 in word_dict[remaining_key]:
                    if Counter(word1 + word2 + word3) == name_counter:
                        return f"{word1.capitalize()} {word2.capitalize()} {word3.capitalize()}"

    return "No solution"

# Testowanie
if __name__ == "__main__":
    words = load_file("popularne_slowa2023.txt")
    name = "Bolesław Prus"
    print(znajdz_zagadke_trzy(name, words))
