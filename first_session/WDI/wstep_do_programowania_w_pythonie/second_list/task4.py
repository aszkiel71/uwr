from duze_cyfry import daj_cyfre


def dlc(digit):

    digit = str(digit)

    lines = []
    for _ in range(5):
        lines.append("")

    for i in digit:
        cyfra_wizualizacja = daj_cyfre(int(i))
        for i in range(5):
            lines[i] += cyfra_wizualizacja[i] + '   '

    # Wypisujemy wynik
    for i in lines:
        print(i)



dlc(3919023)
