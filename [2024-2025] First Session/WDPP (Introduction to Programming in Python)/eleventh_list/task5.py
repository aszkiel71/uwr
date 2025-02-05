def in_tree(tree, e):
    if tree == []:
        return False
    n, left, right = tree
    if n == e:
        return True
    if e < n:
        return in_tree(left, e)
    return in_tree(right, e)


def tree_to_list(tree):
    if tree == []:
        return []
    n, left, right = tree
    return tree_to_list(left) + [n] + tree_to_list(right)


def add_to_tree(e, tree):
    if tree == []:
        tree.append(e)
        tree.append([])
        tree.append([])
        return
    v, left, right = tree

    if v == e:
        return
    if e < v:
        add_to_tree(e, left)
    else:
        add_to_tree(e, right)


class Set:
    def __init__(self, *elems):
        self.tree = []
        for e in elems:
            # add_to_tree(e, self.tree)
            self.add(e)

    def add(self, e):
        add_to_tree(e, self.tree)

    def __contains__(self, e):
        return in_tree(self.tree, e)

    # !---!
    def __len__(self):
        return len(tree_to_list(self.tree))

    def __and__(self, other):
        if not isinstance(other, Set):
            raise NotImplemented
        result = Set()
        for e in tree_to_list(self.tree):
            if e in other:
                result.add(e)
        return result

    def __sub__(self, other):
        result = Set()
        for e in tree_to_list(self.tree):
            if e not in other:
                result.add(e)
        return result

    def __gt__(self, other):
        if len(tree_to_list(self.tree)) > len(other):
            return True
        return False

    def __eq__(self, other):
        if len(tree_to_list(self.tree)) == len(other):
            return True
        return False

    def __lt__(self, other):
        if len(tree_to_list(self.tree)) < len(other):
            return True
        return False

    def __le__(self, other):
        if len(tree_to_list(self.tree)) <= len(other):
            return True
        return False

    def __ge__(self, other):
        if len(tree_to_list(self.tree)) >= len(other):
            return True
        return False


    # !! ----------

    def __or__(self, other):
        for e in other:
            self.add(e)
        return self

    def __str__(self):
        return '{' + ', '.join(str(n) for n in tree_to_list(self.tree)) + '}'


s1 = Set(1, 2, 3, 8, 9, 333)
s2 = Set(-1, 0, 5, 8, 3, 333, 100, 10)

print(len(s1))
print(s1 & s2)
print(s1 - s2)
print(s2 - s1)
print(s2 > s1)