######################################
#  animation.py
######################################

from turtle import *
import time
import random
from collections import defaultdict as dd


def kwadrat(x, y, bok, kolor):
    fillcolor(kolor)
    pu()
    goto(x, y)
    pd()
    begin_fill()
    for i in range(4):
        fd(bok)
        rt(90)
    end_fill() 

rotating_squares = []

tracer(0,0)
ht()
screen = Screen()
BOK = 20

class RotatingSquare:
    def __init__(self, x, y):
        self.angle = 0
        self.rotation_speed = random.choice([-1, 1]) * random.randint(3, 6)
        self.x = x
        self.y = y
        self.color = (random.random(), random.random(), random.random())
        
    def draw(self):
        seth(self.angle)
        kwadrat(self.x, self.y, BOK, self.color)
        
    def update(self):
        self.angle = (self.angle + self.rotation_speed) % 360
        
def set_square(x, y):
    nrs = RotatingSquare(x, y)
    rotating_squares.append(nrs)


screen.onclick(set_square)
screen.listen()

while True:
    clear()
    for rs in rotating_squares:
        rs.draw()
        rs.update()    
    #todo    
    update()
    if len(rotating_squares) > 50:
       del rotating_squares[0]      
    time.sleep(0.003)

    

######################################
#  float1.py
######################################

# kiedy x + 1 == x?


for i in range(9999):
    x = 10.0 ** i
    print (i, x)
    if x + 1 == x:
        print ('Piekło zamarzło, 0 == 1')
        break

######################################
#  generator.py
######################################

#Zadanie: generować ciągi tych samych elementów (z uzyciem generatora!)

def the_same(N, K):
    res = []
    for i in range(N):
        res.append(K)
    return res
    
def the_same_gen(N, K):
    for i in range(N):
        yield K
        
def our_range(N):
    i = 0
    while i < N:
        yield i
        i += 1   
        
def double_range(A, B):
    for a in A:
        yield a
    for b in B:
        yield b
                     
            
for v in the_same_gen(5, 13):
    print (v)    
    
for i in our_range(5):
    print (i)   
    
print (list(double_range(our_range(5), range(7))))

print (our_range)
print (our_range(10))     

######################################
#  jedynka.py
######################################

def jedynka(N):
    s = 0.0
    for i in range(N):
        s += 1.0/N
    return s
    
for n in range(4, 130, 4):
    print (n, jedynka(n))

######################################
#  move.py
######################################

from turtle import *
import time
from collections import defaultdict as dd

tracer(0,0)

keyboard = dd(bool)

def kwadrat(x, y, bok, kolor):
    fillcolor(kolor)
    pu()
    goto(x, y)
    pd()
    begin_fill()
    for i in range(4):
        fd(bok)
        rt(90)
    end_fill() 
    
def handler(key, status):
    def aux():
        keyboard[key] = status
    return aux
    
            
x = y = 0
D = 3

screen = Screen()

# screen onkeypress onkeyrelease

for key in ["Up", "Down", "Left", "Right"]:
    screen.onkeypress(handler(key, True), key)
    screen.onkeyrelease(handler(key, False), key)
    
    

screen.listen()


R = 30
D = 3

while True:
    clear()
    kwadrat(x,y, R,  'orange')
    
    if keyboard['Left'] == True:
        x -= D
    if keyboard['Right']:
        x += D        
    if keyboard['Down']:
        y -= D
    if keyboard['Up']:
        y += D        
        
        
    update()
    time.sleep(0.01)



screen.mainloop()
    

######################################
#  najwolniesze_sortowanie_swiata.py
######################################

from itertools import permutations

lista = [5,3,12,88,30, 6,99,120,999,1000,19]



def perm_sort(L):
    for p in permutations(L):
        if all(p[i] <= p[i+1] for i in range(len(L)-1)):
            return p
    return []
    
print (perm_sort(lista))    

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
    if tree == []:
        tree.append(e)
        tree.append([])
        tree.append([])
        return
    v, left, right = tree
    
    if v == e:
        return 
    if e < v:
        add_to_tree(e, left)
    else:
        add_to_tree(e, right)
    
       


#############################################################
#TODO: contains, or, str, 

class Set:
    def __init__(self, *elems):
        self.tree = []
        for e in elems:
            #add_to_tree(e, self.tree)
            self.add(e)
            
    def add(self, e):
        add_to_tree(e, self.tree)    
        
    def __contains__(self, e):
        return in_tree(self.tree, e) 
        
    def __or__(self, other):
        for e in other:
            self.add(e)
        return self    
                
    def __str__(self):
        return '{' + ', '.join(str(n) for n in tree_to_list(self.tree)) + '}' 
        
s = Set(1,2,3,8,9,333)

print (s| {77,88,99})          
        



######################################
#  onclick.py
######################################

from turtle import *
import time
import random
from collections import defaultdict as dd

tracer(0,0)
screen = Screen()
ht()

LEFT_BUTTON = 1

def kwadrat(x, y, bok, kolor):
    fillcolor(kolor)
    pu()
    goto(x, y)
    pd()
    begin_fill()
    for i in range(4):
        fd(bok)
        rt(90)
    end_fill() 
    
    
def draw_square(x, y):
    kwadrat(x, y, 20, random.choice(['red', 'yellow', 'orange']))
    update()

screen.onclick(draw_square, LEFT_BUTTON)
screen.listen()
screen.mainloop()

    

