def F(n):
    if n % 2 == 0:
        return n/2
    else:
        return 3*n + 1

def energy_of_number(n):
    result = 0
    tmp = n
    while tmp != 1:
        tmp = F(tmp)
        result += 1
    return result


def median(a):
    a = sorted(a)
    if len(a) % 2 == 0:     return (a[len(a)//2-1] + a[len(a)//2])/2
    else:                   return a[len(a)//2]


def average(a):
    return sum(a) / len(a)

def analiza_collatza(a, b):
    array = list(range(a, b+1))
    energies = []
    max_energy = energy_of_number(a)
    min_energy = energy_of_number(a)
    
    for i in array:
        energies.append(energy_of_number(i))

    for i in energies:
        if i > max_energy:
            max_energy = i
        if i < min_energy:
            min_energy = i
    print(energies)
    return (f"Average energy is {average(energies)}, the median energy is {median(energies)}, the max energy is {max_energy}, the min energy is {min_energy}")


print(analiza_collatza(1, 15))
