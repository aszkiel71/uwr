import java.util.ArrayList;

class Ksiazka{
    String tytul;
    Pisarz autor;
    Ksiazka(String tytul, Pisarz autor){
        this.tytul = tytul;
        this.autor = autor;
    }
}

interface Obserwator
{
    void powiadomienie(Ksiazka k);
}

class Pisarz {
    String pseudonim;
    Obserwator w;

    Pisarz (String pseudonim, Obserwator w)
    {
        this.pseudonim = pseudonim;
        this.w = w;
    }

    ArrayList<Ksiazka> ksiazki = new ArrayList<Ksiazka>();

    void napisz(String tytul){
        Ksiazka ksiazka = new Ksiazka(tytul, this);
        this.ksiazki.add(ksiazka);
        w.powiadomienie(ksiazka);
    }
}

class Wydawnictwo implements Obserwator {
    char nazwa;
    Wydawnictwo(char nazwa)
    {
        this.nazwa = nazwa;
    }

    void wydajKsiazke(Ksiazka ksiazka) {
        System.out.println("Wydaje ksiazkę" + ksiazka);
    }

    public void powiadomienie(Ksiazka ksiazka)
    {
        if (ksiazka.tytul.charAt(0) == this.nazwa)
            this.wydajKsiazke(ksiazka);
    }
}

class Czytelnik implements Obserwator
{
    public void powiadomienie(Ksiazka k){
        System.out.println("Nowa ksiazka " + k);
    }
}

public class Literatura
{

    public static void main(String[] args){
        Wydawnictwo a = new Wydawnictwo('T');
        Pisarz pisarz = new Pisarz("Litwos", a);

        pisarz.napisz("Trylogia");
    }
}