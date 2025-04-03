a = 13
tmp = a
n = 0
while tmp > 0:
    n += 1
    tmp = tmp//2

def convert_to_bin(a):
    result = [0]*n
    for i in range(n):
        result[n-i-1] = a%2
        a = a//2
    return result

print(convert_to_bin(a))
def is_palindrome(a, n):
    for i in range(n//2):
        print(a[i], a[n-i-1])
        if a[i] != a[n-i-1]:    return False
    return True

print(is_palindrome(convert_to_bin(a), n))