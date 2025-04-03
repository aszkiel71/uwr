import random


class IntStream:
    def __init__(self):
        self.current = 0

    def next(self):
        if self.eos():
            raise ValueError("Koniec strumienia.")
        result = self.current
        self.current += 1
        return result

    def eos(self):
        return False

    def reset(self):
        self.current = 0



class FibStream(IntStream):
    def __init__(self):
        super().__init__()
        self.prev1 = 0
        self.prev2 = 1
        self.current = 0

    def next(self):
        if self.eos():
            raise ValueError("Koniec strumienia Fibonacciego.")
        result = self.prev1
        self.prev1, self.prev2 = self.prev2, self.prev1 + self.prev2
        return result

    def eos(self):
        return self.prev2 < 0

    def reset(self):
        self.prev1 = 0
        self.prev2 = 1



class RandomStream(IntStream):
    def __init__(self):
        super().__init__()

    def next(self):
        return random.randint(0, 1000000)

    def eos(self):
        return False




class RandomWordStream:
    def __init__(self):
        self.fib_stream = FibStream()
        self.random_stream = RandomStream()
        self.chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

    def next(self):
        length = self.fib_stream.next()
        return ''.join(random.choice(self.chars) for _ in range(length))



if __name__ == "__main__":
    print("Strumień Fibonacciego:")
    fs = FibStream()
    for _ in range(10):
        print(fs.next())


    print("\nStrumień losowy:")
    rs = RandomStream()
    for _ in range(5):
        print(rs.next())

    print("\nStrumień losowych stringów o długościach Fibonacciego:")
    rws = RandomWordStream()
    for _ in range(5):
        print(rws.next())