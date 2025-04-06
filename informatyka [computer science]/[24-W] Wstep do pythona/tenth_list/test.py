import turtle
from turtle import *

def draw_square(size, x, y):
    goto(x, y)
    for i in range(4):
        forward(size)
        left(90)



def draw_big_square(size):
    if size <= 0:
        return
    draw_square(size, size, 0)
    draw_big_square(size//2)

draw_big_square(300)

turtle.done()