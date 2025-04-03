import turtle


def draw_image():
    pixel_size = 1
    with open("obrazek.txt", 'r') as file:
        rows = file.readlines()

    turtle.tracer(0, 0)
    t = turtle.Turtle()
    t.speed(0)
    t.penup()


    y = 0
    for row in rows:
        pixels = row.strip().split(" ")
        x = 0
        for pixel in pixels:
            r, g, b = eval(pixel)
            turtle.colormode(255)
            t.fillcolor(r, g, b)

            t.goto(-y * pixel_size, -x * pixel_size)
            t.begin_fill()
            for _ in range(4):
                t.forward(pixel_size)
                t.right(90)
            t.end_fill()

            x += 1
        y += 1

    turtle.update()
    turtle.done()


draw_image()
