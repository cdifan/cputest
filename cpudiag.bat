gawk -f cpudiag.awk cputest.s
r68 -q -n cpudiag.s -o=cpudiag.r -l >cpudiag.lst
ren cpudiag.r cpudiag.r
l68 -r=180000 cpudiag.r -o=cpudiag.rom -s >cpudiag18.map
move cpudiag.rom cpudiag18.rom
l68 -r=400000 cpudiag.r -o=cpudiag.rom -s >cpudiag40.map
move cpudiag.rom cpudiag40.rom
l68 -r=8000 cpudiag.r -o=cpudiag.mod
ren cpudiag.mod cpudiag.mod
xcopy /y cpudiag*.rom ..\..\rom
