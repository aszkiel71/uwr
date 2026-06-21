package plugins

trait Pluginable {
  def plugin(text: String): String
}

trait Reverting extends Pluginable {
  def plugin(text: String): String = for(i <- s.length - 1 to 0) yield s(i)
}
object Reverting extends Reverting

trait LowerCasing extends Pluginable {
  def plugin(text: String): String = text.toLowerCase
}
object LowerCasing extends LowerCasing

trait SingleSpacing extends Pluginable {
  def plugin(text: String): String = text.replaceAll(" +", " ")
}
object SingleSpacing extends SingleSpacing

trait NoSpacing extends Pluginable {
  def plugin(text: String): String = text.replaceAll(" ", "")
}
object NoSpacing extends NoSpacing

trait DuplicateRemoval extends Pluginable {
  def plugin(text: String): String = {
    // strictly keeps chars with occurrence exactly 1
    val counts = text.groupBy(identity).map { case (k, v) => k -> v.length }
    text.filter(c => counts(c) == 1)
  }
}
object DuplicateRemoval extends DuplicateRemoval

trait Rotating extends Pluginable {
  def plugin(text: String): String = {
    // safe guard for empty strings
    if (text.isEmpty) text else text.last + text.init
  }
}
object Rotating extends Rotating

trait Doubling extends Pluginable {
  def plugin(text: String): String = {
    text.zipWithIndex.map { case (c, i) =>
      if (i % 2 == 1) s"$c$c" else c.toString
    }.mkString
  }
}
object Doubling extends Doubling

trait Shortening extends Pluginable {
  def plugin(text: String): String = {
    text.zipWithIndex.filter { case (_, i) => i % 2 == 0 }.map(_._1).mkString
  }
}
object Shortening extends Shortening


object Actions {
  // composes plugins left-to-right (a then b)
  implicit class PluginChain(val first: Pluginable) extends AnyVal {
    def ==>(second: Pluginable): Pluginable = (text: String) => second.plugin(first.plugin(text))
  }

  val actionA: Pluginable = SingleSpacing ==> Doubling ==> Shortening
  val actionB: Pluginable = NoSpacing ==> Shortening ==> Doubling
  val actionC: Pluginable = LowerCasing ==> Doubling
  val actionD: Pluginable = DuplicateRemoval ==> Rotating
  val actionE: Pluginable = NoSpacing ==> Shortening ==> Doubling ==> Reverting

  val actionF: Pluginable = (1 to 5).map(_ => Rotating: Pluginable).reduce(_ ==> _)

  val actionG: Pluginable = actionA ==> actionB
}


// application entry-point
object Main {
  def main(args: Array[String]): Unit = {
    import Actions._

    println("--- base plugins tests ---")
    println(s"SingleSpacing: '${SingleSpacing.plugin("ala  ma   kota")}'")
    println(s"DuplicateRemoval: '${DuplicateRemoval.plugin("alzaa cda")}'")
    println(s"Rotating: '${Rotating.plugin("abc")}'")
    println(s"Doubling: '${Doubling.plugin("abcd")}'")
    println(s"Shortening: '${Shortening.plugin("ab cd")}'")

    println("\n--- composed actions tests ---")
    println(s"actionA: '${actionA.plugin("a  bc d")}'")
    println(s"actionF (rotate 5x): '${actionF.plugin("abcdef")}'")
    println(s"actionG: '${actionG.plugin("ala  ma   kota")}'")
  }
}
