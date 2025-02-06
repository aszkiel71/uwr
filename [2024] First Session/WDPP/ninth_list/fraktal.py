import turtle
"""
points: kordy wierzcholkow trojkata
lvl: stopien rekurencji, (czyli wsm nierekurencyjnie by bylo jakby while lvl != 0
gdy lvl == 0 to rysuje trojkat laczac wierzcholki z points
mid1, mid2, mid3 -> srodki bokow kolejnych trojkatow (trzy mniejsze -- rownoboczne)
potem wywylowyanie dla mniejszych trojkatow (zmniejszajac lvl o 1)
"""


def sierpinski(points, lvl):
    def draw_triangle(points):
        t.penup()
        t.goto(points[0][0], points[0][1])
        t.pendown()
        t.goto(points[1][0], points[1][1])
        t.goto(points[2][0], points[2][1])
        t.goto(points[0][0], points[0][1])

    def midpoint(point1, point2):
        return ((point1[0] + point2[0]) / 2, (point1[1] + point2[1]) / 2)

    if lvl == 0:
        draw_triangle(points)

    else:
        mid1 = midpoint(points[0], points[1])
        mid2 = midpoint(points[1], points[2])
        mid3 = midpoint(points[2], points[0])

        sierpinski([points[0], mid1, mid3], lvl-1)
        sierpinski([mid1, points[1], mid2], lvl-1)
        sierpinski([mid3, mid2, points[2]], lvl-1)


screen = turtle.Screen()
screen.bgcolor("black")
t = turtle.Turtle()
t.color("pink")
t.speed(0)
deepth = 3
sierpinski([[-200, -100], [0, 200], [200, -100]], deepth)

t.hideturtle()
turtle.done()
