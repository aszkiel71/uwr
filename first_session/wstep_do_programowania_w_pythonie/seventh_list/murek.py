from turtle import *


def kwadrat(bok):
    begin_fill()
    for i in range(4):
      fd(bok)
      rt(90)
    end_fill()
    
def murek(s,bok):
  for a in s:
     if a == 'f':
         kwadrat(bok)
         fd(bok)
     elif a == 'b':
         kwadrat(bok)
         fd(bok)         
     elif a == 'l':
         bk(bok)
         lt(90)
     elif a == 'r':
        rt(90)
        fd(bok)

        
color('black', 'yellow')

ht()

tracer(0,0) # szybkie rysowanie     
murek('fffffffffrfffffffffflfffffffffrfffffl',10)    
murek(4 * 'fffffr', 14)    
update() # uaktualnienie rysunku

input()
