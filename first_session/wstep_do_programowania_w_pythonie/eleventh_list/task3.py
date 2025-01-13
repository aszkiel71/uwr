"""
Wyniki wyborow w 2023:
1. Pis 194 mandaty
2. KO 157 mandatów
3. TD 65 mandatów
4. NOWA LEWICA 26 mandatów
5. KONF 18 mandatów
"""
# jak ktos kiedys bedzie czytac to zadanie to przepraszam za nazwy zmiennych ale juz tak mnie to zadanie denerwowalo
# ze zostal brute force i kilka bezsensownych petli ktore moznaby zmiescic w jednej



from first_session.wstep_do_programowania_w_pythonie.tenth_list.task5 import equivalence_relations


def dhondt():
    file = open("wybory.txt", "r")
    wyniki = []
    const_wyniki = []
    for line in file:
        wyniki.append(line.strip("\n").split(" "))
        const_wyniki.append(line.strip("\n").split(" "))
    # zamiany ilosci glosow na int

    for i in range(len(wyniki)):
        wyniki[i][1] = int(wyniki[i][1])
        const_wyniki[i][1] = int(const_wyniki[i][1])
    #print(wyniki)

    # numer 'okrazenia' (czyli ile mandatow juz przydzielono)
    circle = {}
    for i in range(len(wyniki)):
        circle[wyniki[i][0]] = 1
    #print(circle)
    przyznane_mandaty = 0

    while True:
        if przyznane_mandaty == 460:
            break

        # kolejka po partiach, by sprawdzic komu przyznac mandat
        # tmp_partia -> partia, ktorej przyznamy mandat

        tmp_partia = ""
        max_votes = 0

        for i in range(len(wyniki)):
            if wyniki[i][1] > max_votes:
                max_votes = wyniki[i][1]
                tmp_partia = wyniki[i][0]


        # po petli mamy zaktualizowana partie, ktora otrzyma mandat
        for i in range(len(wyniki)):
            if wyniki[i][1] == max_votes:
                wyniki[i][1] = const_wyniki[i][1] // circle[tmp_partia]



        circle[tmp_partia] += 1  # dodajemy mandat, nasze 'i' we wzorze
        przyznane_mandaty += 1

        #print(wyniki)
    circle = {key: value - 1 for key, value in circle.items()}
    #print(circle)
        #print(tmp_partia)

   # print(wyniki)
    partie = []
    for i in range(len(wyniki)):
        partie.append(wyniki[i][0])


    # a) koalicja z wiekszoscia bez PiSu
    warianty_a = []
    tab = equivalence_relations(partie)
    for i in range(len(tab)):
        case = tab[i]
        for partie in case:
            tmp_mandaty = 0
            for partia in partie:
                if partia == "PIS":
                    break
                else:
                    tmp_mandaty += circle[partia]
            if tmp_mandaty > 230:
                warianty_a.append(case)

    results_a = []

    for wariant in warianty_a:
        for wariant2 in wariant:
            if "PIS" not in wariant2:
                tmp_suma = 0
                for i in wariant2:
                    tmp_suma += circle[i]
                if tmp_suma > 230 and wariant2 not in results_a:
                    wariant2.add(tmp_suma)
                    results_a.append(wariant2)


    penultimate_results_a_vol_11209123 = []
    for wariant in results_a:
        tmp_tab = []
        mandaty = 0
        for wariant2 in wariant:
            if not str(wariant2).isnumeric():
                tmp_tab.append(wariant2)
            else:
                mandaty = wariant2
        if [tmp_tab, mandaty] not in penultimate_results_a_vol_11209123:
            penultimate_results_a_vol_11209123.append([tmp_tab, mandaty])
    print(f'Zadanie 3: {circle}\n')
    print("a) Wszystkie mozliwosci koalicjantow bez pisu :")
    for wariant, mandaty in penultimate_results_a_vol_11209123:
        new_str = ""
        for partia in wariant:
            new_str += partia
            new_str += " "
        new_str = new_str.strip(" ")
        print(f"Partie: {new_str}, mają razem {mandaty} mandatów")


    #------------------------------------------#
    print("\n")
    # a) koalicja z wiekszoscia bez PiSu
    partie = []
    for i in range(len(wyniki)):
        partie.append(wyniki[i][0])

    #--------------------------------------------#
    # b)

    warianty_b = []
    tab = equivalence_relations(partie)
    for i in range(len(tab)):
        case = tab[i]
        for partie in case:
            tmp_mandaty = 0
            for partia in partie:
                tmp_mandaty += circle[partia]
            if tmp_mandaty > 230:
                warianty_b.append(case)

    results_b = []

    for wariant in warianty_b:
        for wariant2 in wariant:
            tmp_suma = 0
            for i in wariant2:
                tmp_suma += circle[i]
            if tmp_suma > 230 and wariant2 not in results_b:
                wariant2.add(tmp_suma)
                results_b.append(wariant2)

    tablica = []
    for wariant in results_b:
        tmp_tab = []
        mandaty = 0
        for wariant2 in wariant:
            if not str(wariant2).isnumeric():
                tmp_tab.append(wariant2)
            else:
                mandaty = wariant2
        if [tmp_tab, mandaty] not in tablica:
            tablica.append([tmp_tab, mandaty])
    print("b) Wszystkie mozliwosci koalicjantow:")
    for wariant, mandaty in tablica:
        new_str = ""
        for partia in wariant:
            new_str += partia
            new_str += " "
        new_str = new_str.strip(" ")
        print(f"Partie: {new_str}, mają razem {mandaty} mandatów")


    return circle


dhondt()



