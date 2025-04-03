from kwadrat import kwadrat
from turtle import update, clear

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

MY = len(tab)  # liczba wierszy
MX = len(tab[0])  # liczba kolumn

ant_x, ant_y = MX // 2, MY // 2
ant_dir = 0  # 0 - prawo, 1 - dół, 2 - lewo, 3 - góra

KIERUNKI = [(1, 0), (0, 1), (-1, 0), (0, -1)]

def rysuj_plansze(tab, ant_x, ant_y):
    clear()
    for x in range(MX):
        for y in range(MY):
            if x == ant_x and y == ant_y:
                kolor = 'red'  # ant
            elif tab[y][x] == '#':
                kolor = 'green'
            else:
                kolor = 'lightgreen'
            kwadrat(x, MY - y, kolor)
    update()

def zmien_kolor(tab, x, y):
    if tab[y][x] == '.':
        tab[y][x] = '#'
    else:
        tab[y][x] = '.'

while True:
    rysuj_plansze(tab, ant_x, ant_y)


    if tab[ant_y][ant_x] == '.':
        ant_dir = (ant_dir - 1) % 4
    else:
        ant_dir = (ant_dir + 1) % 4
    zmien_kolor(tab, ant_x, ant_y)

    dx, dy = KIERUNKI[ant_dir]
    ant_x = (ant_x + dx) % MX
    ant_y = (ant_y + dy) % MY