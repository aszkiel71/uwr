######################################
#  animowana_rozeta.py
######################################

####################################
# Program:  animacja.py
####################################

from turtle import *
import time
import random

tracer(0,0)
FRAME_RATE = 1/30

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
    b5 = bok/5
    fd(2*b5)
    prostokat(b5, bok, k2)
    bk(2*b5)
    
    rt(90)
    fd(2*b5)
    rt(180)
    prostokat(b5, bok, k2)
    rt(180)
    bk(2*b5)    
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


"""
for i in range(10):
    prezent(40, 'green', 'red')
    pu()
    fd(55)
    pd()
    rt(random.randint(-20, 20))
"""

if __name__ == '__main__':
    D1 = 6
    D2 = 10

    kat = 0

    while True:
        clear()
        rt(D1)
        rozeta(10, kat, 50, 50, 10)
        kat += D2
        update()
        time.sleep(0.03)

    input()

######################################
#  fd_solver.py
######################################


######################################
#  hash_demo.py
######################################

import random

litery = 'abcdefghijklmnopqrstuvwzyz'

def napis():
    wynik = []
    while True:
        if random.randint(0,30) == 0:
            return ''.join(wynik)
        wynik.append(random.choice(litery))
        
N = 13000
N = 50
K = 13
cnt = [0] * K
        
for i in range(N):
    n = napis()
    print (n)

print (cnt)
        
   

######################################
#  nasz_zbior.py
######################################

def in_tree(tree, e):
    if tree == []:
        return False
    n, left, right = tree
    if n == e:
        return True
    if e < n:
        return in_tree(left, e)
    return in_tree(right, e)

def tree_to_list(tree):
    if tree == []:
        return []
    n, left, right = tree
    return tree_to_list(left) + [n] + tree_to_list(right)

def add_to_tree(e, tree):
    pass
       


#############################################################
#TODO: contains, or, str, 

class Set:
    def __init__(self, *elems):
        self.tree = []
        pass
            
    def add(self, e):
        add_to_tree(e, self.tree)    
        
    def __contains__(self, e):
        return in_tree(self.tree, e) 
        



######################################
#  oneliners.py
######################################

#TODO: silnia, is_prime, functools.reduce, any, all

######################################
#  osoby.py
######################################

#to define: init, str, repr, hash, eq

class Osoba:  # klasa == typ
    def __init__(self, im, nz, wk):
        self.imie = im
        self.nazwisko = nz
        self.wiek = wk 
        
    def __str__(self):
        return f'{self.imie} {self.nazwisko} ({self.wiek} l.)'  
        
    def __repr__(self):
        return f'Osoba("{self.imie}", "{self.nazwisko}", {self.wiek})'  
        
    def __eq__(self, other):
        return (
           self.imie == other.imie and
           self.nazwisko == other.nazwisko and
           self.wiek == other.wiek                  
        )
        
    def __hash__(self):
        return hash(str(self))   # self.__str__() 
        
    def poczatek_listu(self):
        if self.imie[-1] == 'a':
            kobieta = True
        else:
            kobieta = False
            
        if kobieta:
            return 'Droga ' + self.imie[:-1] + 'o' + '!'
        return 'Drogi ' + self.imie + 'ie!'        
        
janek = Osoba('Jan', 'Kowalski', 34)
ala = Osoba('Alicja', 'Nowak', 22)
basia = Osoba('Barbara', 'Pisarska', 12)    

osoby = [janek, ala, basia]

print ('Raport 1')
for o in osoby:
    #print (o.imie, o.nazwisko, 'ma', o.wiek, 'lat')
    #o.prezent = 'skarpetki'
    #print (o.__dict__)
    print (o)
    print (o.poczatek_listu())
    print ()
  

#napis = '[Osoba("Jan", "Kowalski", 34), Osoba("Alicja", "Nowak", 22), Osoba("Barbara", "Pisarska", 12)]'
#print(eval(napis))

z  ={janek, janek, basia}
print (janek in z, Osoba('Jan', 'Kowalski', 34) in z)
print (Osoba('Jan', 'Kowalski', 34) == Osoba('Jan', 'Kowalski', 34))
#print(osoby)



######################################
#  rozeta2.py
######################################

####################################
# Program:  animacja.py
####################################
from animowana_rozeta import rozeta

# Pamiętaj o seth

from turtle import *
import time
import random

tracer(0,0)
FRAME_RATE = 1/30

pensize(3)



D1 = 10
D2 = 6

#time.sleep(seconds)

#rozeta(N, kat, dlugosc, k1, k2)

def move(x, y):
    pu()
    goto(x,y)
    pd()
    
###########################################################################

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
        
        self.vx += 0.3* (0.05 - 0.1*random.random())
        self.vy += 0.3* (0.05 - 0.1*random.random())
        
        self.x += self.vx
        self.y += self.vy
        
rozety = [
   RuchomaRozeta(10, 0, 0, 3, 5, 'yellow', 'green'),
   RuchomaRozeta(6, 0, 0, 4, 7, 'red', 'green'),
   RuchomaRozeta(20, 100, -100, 2, 4, 'magenta', 'red'),
   RuchomaRozeta(10, 0, 0, 3, 5, 'yellow', 'green'),
   RuchomaRozeta(6, 0, 0, 4, 7, 'red', 'green'),
   RuchomaRozeta(20, 100, -100, 2, 4, 'magenta', 'red'),
   
]   

while True:
    clear()
    for r in rozety:
        r.uaktualnij()
        r.rysuj()
    update()
    #time.sleep(0.01)
input()

