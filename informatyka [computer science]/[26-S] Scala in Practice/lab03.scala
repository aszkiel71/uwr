object Utils {
 def isSorted(as: List[Int], ordering: (Int, Int) => Boolean) = {
    as match {
        case Nil => true
        case _ :: Nil => true
        case x :: y :: xs =>
        if (!ordering(x, y)) false
        else isSorted(y :: xs, ordering)
    }
 }
 def isAscSorted(as : List[Int]) : Boolean = {
    isSorted(as, (a, b) => a <= b)
    // isSorted(as, _ <= _)
 }

 def isDescSorted(as: Lint[Int]) : Boolean = {
    isSorted(as, (a, b) => a >= b)
    // isSorted(as, _ >= _)
 }

 def foldLeft[A, B](l: List[A], z: B)(f: (B, A) => B): B = {
    l match {
        case Nil => z
        case x :: xs =>
        foldLeft(xs, f(z, x))(f)
    }
 }

 def sum(l: List[Int]) = {
    foldLeft(l, 0)(_ + _)
 }

 def length[A](l: List[A]): Int = {
    foldLeft(l, 0)((acc, _) => acc + 1)
 }

 def compose[A, B, C](f: B => C, g : A => B): A => C = {
    (x : A) => f(g(x))
 }

 def repeated[A](f: A => A, n: Int): A => A = {
    if (n <= 0) {
        (x: A) => x
    }
    else {
        compose(f, repeated(f, n - 1))
    }
 }

 def repeated2[A](f: A => A, n: Int): A => A {
    if (n <= 0) (x: A) => x
    else (x: A) => f(repeated2(f, n - 1)(x))
 }

 def curry[A, B, C](f : (A, B) => C): A => (B => C) = {
    (a : A) => (b: B) => f(a, b)
 }

 def uncurry[A, B, C](f: A => B => C): (A, B) => C = {
    (a: A, b : B) => f(a)(b)
 }

    /*
    curry f(a, b) -> f(a)(b)
    uncurry f(a)(b) -> f(a, b)
    */

  def unSafe[T](ex: Exception)(block: => T): T = {
   try {
      block
   }
   catch {
      case e: Exception =>
      println(s"Error log: ${e.getMessage}")
      throw ex
   }
  }


}
val exception1 = new Exception("something")
val exception2 = new Exception("something again")
Utils.unSafe(exception1) {
   val x = 10 / 0
}

try {
   println("Hello there")
   Utils.unSafe(exception2) {
      val x = 42 / 0
      println("Hi")
   }
 }  catch {
      case e: Exception =>
        println(s"My exception: ${e.getMessage}")
   }

