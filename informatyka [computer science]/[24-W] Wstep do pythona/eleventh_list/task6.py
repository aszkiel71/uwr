from turtle import *
import time
import random

tracer(0, 0)
FRAME_RATE = 1 / 30
pensize(3)



def kwadrat(bok, k):
    prostokat(bok, bok, k)


def prostokat(bok1, bok2, k):
    fillcolor(k)
    begin_fill()
    for i in range(2):
        fd(bok1)
        rt(90)
        fd(bok2)
        rt(90)
    end_fill()


def prezent(bok, k1, k2):
    pd()
    kwadrat(bok, k1)
    b5 = bok / 5
    fd(2 * b5)
    prostokat(b5, bok, k2)
    bk(2 * b5)

    rt(90)
    fd(2 * b5)
    rt(180)
    prostokat(b5, bok, k2)
    rt(180)
    bk(2 * b5)
    lt(90)

    pu()


def rozeta(N, kat, dlugosc, k1, k2):
    for i in range(N):
        pu()
        fd(dlugosc)
        pd()
        rt(kat)
        prezent(50, k1, k2)
        lt(kat)
        pu()
        bk(dlugosc)
        pd()
        rt(360 / N)

#!
def zmien_kolor():
    colors = ['red', 'green', 'blue', 'yellow', 'purple', 'orange', 'magenta']
    return random.choice(colors)



class RuchomaRozeta:
    def __init__(self, N, sx, sy, D1, D2, kolor1, kolor2):
        self.N = N
        self.x = sx
        self.y = sy
        self.D1 = D1
        self.D2 = D2
        self.vx = 0
        self.vy = 0
        self.kat1 = 0
        self.kat2 = 0
        self.k1 = kolor1
        self.k2 = kolor2

    def rysuj(self):
        move(self.x, self.y)
        seth(self.kat1)
        rozeta(self.N, self.kat2, 100, self.k1, self.k2)

    def uaktualnij(self):
        self.kat1 += self.D1
        self.kat2 += self.D2
        self.vx += 0.3 * (0.05 - 0.1 * random.random())
        self.vy += 0.3 * (0.05 - 0.1 * random.random())
        self.x += self.vx
        self.y += self.vy
        self.k1 = zmien_kolor()
        self.k2 = zmien_kolor()

def move(x, y):
    pu()
    goto(x, y)
    pd()

#!
def losuj_napis():
    with open("countries.txt", "r") as f:
        lines = f.readlines()
    return random.choice(lines).strip()

def rysuj_napis(napis):
    pensize(2)
    pu()
    goto(0, 100)
    seth(0)

    for i, litera in enumerate(napis):
        color(zmien_kolor())
        write(litera, font=("Arial", 24, "normal"))
        pu()
        fd(18)
        pd()


rozety = [
    RuchomaRozeta(10, 0, 0, 3, 5, 'yellow', 'green'),
    RuchomaRozeta(6, 0, 0, 4, 7, 'red', 'green'),
    RuchomaRozeta(20, 100, -100, 2, 4, 'magenta', 'red'),
    RuchomaRozeta(10, 0, 0, 3, 5, 'yellow', 'green'),
    RuchomaRozeta(6, 0, 0, 4, 7, 'red', 'green'),
    RuchomaRozeta(20, 100, -100, 2, 4, 'magenta', 'red'),
]


napis = losuj_napis()

while True:
    clear()
    rysuj_napis(napis)

    for r in rozety:
        r.uaktualnij()
        r.rysuj()

    update()

input()
