load 1
store n
load a[n]
store tmp
div 2
store q
load a
sub q
load a[n]
store switcher
load q
store determinant
check_another


check_another:
    load n
    add 1
    store n
    load a[n]
    store tmp
    div 2
    store q
    load a[n]
    sub q
    load a[n]
    store switcher
    load switcher
    sub determinant
    jzero check_another
    jgtz end
    jltz end

end:
    write("NIE")
    halt