#a, b, c -> 1, 2, 3 miejsce w akumualtorze
load 1
add 2
sub 3
jgtz check2
jump nie
check2:
    load 1
    add 3
    sub 2
    jgtz check3
    jump nie

check3:
    load 2
    add 3
    sub 1
    jgtz tak
    jump nie

tak:
    write ="TAK"
    halt

nie:
    write ="NIE"
    halt