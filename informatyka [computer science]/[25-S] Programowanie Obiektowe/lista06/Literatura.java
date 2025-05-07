import java.util.ArrayList;
import java.util.List;


class Ksiazka {
    String tytul;
    List<Pisarz> autorzy;
    int rokWydania; 

    public Ksiazka(String tytul, List<Pisarz> autorzy, int rokWydania) {
        this.tytul = tytul;
        this.autorzy = autorzy;
        this.rokWydania = rokWydania;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("Tytul: ").append(tytul)
          .append(", Rok wydania: ").append(rokWydania)
          .append(", Autor(zy): ");
        for (Pisarz autor : autorzy) {
            sb.append(autor.pseudonim).append(", ");
        }
        if (autorzy.size() > 0) sb.setLength(sb.length() - 2);
        return sb.toString();
    }
}

interface Obserwator {
    void powiadomienie(Ksiazka k);
}


class Pisarz {
    String pseudonim;
    int rokUrodzenia; 
    List<Obserwator> obserwatorzy = new ArrayList<>();
    List<Ksiazka> ksiazki = new ArrayList<>();
    
    obserwatorzy.sort((o1, o2)) -> {
        return 0;
        //tu jakas zadana kolejnosc
        
    };

    obserwatorzy.forEach(o -> o.powiadomienie(ksiazka));

    public Pisarz(String pseudonim, int rokUrodzenia) {
        this.pseudonim = pseudonim;
        this.rokUrodzenia = rokUrodzenia;
    }


    public void ustawKolejnosc(KolejnoscPowiadamiania kolejnosc) {
        this.kolejnosc = kolejnosc;
    }

    void napisz(String tytul, int rokWydania) {
        List<Pisarz> autorzy = new ArrayList<>();
        autorzy.add(this);
        Ksiazka ksiazka = new Ksiazka(tytul, autorzy, rokWydania);
        ksiazki.add(ksiazka);
        kolejnosc.powiadom(obserwatorzy, ksiazka);
        obserwatorzy.sort();
    }

    void dodajObserwatora(Obserwator o) {
        obserwatorzy.add(o);
        for (Ksiazka ksiazka : ksiazki) {
        o.powiadomienie(ksiazka);
    }
    }
}



interface KolejnoscPowiadamiania {
    void powiadom(List<Obserwator> obserwatorzy, Ksiazka ksiazka);
}



class KolejnoscBibliotekaPierwsza implements KolejnoscPowiadamiania {
    @Override
    public void powiadom(List<Obserwator> obserwatorzy, Ksiazka ksiazka) {
        List<Obserwator> biblioteki = new ArrayList<>();
        List<Obserwator> wydawnictwa = new ArrayList<>();
        List<Obserwator> czytelnicy = new ArrayList<>();

        for (Obserwator o : obserwatorzy) {
            if (o instanceof Biblioteka) biblioteki.add(o);
            else if (o instanceof Wydawnictwo) wydawnictwa.add(o);
            else if (o instanceof Czytelnik) czytelnicy.add(o);
        }

        biblioteki.forEach(o -> o.powiadomienie(ksiazka));
        wydawnictwa.forEach(o -> o.powiadomienie(ksiazka));
        czytelnicy.forEach(o -> o.powiadomienie(ksiazka));
        
    }
}


class Wydawnictwo implements Obserwator {
    char nazwa;
    String lokalizacja; 

    public Wydawnictwo(char nazwa, String lokalizacja) {
        this.nazwa = nazwa;
        this.lokalizacja = lokalizacja;
    }

    @Override
    public void powiadomienie(Ksiazka ksiazka) {
        if (ksiazka.tytul.charAt(0) == nazwa) {
            System.out.println("Wydawnictwo " + nazwa + " (" + lokalizacja + ") wydaje: " + ksiazka);
        }
    }
}

class Czytelnik implements Obserwator {
    String imie;

    public Czytelnik(String imie) {
        this.imie = imie;
    }

    @Override
    public void powiadomienie(Ksiazka ksiazka) {
        System.out.println("Czytelnik " + imie + " otrzymuje powiadomienie o: " + ksiazka);
    }
}

class Biblioteka implements Obserwator {
    String nazwa;

    public Biblioteka(String nazwa) {
        this.nazwa = nazwa;
    }

    @Override
    public void powiadomienie(Ksiazka ksiazka) {
        System.out.println("Biblioteka " + nazwa + " dodaje do katalogu: " + ksiazka);
    }
}

public class Main {
    public static void main(String[] args) {
        Pisarz pisarz1 = new Pisarz("Pisarz1", 1980);
        Pisarz pisarz2 = new Pisarz("Pisarz2", 1995);
        Wydawnictwo w = new Wydawnictwo('W', "Warszawa");
        Biblioteka b = new Biblioteka("Jakas");
        Czytelnik c = new Czytelnik("CzytelnikTmp");
        System.out.println(pisarz1.rokUrodzenia);
        System.out.println(pisarz2.rokUrodzenia);
        System.out.println(pisarz1.pseudonim);
        Pisarz p = new Pisarz("Pisarz1", 1980);
        p.dodajObserwatora(w);
        p.dodajObserwatora(b);
        p.dodajObserwatora(c);

        p.napisz("Dziady 2", 2025);


        p.ustawKolejnosc(new KolejnoscWydawnictwaPierwsze());
        p.napisz("Pan Tadeusz", 2025);
    }
}

/*
class KolejnoscWydawnictwaPierwsze implements KolejnoscPowiadamiania {
    @Override
    public void powiadom(List<Obserwator> obserwatorzy, Ksiazka ksiazka) {
        List<Obserwator> wydawnictwa = new ArrayList<>();
        List<Obserwator> czytelnicy = new ArrayList<>();
        List<Obserwator> biblioteki = new ArrayList<>();

        for (Obserwator o : obserwatorzy) {
            if (o instanceof Wydawnictwo) wydawnictwa.add(o);
            else if (o instanceof Czytelnik) czytelnicy.add(o);
            else if (o instanceof Biblioteka) biblioteki.add(o);
        }
        wydawnictwa.forEach(o -> o.powiadomienie(ksiazka));
        czytelnicy.forEach(o -> o.powiadomienie(ksiazka));
        biblioteki.forEach(o -> o.powiadomienie(ksiazka));
    }
}
*/