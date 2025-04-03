load n
store i

loop:
  load i
  jzero end

  load x[i]
  write x[i]
  load i
  sub 1
  store i
  jump loop

end:
  halt
