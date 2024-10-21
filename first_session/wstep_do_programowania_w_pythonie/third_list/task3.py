def usun_w_nawiasach(s):
    new_s = ""
    switcher = 1
    for i in s:
        if i == "(":    switcher = 0
        if switcher:    new_s += i
        if i == ")":    switcher = 1
    return new_s
print(usun_w_nawiasach("Ala(a) ma kota (b)(c)(d)assa(e)"))