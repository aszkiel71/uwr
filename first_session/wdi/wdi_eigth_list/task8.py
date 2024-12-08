# najmniejsza liczba ruchow potrzebna:  2^n - 1
# slupki A, B, C
# gdy n parzyste to wykonujemy jedyny legalny ruch:
# kolejno: AB, AC, BC
# gdy n nieparzyste to:
# kolejno: AC, AB, BC



n = 3
A = [i for i in range(n, 0, -1)]
B = []
C = []

hanoi(n, A, B, C)
