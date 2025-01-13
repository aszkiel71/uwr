def ball(n, p):
    r = n // 2
    for i in range(n):
        print(int(p) * " ", end="")
        for j in range(n):
            if (i - r) ** 2 + (j - r) ** 2 <= r ** 2 + r:
                print("*", end="")
            else:
                print(" ", end="")
        print()

def ball2(n, p):    print("\n".join("".join((int(p) * " " + ("*" if (i - n // 2) ** 2 + (j - n//2) ** 2 <= (n//2) ** 2 + n//2 else " ")) for j in range(n)) for i in range(n)))
ball2(7, 0)