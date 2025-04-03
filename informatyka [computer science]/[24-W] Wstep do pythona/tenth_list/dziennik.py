przedmiot = 'nieznany'

dziennik = {}
osoby = set()

for x in open('dziennik.txt'):
    L = x.split()
    if len(L) == 0:
        continue
    if x[0] == '#':
        continue
    if L[0] == 'Przedmiot:':
        przedmiot = ' '.join(L[1:])
    else:
        imie, nazwisko, oceny = L
        osoba = imie + ' ' + nazwisko
        osoby.add(osoba)
        if przedmiot not in dziennik:
            dziennik[przedmiot] = {}

        if osoba not in dziennik[przedmiot]:
            dziennik[przedmiot][osoba] = []
        dziennik[przedmiot][osoba] += [int(o) for o in oceny.split(',')]

for p in dziennik:
    print('PRZEDMIOT:', p)
    for o in dziennik[p]:
        print('    ', o + ':', *dziennik[p][o])
    print()

for o in osoby:
    print('Osoba uczniowska', o)
    for p in dziennik:
        if o in dziennik[p]:
            oceny = dziennik[p][o]
            print(p + ':', *oceny, 'średnia=', sum(oceny) / len(oceny))
    print()