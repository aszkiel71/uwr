def kolko(n):
    """Tworzy kółko o szerokości n."""
    # Górna część (rosnąco)
    for i in range(3, n + 1, 2):
        spacje = (n - i) // 2
        print(" " * spacje + "#" * i)

    # Środkowa część - 3 wiersze o szerokości n
    for _ in range(3):
        print("#" * n)

    # Dolna część (malejąco - odbicie górnej)
    for i in range(n - 2, 2, -2):
        spacje = (n - i) // 2
        print(" " * spacje + "#" * i)


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
