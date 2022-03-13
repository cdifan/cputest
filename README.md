# 68000 CPU tests for CD-i

Based on the file [MC68000_test_all_opcodes.X68](https://github.com/MicroCoreLabs/Projects/blob/master/MCL68/MC68000_Test_Code/MC68000_test_all_opcodes.X68)
from MicroCoreLabs [MC68000_Test_Code](https://github.com/MicroCoreLabs/Projects/MCL68/MC68000_Test_Code) project.

The source code has been modified to work with the Microware OS-9 assembler.

It was also converted into a CD-i system ROM image suitable for running on a CD-i emulator
or on actual CD-i hardware by downloading it into RAM using [CD-i Link](https://www.cdiemu.org/cdilink/).

## Versions

There are three versions of the test:

``cputest`` is the basic 68000 cpu test, suitable for emulator testing.
It loops on the first failed test.

``cpudiag`` is the same test but modified for diagnostic output.
It displays a **START** message, followed by the name of each failed test,
ending with an **ALL_DONE** message.
All output is sent to the 68070 on-chip serial port.

``cpufull`` runs the full test, suitable for trace generation.
It will ignore all test failures and end with a `stop` instruction.

## Building

For each test, a Windows ``.bat`` batch file is included to build the binary output files.
1. For tests other then the basic ``cputest``, the batch file starts with building the corresponding
assembly ``.s`` source file from ``cputest.s`` using a GNU AWK ``.awk`` script file.
2. The Microware OS-9 Assembler ``r68`` is then run to producate a relocatable ``.r``
object file and an assembly ``.lst`` listing file.
4. Next the Microware OS-9 Linker ``l68`` is run to create ``.rom`` files based at
addresses 0x180000 (usable on Mini/Maxi-MMC CD-i players)
and 0x400000 (usable on Mono-based players). A symbol ``.map`` file is also produced.
5. For ``cpudiag`` a downloadable ``.mod`` file based at address 0x8000 is also produced.
This file can be downloaded into a CD-i player with the following CD-i Link command:<br>
``cdilink -w -n -a 8000 -d cpudiag.mod -x 8400 -t``

## Caveats

No CD-i hardware or emulator currently passes all of the tests; the failures are all in the
verification of the condition code register contents. There are probably issues with both
the test and the emulators, but it's hard to fix this as the failing tests run large numbers
of test instructions combining the resulting condition codes and only verify the combined result.

The only way to get this fixed is verification of a full instruction trace (such as generated
by the ``cpufull`` test) on actual hardware to find out which exact condition code bits
on which instruction(s) fail the test.

## Discussion

Discussion of these tests belongs in the **#homebrow-and-dev** channel of the
[Philips CD-i Community](https://discord.gg/TKPejTfw6D) Discord server.
