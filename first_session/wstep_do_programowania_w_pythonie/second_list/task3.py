def kolko(n):

    for i in range(3, n + 1, 2):
        spaces = (n - i) // 2
        print(" " * spaces + "#" * i)

    for _ in range(3):
        print("#" * n)

    for i in range(n - 2, 2, -2):
        spaces = (n - i) // 2
        print(" " * spaces + "#" * i)


def balwanek(kulki):

    max_n = max(kulki)  # -> the longest radius used for centering

    for n in kulki:
        spaces = (max_n - n) // 2  # -> how many spaces needed for centering

        for i in range(3, n + 1, 2):
            print(" " * (spaces + (n - i) // 2) + "#" * i)

        for _ in range(3):
            print(" " * spaces + "#" * n)

        for i in range(n - 2, 2, -2):
            print(" " * (spaces + (n - i) // 2) + "#" * i)


balwanek([11, 11, 11])