# task:
# https://projecteuler.net/problem=7
from first_session.wstep_do_programowania_w_pythonie.third_list.task1 import is_prime


# Find 10001st prime no.
# by listing the first six prime numbers: 2, 3, 5, 7, 11, 13, we can see that the 6th prime is 13.


target = 10001
counter = 0
i = 0
while True:
    if is_prime(i) == True:
        counter += 1
        if counter == target:
            print(i)
            break
    i += 1