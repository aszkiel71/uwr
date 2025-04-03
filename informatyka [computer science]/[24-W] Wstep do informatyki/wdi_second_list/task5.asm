read n, m
load n
store tmp
sub m
jltz action
petla

action:
    load tmp, n
    load n, m
    load m, tmp
    petla

petla:
    load n
    mod m
    sub m
    jltz action2
    load m
    jgtz petla
    write n
    halt

action2:
    load tmp, n
    load n, m
    load m, tmp
    load m
    jgtz petla
    write n
    halt