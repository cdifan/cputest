gawk -f cpufull.awk cputest.s
r68 -q -n cpufull.s -o=cpufull.r -l >cpufull.lst
ren cpufull.r cpufull.r
l68 -r=180000 cpufull.r -o=cpufull.rom -s >cpufull18.map
move cpufull.rom cpufull18.rom
l68 -r=400000 cpufull.r -o=cpufull.rom -s >cpufull40.map
move cpufull.rom cpufull40.rom
xcopy /y cpufull*.rom ..\..\rom
