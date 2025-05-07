import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

/**
 *
 */
class Ksiazka {
    String tytul;
    String autor;
    int wydanie;

    /**
     * Konstruktor dla ksiazki (w sumie to postaram sie komentowac tylko te potrzebniejsze rzeczy)
     */
    public Ksiazka(String t, String a, int w) {
        this.tytul = t;
        this.autor = a;
        this.wydanie = w;
    }

    /**
     * wyswiuetlanie ksiazki w tym JCombobox
     */
    @Override
    public String toString() {
        return tytul + " (" + autor + ")";
    }
}

/**
 * panel do edycji ksiazki
 */
class KsiazkaSwing extends JPanel {
    private JTextField tytulField;
    private JTextField autorField;
    private JTextField wydanieField;
    private Ksiazka model;

    /**
     * tworzneie panelu dla jakiejs ksiazki
     */
    public KsiazkaSwing(Ksiazka k) {
        model = k;
        setLayout(new GridLayout(3, 2));

        add(new JLabel("Tytuł:"));
        tytulField = new JTextField(k.tytul, 20);
        add(tytulField);

        add(new JLabel("Autor:"));
        autorField = new JTextField(k.autor, 20);
        add(autorField);

        add(new JLabel("Wydanie:"));
        wydanieField = new JTextField(String.valueOf(k.wydanie), 20);
        add(wydanieField);
    }

    /**
     * zapisywanie zmian z pol tekstowych do obiektu ,,Ksiazka''
     */
    public void zapiszZmiany() {
        model.tytul = tytulField.getText();
        model.autor = autorField.getText();
        try {
            model.wydanie = Integer.parseInt(wydanieField.getText());
        } catch (NumberFormatException e) {
            model.wydanie = 1;
        }
    }
}

/**
 * main classa aplikacji
 */
public class app extends JFrame {
    private JComboBox<Ksiazka> listaObiektow;
    private KsiazkaSwing panelEdycji;
    private JButton zapiszButton;
    private List<Ksiazka> obiekty;
    private final String PLIK = "ksiazki.csv";

    /**
     * konsturktur budujacy apke i ladujacy plik .csv
     */
    public app() {
        super("Edytor książek");
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setSize(400, 200);


        wczytajDaneZCSV();

        // tworzenie gui
        listaObiektow = new JComboBox<>(obiekty.toArray(new Ksiazka[0]));
        panelEdycji = new KsiazkaSwing(obiekty.get(0));
        zapiszButton = new JButton("Zapisz");

        setLayout(new BorderLayout());
        add(listaObiektow, BorderLayout.NORTH);
        add(panelEdycji, BorderLayout.CENTER);
        add(zapiszButton, BorderLayout.SOUTH);

        // zmiana ksiazki (w gui)
        listaObiektow.addActionListener(e -> {
            Ksiazka wybrana = (Ksiazka) listaObiektow.getSelectedItem();
            remove(panelEdycji);
            panelEdycji = new KsiazkaSwing(wybrana);
            add(panelEdycji, BorderLayout.CENTER);
            revalidate();
            repaint();
        });

        // obsluga przycisku od zapisywania
        zapiszButton.addActionListener(e -> {
            Ksiazka wybrana = (Ksiazka) listaObiektow.getSelectedItem();
            panelEdycji.zapiszZmiany();
            zapiszDaneDoCSV();
            JOptionPane.showMessageDialog(this, "Zapisano zmiany!");
        });

        setVisible(true);
    }

    /**
     * wczytywnaie z csv do listy obiektow
     * kazda linia pliku := tytul,autor,wydanie
     */
    private void wczytajDaneZCSV() {
        obiekty = new ArrayList<>();
        try (Scanner sc = new Scanner(new File(PLIK))) {
            while (sc.hasNextLine()) {
                String linia = sc.nextLine();
                String[] dane = linia.split(",");
                if (dane.length == 3) {
                    String tytul = dane[0].trim();
                    String autor = dane[1].trim();
                    int wydanie = Integer.parseInt(dane[2].trim());
                    obiekty.add(new Ksiazka(tytul, autor, wydanie));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * zapisywanie aktualienj listy ksiazek do csv
     * wg formatu: tytul,autor,wydanie (w osobnej linii kolejne ksiazki)
     * (mozna zobaczyc plik ksiazki.csv, ktory dosylam)
     */
    private void zapiszDaneDoCSV() {
        try (PrintWriter pw = new PrintWriter(new FileWriter(PLIK))) {
            for (Ksiazka k : obiekty) {
                pw.println(k.tytul + "," + k.autor + "," + k.wydanie);
            }
        } catch (IOException e) {
            JOptionPane.showMessageDialog(this, "Blad zapisu pliku!");
        }
    }

    public static void main(String[] args) {
        new app();
    }
}
