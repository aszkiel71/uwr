def krzyzyk(n):
    for i in range(n):
        print(' ' * n + '*' * n)

    for i in range(n):
        print('*' * 3 * n)

    for i in range(n):
        print(' ' * n + '*' * n)

krzyzyk(4)
