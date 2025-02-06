def znajdz_minimum(tablica, lewy, prawy):

    if lewy == prawy:
        return tablica[lewy]

    srodek = (lewy + prawy) // 2


    lewy_min = znajdz_minimum(tablica, lewy, srodek)
    prawy_min = znajdz_minimum(tablica, srodek + 1, prawy)


    if lewy_min < prawy_min:
        return lewy_min
    else:
        return prawy_min

    