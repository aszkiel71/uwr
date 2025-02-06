from task1 import is_prime

counter = 0
for i in range(1000000000, 9999999999):
    if 7*"7" in str(i) or 8*"7" in str(i) or 9*"7" in str(i) or 10*"7" in str(i):
        print(i, is_prime(i), counter)
        if is_prime(i):     counter += 1