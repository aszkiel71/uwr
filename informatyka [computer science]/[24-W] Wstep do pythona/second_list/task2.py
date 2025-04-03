def koperta(n):
    size = 2 * n + 1

    for i in range(size):
        row = ""

        for j in range(size):
            if j == 0 or j == size - 1:  # left, right edge
                row += '*'
            elif i == 0 or i == size - 1:  # upper, lower edge
                row += '*'
            elif j == i or j == size - i - 1:  #diagonal
                row += '*'
            else:
                row += ' '
        print(row)
        
koperta(4)
