def quick_sort(lista, lewy, prawy):
    if lewy < prawy:
        i = lewy
        j = prawy

        # wybieramy punkt odniesienia
        pivot = lista[(lewy + prawy) // 2]
        while True:
            # szukam elementu wiekszego lub rownego piwot stojacego
            # po prawej stronie wartosci pivot
            while pivot > lista[i]:
                i+=1

            # szukam elementu mniejszego lub rownego pivot stojacego
            # po lewej stronie wartosci pivot
            while pivot < lista[j]:
                j -= 1

            if i <= j:
                # funkcja swap zamienia wartosciami tab[i] z tab[j]
                lista[i], lista[j] = lista[j], lista[i]
                i+=1
                j-=1
            else:
                break

        # jesli liczniki sie nie minely to zamień elementy ze soba
        # stojace po niewlasciwej stronie elementu pivot
        if j > lewy:
            quick_sort(lista, lewy, j)
        if i < prawy:
            quick_sort(lista, i, prawy)
    return lista
lista = [1000, 3, 3, 100, 1, 5]
print(quick_sort(lista, 0, len(lista) - 1))