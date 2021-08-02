r68 -q -n cputest.s -o=cputest.r -l >cputest.lst
ren cputest.r cputest.r
l68 -r=180000 cputest.r -o=cputest.rom -s >cputest18.map
move cputest.rom cputest18.rom
l68 -r=400000 cputest.r -o=cputest.rom -s >cputest40.map
move cputest.rom cputest40.rom
xcopy /y cputest*.rom ..\..\rom
