words = set()
with open("popularne_slowa2023.txt", "r") as file:
    for line in file:
        word = line.strip()
        words.add(word)

# Find reverse pairs
reverse_pairs = []
for word in words:
    reversed_word = word[::-1]
    # Check if the reversed word is in the set and avoid duplicates
    if reversed_word in words and word < reversed_word:
        reverse_pairs.append((word, reversed_word))

for pair in reverse_pairs:
    print(pair)
