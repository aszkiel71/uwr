import turtle

def rysuj(x, y, bok, glebokosc):
    turtle.penup()
    if glebokosc == 0:
        turtle.goto(x, y)
        turtle.pendown()
        turtle.begin_fill()
        for _ in range(4):
            turtle.forward(bok)
            turtle.left(90)

        turtle.end_fill()

    else:
        move = bok / 3
        for i in range(3):
            for j in range(3):
                if i == j or i + j == 2:
                    rysuj(x + i * move - bok / 2, y - j * move + bok / 2, move, glebokosc - 1)


rysuj(0, 0, 300, 2)

turtle.done()
