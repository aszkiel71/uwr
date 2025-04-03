def is_prime(a):
    a = int(a)
    if a < 2:
        return False
    else:
        for i in range(2, int(a**0.5) +1):
            if a%i == 0:
                return False
    return True





if __name__ == "__main__":

    def if_three_sevens(a):
        if "777" in str(a):
            return True
        return False


    def if_prime_and_thee_sevens(a):
        if if_three_sevens(a) and is_prime(a):
            return True
        return False


    counter = 0
    for i in range(1, 100000):
        if if_prime_and_thee_sevens(i):
            print(i)
            counter += 1
    print(f"There are {counter} prime and lucky numbers")
