def szachownica(n, k):
    field = ""
    field2 = ""

    for i in range(n):
        for _ in range(k):
            field += " "
        for _ in range(k):
            field += "#"

        for _ in range(k):
            field2 += "#"
        for _ in range(k):
            field2 += " "

    field_w = field + field2
    field_b = field2 + field

    for i in range(n):
        for _ in range(k):
            print(field_w)
        for _ in range(k):
            print(field_b)

szachownica(4, 3)
