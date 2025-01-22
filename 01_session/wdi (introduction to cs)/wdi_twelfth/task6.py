def is_valid_onp(expression):
    stack = []
    operators = {'+', '-', '*', '/'}

    for char in expression:
        if char.isdigit():
            stack.append(int(char))
        elif char in operators:
            if len(stack) < 2:
                return False #za malo argumentow na stosie
            stack.pop()
            stack.pop()
            stack.append(0)
        else:
            return False

    return len(stack) == 1

print(is_valid_onp(['5', '6', '+', '7', '*']))