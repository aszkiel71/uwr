def usun_w_nawiasach(s):
    new_s = ""
    switcher = 1
    for i in s:
        if i == "(":    switcher = 0
        if switcher:    new_s += i
        if i == ")":    switcher = 1
    return new_s
print(usun_w_nawiasach("A(sdd121)la(a) ma kota (b)(c)(d)(e)"))
print(usun_w_nawiasach(f"alks{(23)}LDSKLASDK(21)3"))
print(usun_w_nawiasach("Adsadsdasdaaddassads d(123)ta (b)(c)(d)(e)"))