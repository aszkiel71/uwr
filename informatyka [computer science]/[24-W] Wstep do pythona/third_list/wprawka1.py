import turtle
turtle.penup()
turtle.goto(-300, 300)
turtle.pendown()
def rysuj_kwadrat(dlugosc_boku):
    for _ in range(4):
        turtle.forward(dlugosc_boku)
        turtle.right(90)

def rysuj_schody(ilosc_kwadratow, dlugosc_boku):
    for i in range(ilosc_kwadratow):
        for j in range(i + 1):
            rysuj_kwadrat(dlugosc_boku)
            turtle.penup()
            turtle.forward(dlugosc_boku)
            turtle.pendown()
        turtle.penup()
        turtle.backward(dlugosc_boku * (i + 1))
        turtle.right(90)
        turtle.forward(dlugosc_boku)
        turtle.left(90)
        turtle.pendown()


turtle.speed(0)
rysuj_schody(5, 30)
turtle.done()
