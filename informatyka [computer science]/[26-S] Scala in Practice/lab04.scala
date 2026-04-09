import scala.util.Random

package cards {
  sealed trait Color
  case object Clubs extends Color
  case object Diamonds extends Color
  case object Hearts extends Color
  case object Spades extends Color

  sealed trait Value
  case object Ace extends Value
  case object Two extends Value
  case object Three extends Value
  case object Four extends Value
  case object Five extends Value
  case object Six extends Value
  case object Seven extends Value
  case object Eight extends Value
  case object Nine extends Value
  case object Ten extends Value
  case object Jack extends Value
  case object Queen extends Value
  case object King extends Value

  case class Card(color: Color, value: Value) {
    override def toString: String = s"$value of $color"
  }

  object CardConfig {
    val colors: List[Color] = List(Clubs, Diamonds, Hearts, Spades)
    val numericalValues: List[Value] = List(Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten)
    val faceValues: List[Value] = List(Jack, Queen, King)
    val allValues: List[Value] = Ace :: numericalValues ::: faceValues
  }
}

package deck {
  import cards._
  import scala.util.Random

  class Deck(val cards: List[Card]) {
    def pull(): Deck = new Deck(cards.drop(1))

    def push(c: Card): Deck = new Deck(c :: cards)

    def push(color: Color, value: Value): Deck = new Deck(Card(color, value) :: cards)

    val isStandard: Boolean = {
      val standardSet = Deck.standardCards.toSet
      cards.size == 52 && cards.toSet == standardSet
    }

    def duplicatesOfCard(card: Card): Int = cards.count(_ == card)

    def amountOfColor(color: Color): Int = cards.count(_.color == color)

    def amountOfNumerical(numerical: Value): Int = {
      if (CardConfig.numericalValues.contains(numerical)) cards.count(_.value == numerical)
      else 0
    }

    val amountWithNumerical: Int = cards.count(c => CardConfig.numericalValues.contains(c.value))

    def amountOfFace(face: Value): Int = {
      if (CardConfig.faceValues.contains(face)) cards.count(_.value == face)
      else 0
    }

    val amountWithFace: Int = cards.count(c => CardConfig.faceValues.contains(c.value))
  }

  object Deck {
    def standardCards: List[Card] = for {
      color <- CardConfig.colors
      value <- CardConfig.allValues
    } yield Card(color, value)

    def apply(): Deck = new Deck(Random.shuffle(standardCards))
  }
}

package games {
  import cards._
  import deck._
  import scala.util.Random

  class Blackjack(val deck: Deck) {
    private def calculatePoints(hand: List[Card]): Int = {
      val basicSum = hand.map {
        case Card(_, Ace) => 11
        case Card(_, value) if CardConfig.faceValues.contains(value) => 10
        case Card(_, value) =>
          value match {
            case Two => 2; case Three => 3; case Four => 4; case Five => 5
            case Six => 6; case Seven => 7; case Eight => 8; case Nine => 9; case Ten => 10
            case _ => 0
          }
      }.sum

      val acesCount = hand.count(_.value == Ace)

      def adjustAces(sum: Int, aces: Int): Int = {
        if (sum > 21 && aces > 0) adjustAces(sum - 10, aces - 1)
        else sum
      }

      adjustAces(basicSum, acesCount)
    }

    def play(n: Int): Unit = {
      val drawnCards = deck.cards.take(n)
      println(s"playing $n cards")
      drawnCards.foreach { c =>
        val pts = calculatePoints(List(c))
        println(s"card: $c, points: $pts")
      }
      val totalPoints = calculatePoints(drawnCards)
      println(s"total points: $totalPoints")
    }

    lazy val all21: List[List[Card]] = {
      val c = deck.cards
      val subsequences = for {
        i <- c.indices
        j <- i + 1 to c.length
        sub = c.slice(i, j)
        if calculatePoints(sub) == 21
      } yield sub
      subsequences.toList
    }

    def first21(): Unit = {
      println("searching for first 21")
      all21.headOption match {
        case Some(seq) =>
          println("found sequence for 21:")
          seq.foreach(c => println(s"- $c"))
          println(s"verification sum: ${calculatePoints(seq)}")
        case None =>
          println("no sequence for 21 found")
      }
    }
  }

  object Blackjack {
    def apply(numOfDecks: Int): Blackjack = {
      val combinedCards = List.fill(numOfDecks)(Deck.standardCards).flatten
      new Blackjack(new Deck(Random.shuffle(combinedCards)))
    }
  }
}

import cards._
import deck._
import games._

object Main extends App {
  println("testing cards and deck")
  val exampleCard = Card(Hearts, Queen)
  println(s"created card: $exampleCard")

  val standardDeck = Deck()
  println(s"is standard deck: ${standardDeck.isStandard}")
  println(s"hearts count: ${standardDeck.amountOfColor(Hearts)}")
  println(s"numerical cards count: ${standardDeck.amountWithNumerical}")
  println(s"face cards count: ${standardDeck.amountWithFace}")
  println(s"queens count: ${standardDeck.amountOfFace(Queen)}")

  println("pull and push operations")
  val pulledDeck = standardDeck.pull()
  println(s"deck size after pull: ${pulledDeck.cards.size}")
  val pushedDeck = pulledDeck.push(exampleCard)
  println(s"deck size after pushing card: ${pushedDeck.cards.size}")
  val pushedNewCardDeck = pushedDeck.push(Spades, Ace)
  println(s"deck size after pushing new card: ${pushedNewCardDeck.cards.size}")

  println("testing blackjack")
  val game = Blackjack(3)
  println(s"blackjack game created with cards: ${game.deck.cards.size}")

  game.play(3)
  game.play(5)

  game.first21()

  println(s"total sequences for 21: ${game.all21.size}")
}
