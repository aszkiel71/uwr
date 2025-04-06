# Zadanie: Blog (10p)

Twoim zadaniem będzie stworzenie semantycznie poprawnego bloga o kwiatach, zgodnego z [obrazkiem](./blog.png) ([pełna rozdzielczość](./blog_fullres.png)). Poza konkretnymi przypadkami (określonymi bezpośrednio w opisie zadania poniżej) treść bloga nie będzie sprawdzana, o ile składowe elementy (paragrafy tekstu, obrazki, linki) będą zachowane.

W zadaniu **nie możesz używać** CSS'a.

## Materiały

W celu wykonania zadania, dobrze jest najpierw zapoznać się z tagami znajdującymi się na [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Element).

W szczególności, na potrzeby zadania, warto jest zapoznać się z następującymi tagami: `<!DOCTYPE>`, `<a>`, `<address>`, `<article>`, `<body>`, `<figcaption>`, `<figure>`, `<footer>`, `<h1>`, `<h2>`, `<h3>`, `<head>`, `<header>`, `<html>`, `<img>`, `<li>`, `<main>`, `<meta>`, `<nav>`, `<p>`, `<section>`, `<source>`, `<title>`, `<ul>`, `<video>`.

Są to tagi użyte we wzorcowym rozwiązaniu: twoje również powinno z nich korzystać.

W razie potrzeby, posiłkuj się dokumentacją i wypisanymi wyżej tagami. Warto także zapoznać się z [dobrymi praktykami](https://github.com/hail2u/html-best-practices).

---

## Szkielet

Blog powinien zawierać odpowiednią strukturę: deklarację `<!DOCTYPE html>`, tag `html`, zawierający metadane `head` i ciało `body`. Sekcja główna powinna być otoczona tagiem `main`, nagłówek strony tagiem `header` a stopka tagiem `footer`.

## Metadane

W tagu `html` powinna znaleźć się deklaracja języka bloga, a w tagu `head` określenie metadanych. Minimalne wymagane metadane to określenie `charset`, `description`, `keywords` i `author`, a także Tytuł strony, która będzie się wyświetlać w zakładce przeglądarki.

## Nagłówek

Nagłówek powinien zawierać tytuł strony (Tekst: `Welcome to the Flower Enthusiast Blog!` na obrazku). Powinien również zawierać listę odnośników. Odnośniki powinny być funkcjonalne i przekierowywać na odpowiednią sekcję strony: w tym celu użyj odpowiednio przygotowanego linku, i odpowiednio ustawionych atrybutów `id` w sekcjach.

## Stopka

W stopce znaleźć się powinny dane kontaktowe (adres email) oraz Copyright. Adres email po kliknięciu powinien umożliwiać wysłanie emaila.

## Zawartość

Zawartość główna zawiera cztery sekcje: trzy z zawartością i jedną z filmikiem. W odpowiednich sekcjach są odnośniki oraz obrazki. Każdy odnośnik powinien przekierowywać na odpowiednią stronę, otwierając nową zakładkę (lub nowe okno). Każdy obrazek powinien zawierać podpis, zdefiniowaną szerokość (nie za pomocą CSSa) oraz tekst alternatywny, który pojawi się, gdy obrazek się nie załaduje.

### Sekcja: About This Blog

Sekcja zawiera tekst i [obrazek](https://img2.10bestmedia.com/Images/Photos/380636/GettyImages-611102194_55_660x440.jpg).

### Sekcja: Popular Flowers

Sekcja składa się z dwóch podsekcji: o różach (wraz z [obrazkiem](https://i.redd.it/l32vdfvx2hc31.jpg) oraz [linkiem](https://www.almanac.com/plant/roses)) oraz o tulipanach (wraz z [obrazkiem](https://i.pinimg.com/564x/1d/53/a6/1d53a6017c59ef2ed718042bf3ea7c27.jpg) i [linkiem](https://www.gardeningknowhow.com/ornamental/bulbs/tulips))

### Sekcja: Gardening Tips

Składa się z dwóch podsekcji, o sadzeniu (wraz z [linkiem](https://www.bhg.com/gardening/flowers/)) oraz podlewaniu (z [linkiem](https://www.gardeningknowhow.com/garden-how-to/watering))

### Sekcja: Videos

Składa się z jednego filmiku. Filmik powinien mieć ustawioną szerokość, i pokazywać wersję [webm](https://interactive-examples.mdn.mozilla.net/media/cc0-videos/flower.webm) jeśli wspierana, w przeciwnym wypadku wersję [mp4](https://interactive-examples.mdn.mozilla.net/media/cc0-videos/flower.mp4). Jeśli obie nie są wspierane, należy wyświetlić tekst alternatywny pokazujący linki do tych filmików.
