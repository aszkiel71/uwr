---
title: lista 5 MP (01.04.25)

---

_______________
    created by Wojtek Aszkielowicz 353873
_______________





lista 5 MP (01.04.25)
https://skos.ii.uni.wroc.pl/pluginfile.php/79258/mod_resource/content/1/lista-5.pdf    

https://web.stanford.edu/class/archive/cs/cs103/cs103.1156/tools/cfg/


zadanie 1

P = {S -> (S)S, S -> (S, S -> eps}
1) S -> (S)S
2) S -> (S
3) S -> eps

![image](https://hackmd.io/_uploads/S1rbdFUa1g.png)
Niejednoznaczna, bo:
![image](https://hackmd.io/_uploads/SJleOYU61x.png)


Czyli jezyk, ktory generuje nawiasy:
-> poprawnie zagniezdzone (S)S
-> niezamkniete (S
lub oczywiscie puste, dla S -> eps

S -> M  | U
M -> (S)M | eps
U -> (S)U | (S





______________________________

Rozwazmy co innego:

P = {S -> (S)S, S -> (S), S -> eps}


Niejednoznacznosc, bo :
![image](https://hackmd.io/_uploads/BJpRqwdpJl.png)





Jezyk ten generuje ciag znakow poprawnie zagniezdzonych nawiasow, czyli kazdy otwarty nawias jest zamkniety i nie wystepuje zamkniecie nawiasy, bez otwartego wczesniej nawiasu.

Aby uzyskac jednoznacznosc wystarczy poprawic na:

S -> (S)S
S -> epsilon

Co do kontekstu:

if (E) S   oraz    if (E) S else S

Niejednoznacznosc gramatyki moze prowadzic do problemow z parsowaniem zagniezdzonych instr. warunkowych np:

if (E1) if (E2) S1 else S2

Mozna to interpretowac tak, ze else S2 jest powiazany z pierwszym ifem badz z drugim.

https://en.wikipedia.org/wiki/Dangling_else

https://pl.wikipedia.org/wiki/Dangling_else_problem

W c++ regula pierwszesnstwa, czyli else odnosi sie do najstarszego if'a nie posiadajacego elsa
W pythonie lepiej rozwiazane.

w ocamlu nie ma dangling else, bo wymusza uzycie else w kazdym wyrazeniu warunkowym.

np

if x < y then
    if y < z then
        ACTION1
    else
        ACTION2
else 
    ACTION3

![image](https://hackmd.io/_uploads/B1jdLqH61l.png)

Ocaml drze sie ze tHiS eXpReSsIoN hAs TyPe iNt bUt An ExPrEsSiOn wAs eXpEcTeD oF tYpE uNiT bEcAuSe iT iS tHe ReSuLt oF a CoNdItIoNaL wItH nO eLsE bRaNcH.

![image](https://hackmd.io/_uploads/rkOmj5STye.png)


Dowod jednoznacznosci:

Niech phi := zbior wszystkich slow gen. przez gramatyke
Pokazemy, ze :for all: w z phi istnieje dokladnie jedno wyprowadzenie.

A) slowo puste jest generowany tylko przez jedna produkcje S -> eps, wiec jest jednoznaczne

B) Zalozmy, ze dla dowolnego slowa w Phi o dlugosci mniejszej niz n jest true.
Rozwazmy slowo w phi o dlugosci n > 0:

n > 0, wiec to nie epsilon
jedyna produkcja, ktora generuje niepuste slowa to  S->(S)S
Czyli kazde slowo w Phi o dlugosci n musi miec strukture (S1)S2, gdzie S1, S2 naleza do Phi
S1, S2 to podciag slowa o dlugosci n, ich dlugosci sa mniejsze niz n.
Czyli z zal. S1, S2 sa wyprowadzane jednoznaczenie.
Poniewaz produkcja S -> (S)S jest  jedyna produkcja, ktora generuje takie slowo, to cale slowo (S1)S2 ma jednoznaczne drzewo wyprowadzenie (~E drzewo z takim samym wyprowadzeniem)
Zatem spelniony rowniez dla n.
ckd 

__________________

zadanie 2

alfabet to {0, 1} 

Wyrażenia regularne ->
alternatywny sposób opisywania języków regularnych.
Bardziej zrozumiały. Jest to jakiś rodzaj gramatyki/języka.




1) Wszystkie slowa w ktorych po wsytepiniu jedynki nie wystepja zadne zera

EBNF:
https://pl.wikipedia.org/wiki/Notacja_EBNF

![image](https://hackmd.io/_uploads/r1kjysHTJg.png)
 (gwiazdka kleenego)


w EBNF'ie:

<slowo> ::= { 0 } [ { 1 } ]
czyli
"0" -> dowolna liczba wystepien "0"
["1"] -> opcjonalnie pojawia sie 1 

![image](https://hackmd.io/_uploads/rJ_4yoBT1x.png)

po bożemu:

S -> A | AB
A -> 0A | epsilon
B -> 1 B | 1,
gdzie S -> symbol startowy, A i B -> symbole pomocnicze



2) Wszystkie słowa postaci jak w poprzednim podpunkcie, ale zawierające
co najmniej jedną jedynkę oraz co najmniej jedno zero.

W EBNF'ie:

<slowo> ::=  0 [{ 0 }] 1 [{ 1 }] 


lub:

S -> 0 A
A -> 0 A | B
B -> 1 C
C -> 1 C | eps

   

3) Dopełnienie języka z poprzedniego podpunktu, tzn. wszystkie słowa nie
będące postaci jak w poprzednim podpunkcie.

///<wyraz> ::= { 0 } | { 1 } | { 0 | 1 } 1 { 0 | 1 } 0 { 0 | 1 }  /////

![image](https://hackmd.io/_uploads/H1_pGjSaJe.png)

///tu cos jeszcze pokombinowac trzeba, by jezyk rozpinal wszystkie slowa


S -> A | B | C
A -> 0A | eps
B -> 1B |e
C -> X1Y0Z
X -> 0X | 1X | eps
Y -> 0Y | 1Y | eps
Z -> 0Z | 1Z | eps
    
4) Wszystkie słowa zawierajace parzystą liczbę zer i dowolną liczbę jedynek

<wyraz> :== [{ 1 }] [{00}] [{ 1 }] [{010}] [{1}]

S -> eps | 1S | 0A
A -> 0S | 1A

5) Wszystkie słowa w których nie występują dwie następujące po sobie
jedynki, tzn. podciągi postaci 11.

<wyraz> :== [ {0} ] [{ 101 }] [ {0} ] [ {010} ] [ {0} ] ///tu cos jeszcze pokombinowac trzeba, by jezyk rozpinal wszystkie slowa

S -> eps | 0S -> 1A
A -> 0S



__________________
zadanie 3
Funkcja przyjmujaca stringa i sprawdza czy nawiasy sa popraniw epnawiasowane

![image](https://hackmd.io/_uploads/Hy1h4irT1l.png)

koncept:
przejsc po stringu i ze zmienna ,,balance" ustawiona poczatkowa na 0
1) jezeli 's' = ( to wtedy balance++
2) jezeli 's' = ) to balance--
i w kazdym kroku if balance < 0 then false (zamknelismy wiecej nawiasow niz otworzylismy)
i na koncu if balance != 0 then false (otworzylismy wiecej nawiasow niz zamknelismy)

let rec parsen_ok str =
    let arr_str = String.to_seq str |> List.of_seq in
        let rec it arr_str balance =
            match arr_str with
            | [] -> if balance <> 0 then false else true
            | x :: xs -> if balance < 0 then false 
                                  else if x = '(' then it xs (balance + 1) 
                                  else it xs (balance - 1)
        in it arr_str 0;;

![image](https://hackmd.io/_uploads/ry_z_srTJx.png)

_____________
zadanie 4

3 rozne countery analogicznie


![image](https://hackmd.io/_uploads/BkivniS61g.png)

____________
zadanie 5
Zmodyfikuj interpreter z wykładu tak, aby wyrażenia były obliczane przy użyciu
liczb zmiennopozycyjnych float zamiast całkowitych int. Należy też zmodyfikować lekser tak, aby akceptował stałe liczbowe z kropką dziesiętną (np.
6.25).

Zmiany:

wszedzie w dzialaniach np (+) -> (+.) itp
dodajemy analogicznie do INT'ow


_____________
zadanie 6
    
Podsumowanie:

changelog:

-> dodanie tokenu E w lexer.mll -> Aby rozpoznać symbol e (liczbe eulera).

-> dodanie tokenu E w parser.mly -> Aby parser mógł rozpoznać token e.

-> dodanie produkcji dla E w parser.mly -> ocaml sobie przeksztalca tokenu E na exp1.0 czyli na liczbe eulera.

-> modyfikacja eval_op w main.ml -> wyrazenie Const _ (i potem zwraca eulera)

-> ustalenie priortyetrow operatorow czyli potegowanie >>> mnozenie dzielenie itp.

-> dodanie operatora ** w lexer.mll zeby rozpoznał operator **.

-> dodanie produkcji dla '**' w parserze aby parser przetworzyl nam to (a w zasadzie aby mogl przetworzyc


Lekser ogolnie jest odpowiedzialny za wstepne przetwarzaniu tekstu zrodowego. czyli  przeksztalcamy ciag znakow na tokeny, ktore potem przetwarza parser.

tokeny to np slowa kluczowe -> log, if, *, ** itp oraz liczby, nawiasy, przeicnki
potem rozpoznaje ,,wzorzec" w kodzie i generuje odpowiedni token.

u nas w pliku rozpoznaje liczby calkowite i floaty, obsluguje operatory (*, **, /, +, -), obsluguje slowa kluczowqe (log, e), czyta nawiasy itp

Parser robi analize tego co mu podeslal lekser. Jest odpwiedxzialny za analize skladoniowa (tak bylo na wykladzie chyba).

Czyli parser odbiera otkeny i sprawdza czy to co lekser mu wyslal ma w ogole sens (czyli czy podpasowywuje sie pod reguly w gramatyce)
Gramatyka definiuje jak te tokeny moga byc ze soba laczone, aby cale wyrazneie mialo sens.
tworzy jakies drzewo skladniowe, ale jak one dokladnie wyglada to na wykladzie bylo chyba pokazane. 

u nas w pliku parser:
-> analizuje wyrazenia ktore zdefiniwoalismy czyli mnozenie dodawanie itp
-> obsluguje nawiasy
-> rozpoznaje operatory
-> rozumie funckje, zmienne itp czyli log, e

Przyklad kolaboracji:

Lekser przeksztalca 3 + 5 na tokeny [FLOAT 3.0, PLUS, FLOAT 5.0]
Parses widzi cos takiego i buduje drzewko i tworzy strukture pokroju:
Binop(Add, Float 3.0, Float 5.0).

potem eval().


_________
zadanie 7


Omowienie kodu:

1. Definiujemy gramatyke
-> kazdy nieterminal ma przypisane mozliwe rozwiniecie
-> kazde rozwiniecie sklada ise z listy terminali i/lub nieterminali

2. Rozpoczynamy od symbolu startowego (podanego)
Sprawdzamy, czy symbol jest terminalem czy nieterminalem
-> Terminal (zwracamy go jako tekst)
-> Nieterminal (szukamy jego rozwiniecia, losow)

3. Rekurencyjnie laczymy elementy itp az nie bedziemy mieli pelnego slowa (/zdania) ktore sie sklada jedynie z temrinali i je zwracamy

