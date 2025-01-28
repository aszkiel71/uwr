def is_valid_onp(expression):
    stack = []
    operators = {'+', '-', '*', '/'}
    counter = 0
    for char in expression:
        if char.isdigit():
            counter += 1
        elif char in operators:
            if counter < 2:
                return False #za malo argumentow na stosie
            counter-=1

        else:
            return False

    return counter == 1

print(is_valid_onp(['5', '6', '+', '7', '*']))