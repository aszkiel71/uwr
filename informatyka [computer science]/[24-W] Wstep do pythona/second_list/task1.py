def szachownica(n, k):
    field_w = (" " * k + "#" * k) * n
    field_b = ("#" * k + " " * k) * n
    for i in range(n):
        for _ in range(k):
            print(field_w)
        for _ in range(k):
            print(field_b)

szachownica(4, 3)
