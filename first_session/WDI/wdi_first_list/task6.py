x = int(input("Enter first value  :  "))
y = int(input("Enter second value :  "))

def nwd(x, y):
    if x == 0 or y == 0:
        result = 0
    else:
        while(x % y != 0):
            tmp = x % y
            x = y
            y = tmp
        result = y
    return result

if x == y == 0:
    print("0")
elif x == 0 or y == 0:
    print("Doesn't exist.")
else:
    print(x*y/nwd(x, y))


