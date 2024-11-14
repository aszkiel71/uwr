from first_session.wstep_do_programowania_w_pythonie.third_list.task1 import is_prime

def primary_factorial(number):
    factorization = []
    for i in range(1, number//2):
        if number % i == 0 and is_prime(i):     factorization.append(i)
    return set(factorization)

print(primary_factorial(121))