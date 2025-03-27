from collections import defaultdict, Counter

def load_file(file):
    words = []
    with open(file, "r", encoding="utf-8") as f:
        for line in f:
            words.append(line.strip().lower())
    return words


def check_point(name, word1, word2):
    combined = word1 + word2
    return sorted(combined) == sorted(name)


def znajdz_zagadke(name, words):
    name = name.lower().replace(" ", "")
    word_dict = defaultdict(list)

    for word in words:
        key = ''.join(sorted(word))
        word_dict[key].append(word)

    for word1 in words:
        remaining_letters = Counter(name) - Counter(word1)
        remaining_key = ''.join(sorted(remaining_letters.elements()))
        if remaining_key in word_dict:
            for word2 in word_dict[remaining_key]:
                if check_point(name, word1, word2):
                    print(f"{word1.capitalize()} {word2.capitalize()}")

    return "No solution"


if __name__ == "__main__":
    words = load_file("popularne_slowa2023.txt")
    name = "Wojtek Aszkiełowicz"
    print(znajdz_zagadke(name, words))
