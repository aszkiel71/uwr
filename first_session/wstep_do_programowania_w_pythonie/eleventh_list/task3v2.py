def dhondt():
    file = open("wybory.txt", "r")
    wyniki = []
    for line in file:
        wyniki.append(line.strip("\n").split(" "))

    # zamiany ilosci glosow na int
    dict = {}
    for i in range(len(wyniki)):
        wyniki[i][1] = int(wyniki[i][1])
        dict[wyniki[i][0]] = int(wyniki[i][1])
    print(wyniki)
    print(dict)

    M = 460
    ilorazy_pis = []
    ilorazy_ko = []
    ilorazy_td = []
    ilorazy_left = []
    ilorazy_konf = []

    # PIS, KO, TD, LEWICA, KONFEDERACJA

    for i in range(1, M+1):
        ilorazy_pis.append(dict["PIS"]//i)
        ilorazy_ko.append(dict["KO"]//i)
        ilorazy_td.append(dict["TD"]//i)
        ilorazy_left.append(dict["LEWICA"]//i)
        ilorazy_konf.append(dict["KONFEDERACJA"]//i)

    podzial_sil = {}
    for i in range(len(wyniki)):
        podzial_sil[wyniki[i][0]] = 0
    print(podzial_sil)

    mandaty = 0
    while True:
        if mandaty == 460:
            break

        for i in range(len(wyniki)):
            tmp_max = max(ilorazy_pis[0], ilorazy_ko[0], ilorazy_td[0], ilorazy_left[0], ilorazy_konf[0])
            if tmp_max == ilorazy_pis[0]:
                podzial_sil["PIS"] += 1
                ilorazy_pis.pop(0)

            elif tmp_max == ilorazy_ko[0]:
                podzial_sil["KO"] += 1
                ilorazy_ko.pop(0)

            elif tmp_max == ilorazy_td[0]:
                podzial_sil["TD"] += 1
                ilorazy_td.pop(0)

            elif tmp_max == ilorazy_left[0]:
                podzial_sil["LEWICA"] += 1
                ilorazy_left.pop(0)

            elif tmp_max == ilorazy_konf[0]:
                podzial_sil["KONFEDERACJA"] += 1
                ilorazy_konf.pop(0)


            mandaty += 1

    print(podzial_sil)

dhondt()

