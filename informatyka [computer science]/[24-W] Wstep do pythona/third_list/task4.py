import turtle

turtle.speed(0)

for i in range(10): # ten squares
    for _ in range(4):
        turtle.forward(20 + 20*i)
        turtle.left(90)
    turtle.penup()
    turtle.goto(-10*(i + 1), -10*(i + 1))  # next sq
    turtle.pendown()

turtle.done()
