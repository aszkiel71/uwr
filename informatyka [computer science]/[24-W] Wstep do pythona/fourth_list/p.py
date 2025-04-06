import turtle


def draw_gradient():
    # Lista kolorów do gradientu
    colors = ["white", "light gray", "gray", "dark gray", "black"]

    # Ustawienia ekranu
    screen = turtle.Screen()
    screen.setup(width=1600, height=400)

    # Tworzymy obiekt Turtle
    t = turtle.Turtle()
    t.speed(0)
    t.hideturtle()

    stripe_width = screen.window_width() / len(colors)

    x_position = -screen.window_width() / 2
    for color in colors:
        t.penup()
        t.goto(x_position, -screen.window_height() / 2)
        t.pendown()
        t.color(color)
        t.begin_fill()

        # Rysujemy prostokątny pasek dla koloru
        for _ in range(2):
            t.forward(stripe_width)
            t.left(90)
            t.forward(screen.window_height())
            t.left(90)

        t.end_fill()
        x_position += stripe_width

    turtle.done()


# Wywołanie funkcji
draw_gradient()
