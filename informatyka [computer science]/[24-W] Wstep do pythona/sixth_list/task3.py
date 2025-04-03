from first_session.wdi.wdi_sixth_list.task5 import sito

def primary_factorial(n):
    sito_n = sito(n)
    result = set()
    for i in sito_n:
        if i != "" and n % int(i) == 0:      result.add(i)
    return result

print(primary_factorial(321923))