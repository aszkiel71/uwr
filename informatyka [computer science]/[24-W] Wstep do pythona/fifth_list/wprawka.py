import turtle
""" Korzystając z modułu turtle, napisz program, który wykonuje poniższy rysunek. """
""" Program powinien działać dla różnych ilości poziomów oraz różnych długości odcinka. """


""" aod -> amount of diagonals, length"""
def diagonal_left_to_right(aod, length):
    for i in range(aod):
        turtle.penup()
        turtle.goto((aod-i-2)*length, 0)
        turtle.pendown()
        turtle.setheading(60)
        turtle.forward(i*length)

def diagonal_from_right_to_left(aod, length):
    for i in range(aod):
        turtle.penup()
        turtle.goto((i-1)*length, 0)
        turtle.pendown()
        turtle.setheading(120)
        turtle.forward(i*length)

def diagonal(aod, length):
    turtle.speed(3)
    diagonal_from_right_to_left(aod, length)
    turtle.penup()
    turtle.goto((aod)*length, 0)
    turtle.pendown()
    diagonal_left_to_right(aod, length)

print(diagonal(9, 12))