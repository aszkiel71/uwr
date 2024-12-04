from random import shuffle

from task2 import rozklad, czy_ukladanka
from collections import defaultdict as dd
from task3 import minus

words_file = open("popularne_slowa2023.txt", "r", encoding="utf-8")

words = []

for word in words_file:
    words.append(word.strip("\n"))


def first_segment(s):
    res = ""
    for i in s:
        if i == " ":
            return res
        res += i

def second_segment(s):
    ind = 0
    for i in range(len(s)):
        if s[i] == " ":
            ind = i
    return s[ind+1::]

def zagadka(name):
    av_letters = minus(name, " ")
    puzzle = ""

    for i in words:
        pass


print(zagadka("Bolesław Prus"))