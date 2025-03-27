class KolejneSlowaFibonacciego:
    def __init__(self):
        self.s1 = "a"
        self.s2 = "b"
        self.current_index = 1

    def next(self):
        if self.current_index == 1:
            result = self.s1
        elif self.current_index == 2:
            result = self.s2
        else:
            result = self.s2 + self.s1
            self.s1, self.s2 = self.s2, result
        self.current_index += 1
        return result


class JakiesSlowoFibonacciego:
    def __init__(self):
        self.s1 = "a"
        self.s2 = "b"
        self.res = {1: self.s1, 2: self.s2}

    def slowo(self, i):
        if i in self.res:
            return self.res[i]
        for n in range(len(self.res) + 1, i + 1):
            self.res[n] = self.res[n - 1] + self.res[n - 2]
        return self.res[i]


if __name__ == "__main__":
    print("Kolejne słowa Fibonacciego:")
    ksf = KolejneSlowaFibonacciego()
    for _ in range(10):
        print(ksf.next())

    print("\nPojedyncze słowo Fibonacciego:")
    jsf = JakiesSlowoFibonacciego()
    print("10. słowo Fibonacciego:", jsf.slowo(10))