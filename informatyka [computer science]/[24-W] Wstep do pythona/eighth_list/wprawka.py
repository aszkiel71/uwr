def is_safe(a):
    rosnacy = 0

    if a[0] < a[1]:
        rosnacy = True

    for i in range(0, len(a)-1):
        if rosnacy:
            if a[i+1] <= a[i] or (a[i+1] - a[i]) not in (0, 1, 2, 3):
                return False
        else:
            if a[i+1] >= a[i] or (a[i+1] - a[i]) not in (0, -1, -2, -3):
                return False
    return True

file = open("ciagi.txt", 'r')
data = []
for line in file:
    data.append(line.strip())

def to_array(s):
    array = []
    tmp_str = ""
    switcher = 1
    for i in s:
        if i not in (' ', ''):
            switcher = 1
        if i in (' ', ''):
            switcher = 0
            array.append(int(tmp_str))
            tmp_str = ""
        if switcher:
            tmp_str += i
    if tmp_str:
        array.append(int(tmp_str))
    return array




counter = 0

for j in data:
    if is_safe(to_array(j)):
        counter += 1
print(counter)