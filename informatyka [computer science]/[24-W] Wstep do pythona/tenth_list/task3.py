from itertools import permutations

def czy_lamigowka(s):
    # wszystkie permutacje trzeba sprawdzic i sprawdzic czy istnieje dopasowanie ze dziala ta lamigowka
    s1, s2, result = "", "", ""
    pointer = 1
    syntax_checkpoint = 0
    for i in s:
        if pointer == 1 and i not in (" ", "+", "="):
            s1 += i
        elif pointer == 2 and i not in (" ", "+", "="):
            s2 += i
        elif pointer == 3 and i not in (" ", "+", "="):
            result += i
        if i == "+":
            pointer += 1
        elif i == "=":
            pointer += 1
    if s1 == "" or s2 == "" or result == "":
        return "Syntax error of your zagadka"
    # dla s = "send + more = money" to s1 = send, s2 = more, result = money #
    # sprawdzmy czy jest to wgl mozliwe czyli czy dzialamy w sys10
    diff_chars_am = 0
    diff_chars = set()
    for i in s:
        if i not in diff_chars and i not in (" ", "+", "="):
            diff_chars.add(i)
            diff_chars_am += 1
    if diff_chars_am > 10:
        print(diff_chars, diff_chars_am)
        return ("Bro, we do it in decimal system. Input Error")
    # glowna czesc programu
    # trzeba sprawdzic wszystkie mozliwosci
    letters = list(diff_chars) # wezmy set() -> liste
    for perm in permutations(range(10), len(letters)):

        mapping = dict(zip(letters, perm))

        def word_to_number(word):
            return int("".join(str(mapping[char]) for char in word))

        try:
            num1 = word_to_number(s1)
            num2 = word_to_number(s2)
            num_result = word_to_number(result)
            if num1 + num2 == num_result:
                if str(num1)[0] == "0" or str(num2)[0] == "0" or str(num_result)[0] == "0":
                    continue
                return f"Solution found: {s1} = {num1}, {s2} = {num2}, {result} = {num_result}"
        except ValueError:
            continue  # jak cos sie wywali przy zamianie na liczbe
    return "No solution was found"

#print(czy_lamigowka("send + more = money"))
#print(czy_lamigowka("ciacho + ciacho  = nadwaga"))
#print(czy_lamigowka("robert + lewandowski = goat"))
#print(czy_lamigowka("logika + dla = informatykow"))
#print(czy_lamigowka("polska polska = polska"))


