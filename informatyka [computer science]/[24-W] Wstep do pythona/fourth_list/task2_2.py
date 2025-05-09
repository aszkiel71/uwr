# task:
# https://projecteuler.net/problem=20
# n! means n * (n-1) * ... 3 * 2 * 1
# For example 10 ! = 10 * 9 * ... * 3 * 2 * 1 = 3628800
# and the sum of the digits in the number 10! is 3 + 6 + 2 + 8 + 8 + 0 + 0 = 27
# Find the sum of digits in the number 100!

def factorial(n):
    result = 1
    for i in range(1, n+1):
        result *= i
    return result

def sum_digits(n):
    result = 0
    for i in str(n):
        result += int(i)
    return result

print(sum_digits(factorial(100)))