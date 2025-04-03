from collections import defaultdict as dd


def rozklad(s):
    distribution = dd(int)
    for i in s.lower():
        distribution[i] += 1
    return distribution




""" if s2 in s1 """
""" exempli gratia -> let s1 = lokomotywa, s2 = kot, then True"""
def czy_ukladanka(s1, s2):
    S1 = rozklad(s1)
    S2 = rozklad(s2)
    for i in S2:
        if S2[i] > S1[i]:
            return False
    return True

if __name__ == '__main__':
    print(czy_ukladanka('lokomotywa', 'motyloa'))
