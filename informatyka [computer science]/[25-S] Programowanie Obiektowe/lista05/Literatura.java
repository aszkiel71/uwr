import java.util.ArrayList;
import java.util.List;


class Ksiazka {
    String tytul;
    List<Pisarz> autorzy;


    public Ksiazka(String tytul, List<Pisarz> autorzy) {
        this.tytul = tytul;
        this.autorzy = autorzy;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("Tytul: ").append(tytul).append(", Autor(zy): ");
        for (Pisarz autor : autorzy) {
            sb.append(autor.pseudonim).append(", ");
        }
        if (autorzy.size() > 0) {
            sb.setLength(sb.length() - 2);
        }
        return sb.toString();
    }
}


interface Obserwator {
    void powiadomienie(Ksiazka k);
}


class Pisarz {
    String pseudonim;
    List<Obserwator> obserwatorzy;
    ArrayList<Ksiazka> ksiazki = new ArrayList<>();


    Pisarz(String pseudonim) {
        this.pseudonim = pseudonim;
        this.obserwatorzy = new ArrayList<>();
    }


    public void dodajObserwatora(Obserwator obserwator) {
        this.obserwatorzy.add(obserwator);
    }


    public void usunObserwatora(Obserwator obserwator) {
        this.obserwatorzy.remove(obserwator);
    }


    private void powiadomObserwatorow(Ksiazka ksiazka) {
        for (Obserwator obserwator : obserwatorzy) {
            obserwator.powiadomienie(ksiazka);
        }
    }


    void napisz(String tytul) {
        ArrayList<Pisarz> autorzy = new ArrayList<>();
        autorzy.add(this);
        Ksiazka ksiazka = new Ksiazka(tytul, autorzy);
        this.ksiazki.add(ksiazka);
        powiadomObserwatorow(ksiazka);
    }


    void napiszKsiazke(String tytul, Pisarz... autorzy) {
        List<Pisarz> listaAutorow = new ArrayList<>();
        for (Pisarz autor : autorzy) {
            listaAutorow.add(autor);
        }
        Ksiazka ksiazka = new Ksiazka(tytul, listaAutorow);
        for (Pisarz autor : autorzy) {
            autor.ksiazki.add(ksiazka);
            autor.powiadomObserwatorow(ksiazka);
        }
    }

    @Override
    public String toString() {
        return "Pisarz{" +
                "pseudonim='" + pseudonim + '\'' +
                "}";
    }
}


class Wydawnictwo implements Obserwator {
    char nazwa;


    Wydawnictwo(char nazwa) {
        this.nazwa = nazwa;
    }

    // Metoda wydająca książkę
    void wydajKsiazke(Ksiazka ksiazka) {
        System.out.println("Wydawnictwo " + nazwa + " wydaje ksiazke: " + ksiazka);
    }


    @Override
    public void powiadomienie(Ksiazka ksiazka) {
        if (ksiazka.tytul.charAt(0) == this.nazwa) {
            this.wydajKsiazke(ksiazka);
        }
    }
}


class Czytelnik implements Obserwator {
    String imie;


    public Czytelnik(String imie) {
        this.imie = imie;
    }
    @Override
    public void powiadomienie(Ksiazka k) {
        System.out.println("Czytelnik " + imie + " dostaje info o nowej ksiazce: " + k);
    }
}


class Biblioteka implements Obserwator {
    String nazwaBiblioteki;


    public Biblioteka(String nazwaBiblioteki) {
        this.nazwaBiblioteki = nazwaBiblioteki;
    }
    @Override
    public void powiadomienie(Ksiazka k) {
        System.out.println("Biblioteka " + nazwaBiblioteki + " dodaje do oferty ksiazke: " + k);
    }
}


public class Main {
    public static void main(String[] args) {

        Wydawnictwo t = new Wydawnictwo('T');
        Wydawnictwo p = new Wydawnictwo('P');


        Pisarz tpisarz1 = new Pisarz("tpisarz1");
        Pisarz pisarz2 = new Pisarz("pisarz2");
        Pisarz apisarz3 = new Pisarz("apisarz3");


        Czytelnik janek = new Czytelnik("Janek");
        Czytelnik fz = new Czytelnik("fz");


        Biblioteka bib1 = new Biblioteka("Biblioteka Alpha");
        Biblioteka bib2 = new Biblioteka("Biblioteka Beta");


        tpisarz1.dodajObserwatora(t);
        tpisarz1.dodajObserwatora(janek);
        tpisarz1.dodajObserwatora(bib1);
        pisarz2.dodajObserwatora(p);
        pisarz2.dodajObserwatora(fz);
        apisarz3.dodajObserwatora(bib2);


        tpisarz1.napisz("Jakas ksiazka od Tpisarz1");


        pisarz2.napisz("Jakas ksiazka od pisarz2");


        tpisarz1.napiszKsiazke("Wspolnie wydana ksiazka przez ", tpisarz1, pisarz2);


        tpisarz1.napiszKsiazke("Jakas ksiazka", tpisarz1, apisarz3);
    }
}
