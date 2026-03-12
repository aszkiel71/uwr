package numbers

class Rational(val n : Int, val d : Int) {
    require(d != 0, "Cannot divide by zero")
    private def gcd(a : Int, b : Int) : Int = if (b == 0) a else gcd(b, a % b)

    private val g = gcd(n.abs, d.abs)
    val num : Int = (if (d < 0) -n else n) / g
    val den : Int = d.abs / g

    def +(other: Rational): Rational =
        new Rational(num * other.den + other.num * den, den * other.den)

    def -(other: Rational): Rational =
        new Rational(num * other.den - other.num * den, den * other.den)

    def *(other: Rational): Rational =
        new Rational(num * other.num, den * other.den)

    def /(other: Rational): Rational =
        new Rational(num * other.den, den * other.num)

    override def toString: String = {
        val whole = num / den
        val rem = (num % den).abs

        if (whole == 0 && rem == 0) "0"
        else if (whole == 0) s"$num/$den"
        else if (rem == 0) s"$whole"
        else s"$whole $rem/$den"
    }
}


object Rational {
    def apply(n : Int, d : Int = 1): Rational = new Rational(n, d)
    def zero: Rational = Rational(0)
    def one: Rational = Rational(1)
}

val r1 = Rational(1, 2)
val r2 = Rational(5)
val zero = Rational.zero
val one = Rational.one

val sum = r1 + r2

val exm = Rational(50, 6)
println(exm)


// =============================================== \\

package figures
import numbers.Rational

trait Figure {
  def area: Double
  val description: String
}

class Point(val x: Rational, val y: Rational) {
  def xDouble: Double = x.num.toDouble / x.den.toDouble
  def yDouble: Double = y.num.toDouble / y.den.toDouble

  def distance(other: Point): Double = {
    Math.sqrt(Math.pow(this.xDouble - other.xDouble, 2) + Math.pow(this.yDouble - other.yDouble, 2))
  }
}

class Triangle(p1: Point, p2: Point, p3: Point) extends Figure {
  override val description: String = "Triangle"

  override def area: Double = {
    val a = p1.distance(p2)
    val b = p2.distance(p3)
    val c = p3.distance(p1)

    val s = (a + b + c) / 2
    Math.sqrt(s * (s - a) * (s - b) * (s - c))
  }
}

class Rectangle(p1: Point, p2: Point, p3: Point, p4: Point) extends Figure {
  override val description: String = "Rectangle"

  override def area: Double = p1.distance(p2) * p2.distance(p3)
}

object Rectangle {
  def apply(bottomLeft: Point, topRight: Point): Rectangle = {
    val bottomRight = new Point(topRight.x, bottomLeft.y)
    val topLeft = new Point(bottomLeft.x, topRight.y)
    new Rectangle(bottomLeft, bottomRight, topRight, topLeft)
  }
}

class Square(p1: Point, p2: Point, p3: Point, p4: Point) extends Figure {
  override val description: String = "Square"

  override def area: Double = Math.pow(p1.distance(p2), 2)
}

object Square {
  def apply(bottomLeft: Point, sideLength: Rational): Square = {
    val bottomRight = new Point(bottomLeft.x + sideLength, bottomLeft.y)
    val topRight = new Point(bottomLeft.x + sideLength, bottomLeft.y + sideLength)
    val topLeft = new Point(bottomLeft.x, bottomLeft.y + sideLength)
    new Square(bottomLeft, bottomRight, topRight, topLeft)
  }
}

object FigureUtils {
  def areaSum(figures: List[Figure]): Double = figures.map(_.area).sum
  def printAll(figures: List[Figure]): Unit = figures.foreach(f => println(f.description))
}


val p1 = new Point(Rational(0), Rational(0))
val p4 = new Point(Rational(4), Rational(3))
val rectangle = Rectangle(p1, p4)

FigureUtils.areaSum(List(rectangle))
