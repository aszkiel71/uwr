# Zadanie: Stylizacja Nowoczesnego Bloga (10p)

Twoim zadaniem będzie ostylowanie strony bloga zgodnie z poniższymi wytycznymi. Stylizacja powinna zostać zaimplementowana wyłącznie przy użyciu CSS. Możesz edytować kod HTML tylko w wyznaczonych miejscach opisanych przez komentarz. Ostateczny wygląd strony powinien zgadzać się z [obrazkiem](sol.png) ([pełna rozdzielczość](sol_fullres.png)).

Pobierz [cały folder](./) w którym znajduje sie ten plik. Swoje rozwiązanie umieścisz w pliku [style.css](style.css).

Postaraj się, by używać klas tam gdzie to możliwe.

## Materiały

W rozwiązaniach przyda się umiejętność posługiwania się technikami `float`, `flex` oraz `grid`, pozycjonowania (`sticky`, `absolute`, `relative`) a także świadomość [Stacking Contextu](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_positioned_layout/Stacking_context) oraz [Block Formatting Contextu](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_display/Block_formatting_context).

W rozwiązaniu wzorcowym zostały użyte następujące własności:

`box-sizing`, `margin`, `padding`, `font-size`, `text-align`, `background-color`, `box-shadow`, `display`, `justify-content`, `position`, `top`, `list-style`, `text-decoration`, `color`, `width`, `height`, `align-items`, `clear`, `font-size`, `border`, `border-radius`, `gap`, `object-fit`, `color`, `border-radius`, `z-index`, `position`, `background-color`, `text-align`, `color`

Oraz selektory nie będące klasami:

`*`, `body`, `h1`, `h2`, `h3`, `:nth-of-type()`

## Wstęp

Ustaw wszystkim elementom `box-sizing` na `border-box` i usuń zarówno margines, jak i padding z `body`. Następnie ustaw rozmiary czcionek:

- `h1` powinna mieć rozmiar `2.5` rozmiaru czcionki `root` elementu.
- `h2` powinna mieć rozmiar `1.8` rozmiaru czcionki `root` elementu i być wyśrodkowana.
- `h3` powinna mieć rozmiar `1.5` rozmiaru czcionki `root` elementu.

Na koniec usuń marginesy z `blog__header` oraz ustaw `content__main` by miało kolor tła `#ececf7` oraz padding `1rem` od góry oraz `2rem` od lewej i prawej.

## Header

- Header powinien mieć białe tło oraz cień: `0` offsetu na `x`, `3px` na `y`, `4px` blur-radiusu oraz mieć kolor `rgba(0, 0, 0, 0.1)`.
- Zawartość headera powinna być oddalona od brzegów o `2rem`.
- Tekst powinien być po lewej stronie, natomiast linki po prawej, ze spacją pomiędzy.
- Linki nie powinny mieć bullet-pointów, nie powinny mieć marginesów ani paddingów, i powinny być wyświetlone jako `flex`.
  - Każdy link powinien być czarny, nie być podkreślony, i mieć `100px` szerokości.
  - Link powinien pokrywać pole o szerokości `100px` i pełnej wysokości: całe te pole powinno być klikalne.
  - Link po najechaniu powinien mieć tło `#f1f1f1`.
  - Tekst linku powinien być wyśrodkowany, zarówno poziomo, jak i pionowo.
- Header powinien zawsze być na górze ekranu, niezależnie od tego, gdzie na stronie się znajdujemy.

<details>
  <summary>Podpowiedź Do Ułożenia Elementów</summary>

> Użyj Flexboxa. Do pozycjonowania elementów ustaw odpowiednio wartość `justify-content`.

</details>

<details>
  <summary>Podpowiedź Do Linków</summary>

> Usuń `list-style`, `margin` i `padding` z listy (klasa `navigation`). Ustawianie wysokości/szerokości linka nic nie daje bo link jest wyświetlony jako `inline-block`: ustaw go jako `flexbox`, z odpowiednią szerokością i pełną wysokością. Dzięki temu łatwo będzie również wyśrodkować napis. Na koniec musisz jedynie upewnić się że link może urosnąć do 100% wysokości: jego rodzice być może też powinny mieć odpowiednio ustawione `height`

</details>

<details>
  <summary>Podpowiedź Ostatniego Punktu</summary>

> Należy "przykleić" header. Żeby to zrobić, należy ustawić odpowiedni argument w `position`, który, żeby zadziałał, musi mieć również podaną wartość `top` (lub analogiczną).

</details>

## Sekcja "blog"

W tej sekcji ustaw obrazki, by opływały tekst: w pierwszym i ostatnim artykule obrazek powinien opływać tekst z prawej, a drugi z lewej. Upewnij się, że artykuły nie najeżdżają na siebie, to znaczy, że obrazki nie wjeżdżają w nie swoje sekcje. Podpisy pod obrazkami powinny mieć rozmiar `0.8` rozmiaru czcionki `root` elementu i być wyśrodkowane.

<details>
  <summary>Podpowiedź</summary>

> Jeśli chodzi o opływanie, może przydać się pseudoklasa `:nth-of-type`. Zastosowana na klasie `article` może wybrać odpowiedni (pierwszy i ostatni albo drugi) artykuł, z którego można dostać się do obrazka. Co do "nie wjeżdżania", może przydać się własność `clear`.

</details>

Na końcu sekcji znajduje się `warning`. Powinien mieć on kolor tła `#f4c5b7`, obramówkę o kolorze `#faf9f8` i wielkości `3px`, z zaokrągleniem obramówki `20px`. Tekst "Warning!" powinien być wyśrodkowany, a obrazek powinien opływać tekst z lewej.

W momencie ustawienia opływania obrazka, prawdopodobnie wyjechał on "poza" tło warninga. Nie jest to pożądane zachowanie i należy naprawić ten problem, nie zmieniając html'a.

<details>
  <summary>Podpowiedź</summary>

> Ma to dużo wspólnego z [BFC](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_display/Block_formatting_context). Na stronie znajduje się wyjaśnienie tego zjawiska, a także przykład bezpośrednio odnoszący się do tego problemu, wraz z przykładami rozwiązania.

</details>

## Sekcja "gallery"

Z pomocą `grid`a stwórz galerię. Elementy galerii powinny być oddzielone od siebie o `1rem`. W galerii mamy 3 kolumny oraz dwa wiersze. Obrazki wewnątrz galerii powinny w pełni wypełniać wysokość i szerokość dostępnego miejsca (niezależnie od rozmiaru ekranu), a żeby rozwiązać potencjalne problemy ze złymi wymiarami, własność `object-fit` powinna być ustawiona na `cover`.

Pozycje obrazków powinny być następujące:

- Pierwszy obrazek powinien być w pierwszej kolumnie i rozciągać się na 2 wiersze.
- Drugi obrazek powinien znajdować się w pierwszym wierszu i trzeciej kolumnie.
- Trzeci obrazek powinien znajdować się w drugim wierszu, zaczynać się w drugiej kolumnie i rozciągać na dwie kolumny.
- Czwarty obrazek powinien ustawić się automatycznie.

## Sekcja "posts"

Ostatnią sekcją jest sekcja "posts". W tej sekcji ustaw następujące zasady:

- Każdy obrazek powinien mieć `300px` szerokości i `200px` wysokości. Aby obrazki zachowały odpowiednie proporcje własność `object-fit` powinna być ustawiona na `cover`
- Zawartość sekcji (`posts__wrapper`) powinna mieć wysokość `300px`. Drugi post powinien być przesunięty o `250px` od lewej względem pierwszego
- Każdy post składa się z **trzech elementów**:
  1. **Obrazek** – powinien znajdować się na spodzie.
  2. **Podpis** – powinien:
     - Być umieszczony na dole obrazka (nie pod nim!).
     - Mieć pełną szerokość.
     - Mieć kolor tła `royalblue` i biały, wyśrodkowany tekst.
  3. **Element "i"** – powinien:
     - Mieć rozmiar `30x30` pixeli.
     - Mieć kolor tła `salmon`.
     - Zawierać biały, wyśrodkowany tekst.
     - Być całkowicie zaokrąglony.
- **Zachowanie postów**:
  - Posty powinny na siebie **nachodzić**.
  - Domyślnie pierwszy post powinien znajdować się na górze.
  - Po najechaniu na drugi post, to on powinien znaleźć się na górze.
  - **Nie używaj wartości `z-index` większej niż `1`**.

<details>
  <summary>Podpowiedź</summary>

> Możesz wykorzystać `position: absolute` do ułożenia elementów postu oraz `position: relative` do kontrolowania ich wzajemnego położenia.  
> Aby zmieniać kolejność warstw po najechaniu, spróbuj zastosować `z-index` w dynamiczny sposób.

</details>
