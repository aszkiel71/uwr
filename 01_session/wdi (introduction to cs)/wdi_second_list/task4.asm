load 0
store m
petla:
    load m
    add 1
    load x[m]
    sub x[m+1]
    jltz NIE
    loop_checker

loop_checker:
    load n
    store tmp
    sub m
    jzero end
    jump petla

end:
    write "TAK"

NIE:
    write "NIE"