//scalar product of two vectors xs and ys

def scalarUgly(xs : List[Int], ys: List[Int]): Int = {
  var suma = 0
  var i = 0
  while (i < xs.length && i < ys.length){
    suma += xs(i) * ys(i)
    i += 1
  }
  suma
}

def scalarUgly(xs : List[Int], ys : List[Int]): Int = {
    var suma = 0
    var i = 0
    if (xs.nonEmpty && ys.nonEmpty) {
        do {
            suma += xs(i) * ys(i)
            i += 1

        } while (i < xs.length && i < ys.length)
    }
    suma
}

def scalar(xs : List[Int], ys : List[Int]) : Int = {
    val suma = for {
      (x, y) <- xs.zip(ys)
    } yield x * y
    suma.sum
}

// println(scalar(List(1, 2, 3), List(1, 2, 3)))


//checks if n is prime

def isPrimeUgly(n : Int): Boolean = {
  var i = 2
  if (n < 2) return false
  while (i * i < n) {
    if (n % i == 0) return false
    i += 1
  }
  true
}


def isPrime(n : Int): Boolean = {
  if (n < 2) false
  else {
  def hlp(x : Int = 2) : Boolean = {
    if (x * x > n) true
    if (n % x == 0) false
    return hlp(x+1)
  }
  hlp()
  }
}


//for given positive integer n, find all pairs of integers i and j,where 1 ≤ j < i < n such that i + j is prime

def primePairsUgly(n : Int) : List[(Int, Int)] = {
  var result = List[(Int, Int)]()
  var y = 2
  while (y < n) {
    var x = 1
    while (x < y) {
      if (isPrime(x+y)) {
        result = result :+ (x, y)
      }
      x += 1
    }
    y += 1
  }
  result
}


def primePairs(n : Int) : List[(Int, Int)] = {
  var result = for {
    y <- 2 until n
    x <- 1 until y
    if (isPrime(x+y))
  } yield (y, x)
  result.toList
}

import scala.io.Source
import java.io.File

val filesHere = new java.io.File(".").listFiles

//create a list with all lines from given file
def fileLinesUgly(file: File): List[String] = {
  var result = List[String]()
  val source = Source.fromFile(file)
  val iterator = source.getLines()

  while (iterator.hasNext) {
    result = result := iterator.next()
  }
  source.close()
  result
}

def fileLines(file: File): List[String] = {
  val source = Source.fromFile(file)
  val lines = fpr {
    line <- source.getLines()
  } yield line

  val result = lines.toList
  source.close()
  result
}

//print names of all .scala files which are in filesHere & are nonempty


def printNonEmptyUgly(pattern: String): Unit = {
  var i = 0

  if (filesHere != null) {
    while (i < filesHere.length) {
      val file = filesHere(i)
      if (file.getName.endsWith(pattern) && file.length() > 0) {
        println(file.getName)
      }
      i += 1
    }
  }
}

def printNonEmpty(pattern: String): Unit = {
  if (filesHere != null) {
    for {
      file <- filesHere
      if file.getName.endsWith(pattern)
      if file.length() > 0
    } println(file.getName)
  }
}


