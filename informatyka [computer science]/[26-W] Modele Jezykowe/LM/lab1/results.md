# Zadanie 1
-- mniejszy: przed system promptem
Ty: Hej Marek
Marek: No dobrze... Czy wiesz o co chodzi? Mam nadzieję że tak!
Ty: Nie rozumiem?
Marek: Na początek powinieneś mi wyjaśnić pewne rzeczy związane ze znakami interpunkcyjnymi...
Ty: Ciekawe
Marek: Ale powiedz ile razy coś podobnego zdarzyło ci się napisać...
Ty: Co lubisz robić w wolnym czasie?
Marek: Bardzo lubię pracować jako kelner czy kucharz albo nawet sprzedawca (w sumie to tylko dwie ostatnie czynności).

-- po system prompcie:
Ty: Kto twoim zdaniem jest najlepszym piłkarzem świata?
Marek: Niestety, to nie jest tak łatwe sprawdzić.
Ty: Ile zawodników gra w jednej drużynie na boisku?
Marek: To zależy od dyscypliny. 10 lub więcej na pewno.
Ty: Co to jest spalony?
Marek: Spalonej bramki uznaje się gdy strzelający strzelił w sam środek siły
Ty: Który klub wygrał najwięcej razy Ligę Mistrzów?
Marek: Najbardziej znane kluby, które awansowały do Ligi Mistrzów zeszłego sezonu
Ty: Jaka jest twoja ulubiona formacja taktyczna?
Marek: Nie mam żadnego preferowanego stylu gry. Wszystko wygląda inaczej przy różnych składach.

# Zadanie 2

aszkiel@aszkiel:/mnt/c/Users/aszki/uwr/informatyka [computer science]/[26-W] Modele Jezykowe/LM/lab1$ make t2 MODEL=bigger WORDS="pies kot goni"
LM_MODEL=bigger uv run --no-sync -q python word_order.py pies kot goni
Zbior slow: {pies, kot, goni}  (6 unikalnych uszeregowan z 3! mozliwych)

Najbardziej naturalne (top 6):
   -4.2343  Pies goni kot.
   -5.0140  Kot pies goni.
   -5.0461  Kot goni pies.
   -5.0674  Pies kot goni.
   -5.5871  Goni kot pies.
   -5.7141  Goni pies kot.

aszkiel@aszkiel:/mnt/c/Users/aszki/uwr/informatyka [computer science]/[26-W] Modele Jezykowe/LM/lab1$ make t2 MODEL=bigger WORDS="poszlismy szkola do i basen na"
LM_MODEL=bigger uv run --no-sync -q python word_order.py poszlismy szkola do i basen na

Zbior slow: {poszlismy, szkola, do, i, basen, na}  (720 unikalnych uszeregowan z 6! mozliwych)

Najbardziej naturalne (top 10):
   -3.5410  I poszlismy do szkola na basen.
   -3.6202  Poszlismy do szkola i na basen.
   -3.7701  Poszlismy na basen i do szkola.
   -3.8142  I poszlismy na basen do szkola.
   -3.8414  Do szkola i poszlismy na basen.
   -3.9042  Szkola i poszlismy do na basen.
   -3.9177  Do szkola i na basen poszlismy.
   -3.9557  I do szkola poszlismy na basen.
   -3.9821  Poszlismy do na basen i szkola.
   -4.0306  Poszlismy do szkola na basen i.

Najmniej naturalne (bottom 3):
   -5.9090  Basen do na szkola poszlismy i.
   -5.9136  Basen do na poszlismy szkola i.
   -5.9565  Szkola basen do na poszlismy i.

# Zadanie 3 - wyniki

Metoda B: warunkowy log-prob sufiksu etykiety, `P(sufiks | opinia)`, liczony
wzgledem calego kontekstu opinii (nie score calego zdania jak w metodzie A).
Sufiksy: `" To bardzo pozytywna opinia."` / `" To bardzo negatywna opinia."`.
Zero few-shot - zadna z dwoch opinii-przykladow nie trafia do prompta modelu.

## Przebieg

```
make t3 N=40
```

Model: `flax-community/papuGaPT2` (domyslny alias `papuga`).
Dane: `lab1/P1/reviews_for_task3.txt` (400 opinii, 200 GOOD / 200 BAD).
Probka: losowa, zbalansowana, seed=42, N=40+40=80.

## Wynik

**Accuracy: 81.2% (65/80)**

Macierz pomylek:

|            | pred GOOD | pred BAD |
|------------|-----------|----------|
| gold GOOD  | 29        | 11       |
| gold BAD   | 4         | 36       |

Model czesciej myli sie w jedna strone: GOOD->BAD (11/40 = 27.5% bledu) wyraznie
czesciej niz BAD->GOOD (4/40 = 10% bledu). Z przykladow pomylek widac czemu -
wiele pozytywnych opinii medycznych zawiera slowa o negatywnym wydzwieku przy
izolowanym odczycie (np. "zagrozona ciaza", "silny tradzik", "oszpecony"), mimo
ze caloksztalt zdania jest pochwala lekarza. Krotkie/fragmentaryczne opinie
("A plusy : 1.") tez wypadaja gorzej - za malo kontekstu dla modelu.

# Zadanie 4 - wyniki

Pytania (2500, PolEval 2021, `task4_questions.txt`/`task4_answers.txt`)
routowane do 3 grup wg prostych regul zweryfikowanych na calym zbiorze
uczacym, kazda obsluzona inna technika:

- **yesno** (154/2500) - pytania "Czy ..." bez drugiego " czy " w zdaniu
  (odroznia prawdziwe tak/nie od pytan alternatywnych typu "Czy X to A czy
  B?"). Obsluga: model w trybie prawdopodobienstw, ta sama metodologia co
  Metoda B z Zadania 3 - `P("Tak."|pytanie)` vs `P("Nie."|pytanie)`.
- **count** (91/2500) - pytania "Ile .../Ilu ...". Obsluga: czysta
  heurystyka bez modelu - zawsze odpowiedz "2" (najczestsza wartosc wsrod
  odpowiedzi na pytania "Ile/Ilu" w zbiorze uczacym: "dwa"/"dwie" razem
  13/91, przed "cztery" 11/91 i "trzy"/"trzech" 12/91).
- **generate** (2255/2500, probka 120) - reszta pytan (nazwy, osoby, daty,
  pytania alternatywne). Obsluga: model polka (`bigger`), one-shot prompt
  (`Pytanie: ... Odpowiedz: ...`), generowanie greedy, odpowiedz ucinana do
  pierwszego zdania.

## Przebieg

```
make t4 GENN=120
```

Model: `eryk-mazus/polka-1.1b` (domyslny dla `t4`).
Ocena: oficjalny `answer_check_for_task4.py` (niezmodyfikowany, uruchamiany
jako subproces na wygenerowanych plikach `found_answers.txt`/
`correct_answers.txt`).

## Wynik

| grupa    | probka w zbiorze | accuracy |
|----------|-------------------|----------|
| yesno    | 154/154 (pelna)   | 63.0% (97/154) |
| count    | 91/91 (pelna)     | 17.6% (16/91)  |
| generate | 120/2255          | 16.7% (20/120) |

**Szacowana ogolna skutecznosc (wazona wg wielkosci grup w pelnym zbiorze
2500): 19.6%** - wyraznie powyzej "kilku procent" bazowego rozwiazania
wspomnianego w p1.pdf.

Grupa yesno wyraznie najlepsza (63% >> 50% losowego zgadywania) - model w
trybie prawdopodobienstw realnie wylapuje sygnal faktograficzny z samego
pytania. Grupa count to plaski heurystyczny "strzal w ciemno" (~17.6%,
zgodnie z przewidywaniem z rozkladu w danych uczacych). Grupa generate
(dominujaca liczebnie, 90% zbioru) ma najnizsza accuracy wsrod uzytych
technik mimo najwiekszego modelu - to oczekiwane, bo to najtrudniejsza
kategoria (realna wiedza faktograficzna z surowego, nieinstrukcyjnego modelu
1.1B, bez wyszukiwania).

## Aktualizacja - pelny zbior (400/400)

```
make t3 N=200
```

**Accuracy: 83.2% (333/400)** - prawie identycznie jak szacunek z probki 80
(81.2%), czyli ta probka byla dobrze reprezentatywna.

|            | pred GOOD | pred BAD |
|------------|-----------|----------|
| gold GOOD  | 148       | 52       |
| gold BAD   | 15        | 185      |

Ten sam asymetryczny wzorzec bledow co w probce: GOOD->BAD 52/200 = 26% vs
BAD->GOOD 15/200 = 7.5%.

## Auto-detekcja urzadzenia (CUDA / MPS / CPU)

`lab1/P1/sentence_probability.py` wykrywa teraz urzadzenie automatycznie,
zero konfiguracji: `cuda` (jesli dostepne GPU NVIDIA) -> `mps` (Apple
Silicon) -> `cpu` (fallback). Wszystkie pozostale pliki (`chatbot_engine.py`,
`sentiment.py`, `qa.py`) nigdy nie mialy wlasnego hardcoded urzadzenia - albo
importuja `device` z `sentence_probability.py`, albo licza z `model.device`,
wiec zmiana w jednym miejscu objela cala baze kodu. Wykryte urzadzenie jest
teraz tez drukowane na starcie kazdego z 4 skryptow (`run_task1.py`,
`word_order.py`, `sentiment.py`, `qa.py`). Zweryfikowane empirycznie w tej
maszynie (WSL2 + GPU passthrough): `cuda` wykrywane poprawnie.

