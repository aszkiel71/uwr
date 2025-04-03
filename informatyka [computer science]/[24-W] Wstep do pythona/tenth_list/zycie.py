from kwadrat import kwadrat
from turtle import update, clear
import random
import sys

txt = """
.............###......
......................
............###.......
............###.......
......................
....###...........###.
......#...............
.....#................
...........###........
......................
..###.................
....#.................
...#............##....
................##....
"""

tab = [list(x) for x in txt.split()]

MY = len(tab)
MX = len(tab[0])

"""
sprawdzać czy mrowka stoi na białym czy na czarnym
if BIALE:
	kierunek = kierunek + 1  % 4
	BIALE -> CZARNE
	KRODY MROWKI PRZESUN W KIERUNKU
else:
	DLA CZARNEGO
"""
ant_x, ant_y = MX//2, MY//2
ant_dir = 0
# 0 prawo 1 lewo 2 gora 3 dol

KIERUNKI = [(1, 0), (0, 1), (-1, 0), (0, -1)]

def rysuj_plansze(tab, ant_x, ant_y):
    clear()
    for x in range(MX):
        for y in range(MY):
            if x == ant_x and y == ant_y:
                kolor = 'red' #mrowka
            elif tab[y][x] == '#':
                kolor = 'green'
            else:
                kolor = 'lightgreen'
            kwadrat(x, MY - y, kolor)
    update()




def pusta_plansza():
    return [['.'] * MX for y in range(MY)]


# reguły gry w życie:
# jeżeli komórka pełna ma 2 lub 3 sąsiadów przeżywa, wpp ginie
# jeżeli komórka pusta ma 3 sąsiadów, to rodzi się nowa
#
#



while True:
    nowy_tab = pusta_plansza()
    for x in range(MX):
        for y in range(MY):
            ls = liczba_sasiadow(x, y)
            if ls == 3:
                nowy_tab[y][x] = '#'
            elif ls == 2 and tab[y][x] == '#':
                nowy_tab[y][x] = '#'

    rysuj_plansze(nowy_tab)

    r = reprezentacja(nowy_tab)
    if r in historia:
        break
    historia.add(r)
    tab = nowy_tab

print('Koniec')
input()