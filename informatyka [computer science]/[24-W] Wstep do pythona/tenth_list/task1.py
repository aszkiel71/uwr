def ceasar(s, k):
    s = s.lower()
    cesar_dict = {
        "a": 1, "ą": 2, "b": 3, "c": 4, "ć": 5, "d": 6,
        "e": 7, "ę": 8, "f": 9, "g": 10, "h": 11,
        "i": 12, "j": 13, "k": 14, "l": 15, "ł": 16, "m": 17,
        "n": 18, "ń": 19, "o": 20, "ó": 21, "p": 22, "r": 23,
        "s": 24, "ś": 25, "t": 26, "u": 27, "w": 28, "y": 29,
        "z": 30, "ź": 31, "ż": 32
    }

    reverse_dict = {v: k for k, v in cesar_dict.items()}
    #reverse_dict = dict(zip(cesar_dict.values(), cesar_dict.keys()))

    result = ""
    k = k % 32
    for char in s:
        if char in cesar_dict:
            new_val = (cesar_dict[char] + k) % 32
            if new_val == 0:        new_val = 32
            result += reverse_dict[new_val]
        else:
            result += char
    return result

if __name__ == '__main__':
    print(ceasar('WOJTEK', 0))