def hanoi(n, skad = 1, dokad = 3):
    return hanoi(n-1, skad, 6-(skad+dokad)) + (f"{skad} -> {dokad}, ") + hanoi(n-1, 6-(skad+dokad), dokad) if n else ""
print(hanoi(5))


# n-1 krazkow z skad na trzeci krazek skad
# potem najwiekszy krazek z skad na dokad
# n-1 krazkow z trzeciego na dokad