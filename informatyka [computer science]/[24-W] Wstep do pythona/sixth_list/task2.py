from idlelib.iomenu import encoding

words = set()
with open("popularne_slowa2023.txt", "r", encoding='utf-8') as file:
    for line in file:
        word = line.strip()
        words.add(word)

# Find reverse pairs
reverse_pairs = []
counter = 0
for word in words:
    reversed_word = word[::-1]
    # Check if the reversed word is in the set and avoid duplicates
    if reversed_word in words and word <= reversed_word:
        reverse_pairs.append((word, reversed_word))
        counter += 1
for pair in reverse_pairs:
    print(pair)
print(counter)
