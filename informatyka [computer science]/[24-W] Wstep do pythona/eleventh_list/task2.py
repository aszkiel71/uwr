def permutation_normal_form(s):
    opted = []
    dict = {}
    counter = 1
    for i in s:
        if i not in opted:
            opted.append(i)
            dict[i] = counter
            counter += 1
    result = ''
    for i in s:
        result += str(dict[i])
        result += "-"
    return result[:len(result) - 1]

print(permutation_normal_form('indianin'))