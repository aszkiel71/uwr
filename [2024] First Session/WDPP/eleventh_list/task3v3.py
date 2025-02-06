partie=[]
M=460
ilorazy=[]
with open('wybory.csv', encoding="utf-8") as f:
    lines=f.read().split('\n')
    nazwy=lines[0].split('\t')
    wyniki=[int(x) for x in lines[1].split('\t')]
    sumawyn=sum(wyniki)
    print(sumawyn)
    for i in range(len(wyniki)):
        if wyniki[i]>=5/100*sumawyn:
            partie.append((nazwy[i],wyniki[i]*100/sumawyn))
for partia in partie:
    print(partia)
    for i in range(1,M+1):
        ilorazy.append((partia[1]/i,partia[0]))
ilorazy.sort(reverse=True)
#print(ilorazy)
wynikipartii={nazwa:0 for nazwa,wynik in partie}
for i in range(M):
    wynikipartii[ilorazy[i][1]]+=1
for w in wynikipartii:
    print(w,wynikipartii[w])