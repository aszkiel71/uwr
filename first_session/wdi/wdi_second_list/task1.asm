read a, b, c
load a
add b
sub c
jgtz check 2
jump nie
check2:
    load a
    add c
    sub b
    jgtz check3
    jump nie

check3:
    load b
    add c
    sub a
    jgtz tak
    jump nie

tak:
    write "TAK"
    halt

nie:
    write: "NIE"
    halt