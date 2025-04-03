from first_session.wstep_do_programowania_w_pythonie.third_list.task1 import is_prime

def numbers(aos, lg):
    sevens=''.join(['7' for i in range(aos)])
    liczby=set()
    for l in range(lg-aos+1):
        r=lg-aos-l
        left=""
        right=""
        firstnum_l=10**(l-1)
        lastnum_l=10**l
        lastnum_r=10**r
        if l==0:
            firstnum_l=0
            lastnum_l=1
        if r==0:
            lastnum_r=1
        for i in range(firstnum_l,lastnum_l):
            left=str(i) if l>0 else ""
            for j in range(0, lastnum_r):
                right=str(j) if r>0 else ""
                right="0"*(r-len(right))+right
                liczba=int(left+sevens+right)
                if is_prime(liczba) and liczba not in liczby:
                    liczby.add(liczba)

    return(f"Znaleziono {len(liczby)} liczb")

print(numbers(7, 10))