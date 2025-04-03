


def all_partitions(elements):
    """generowanie wszystkich mozliwych podzbiorow"""

    if not elements:
        return [[]]

    element = elements[0]
    rest = elements[1:]

    partitions_of_rest = all_partitions(rest)
    result = []

    for partition in partitions_of_rest:
        #dodajemy element do juz istniejeacego podzbioru
        for i in range(len(partition)):
            new_partition = partition[:]
            new_partition[i] = new_partition[i] | {element}
            result.append(new_partition)
        #dodajemy element jako nowy podzbior
        result.append(partition + [{element}])

    return result


def equivalence_relations(input_set):
    """ generwoaenie liste wsyzsktich rel. rownowaznosci dla zbioru"""

    elements = list(input_set)
    partitions = all_partitions(elements)
    #usuwanie duplikatow
    return [sorted([set(subset) for subset in partition], key=lambda x: min(x)) for partition in partitions]
# key = lambda odpowiada za to jak porownwyac elementy podczas sortowania
# kazdy element ktory ma byc posortowany lub porownyuwany jest najpierw przepuszczany przez funkcje podana w key
# np:
# dla tablciy liczb [-3, 5, -1, 4]
# jak posortujemy po key = lamdba x : abs(x)) to posrtuejmy po ich wartosci bezwgledenj
# a u nas sorotwanie jest wg najmniejszego el. w danej  klasie, a lambda x: min(x) to funkcja ktora dla kazdego zbioru x zwraca najnneijszy el.
# czyli np [{1, 2}, {3}] ~ [{3}, {1, 2}]



example_set = {1, 2, 3}
if __name__ == "__main__":
    print(equivalence_relations(example_set))
