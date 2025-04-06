# testcase

class Wartosc:
    def __init__(self, value):
        self.value = value

    def val(self):
        return self.value

    def display(self):
        print(self.value)

class And:
    def __init__(self, arg1, arg2):
        self.arg1 = arg1
        self.arg2 = arg2

    def oblicz(self):
        return self.arg1 and self.arg2

class Or:
    def __init__(self, arg1, arg2):
        self.arg1 = arg1
        self.arg2 = arg2

    def oblicz(self):
        return self.arg1 or self.arg2

class Not:
    def __init__(self, arg1):
        self.arg1 = arg1

    def oblicz(self):
        return not self.arg1


x = Wartosc(True)
y = Wartosc(False)
res1 = Wartosc(x.val() or Not(y).oblicz())
res1.display()