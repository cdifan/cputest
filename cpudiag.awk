BEGIN {
	file = "cpudiag.s"
}


$1 ~ /START:/ {
	printf "START:   bsr PRINT_LINE\n" >file
	printf "   dc.b \"START\",0\n" >file
	printf "   align\n" >file
	print "" >file
	print "" >file
	print "" >file
	next
}

$1 ~ /ALL_DONE/ && $2 ~ /bra/ && $3 == "ALL_DONE" {
	printf "ALL_DONE:   bsr PRINT_LINE\n" >file
	printf "   dc.b \"ALL_DONE\",0\n" >file
	printf "   align\n" >file
	printf "   bra.s *\n" >file
	print "" >file
	print "" >file
	print "" >file
	printf "PRINT_LINE:\n" >file
	printf "   move.l (a7)+,a0\n" >file
	printf "   use prtline.d\n" >file
	printf "   move.w a0,d0\n" >file
	printf "   and.w #1,d0\n" >file
	printf "   add.w d0,a0\n" >file
	printf "   jmp (a0)\n" >file
	print "" >file
	print "" >file
	print "" >file
	next
}

$1 == "bsr" && $2 ~ /^op_[A-Z][A-Z][A-Z]/ {
	op = $2
	sub(/op_/, "", op)

#	printf "   bsr PRINT_LINE\n" >file
#	printf "   dc.b \"%s\",0\n", tolower(op) >file
#	printf "   align\n" >file

#	printf "   moveq #'%s',d0\n", tolower(substr(op,1,1)) >file
#	printf "   bsr PRINT_CHAR\n" >file
}

$1 ~ /^op_[A-Z][A-Z][A-Z]/ && $1 !~ /[0-9]:*/ && $1 !~ /FAIL:*/ {
	if (op != "" && !fail) {
		printf "%s_FAIL: bra %s_FAIL\n", op, op >file
		print "" >file
		print "" >file
		print "" >file
	}
	print $1

	op = $1
	sub(/^op_/, "", op)
	sub(/:$/, "", op)
	fail = 0
}

# generate _FAIL label and code
$1 ~ /[A-Z][A-Z][A-Z].*FAIL:*/ {
	Fail();
	fail = 1
	next
}

# Uncomment a few checks...
$1 == "***" {
	ins = $0
	sub(/^\*\*\*/, "", ins)
	if (ins ~ /b[a-z][a-z].*\*/) {
		sub(/\.s/, "", ins)
		sub(/\*/, op "_FAIL", ins)
	}
	print ins >file
	next
}

# replace all * branch targets with the _FAIL label
$1 ~ /^b[a-z][a-z]/ && $2 == "*" {
	ins = $0
	sub(/\.s/, "", ins)
	sub(/\*/, op "_FAIL", ins)
	print ins >file
	next
}

# adjust opcode length verifications to handle non-short branches
$1 ~ /^cmpi\.[wl]$/ && $2 ~ /^#\$67[0-9A-F]*,[0-9][0-9]*\+[A-Z][A-Z][A-Z][A-Z]*/ {
	ins = $0
	sub(/\.[wl]/, ".b", ins)
	sub(/#\$67[0-9A-F]*/, "#$67", ins)
	print ins >file
	next
}

# generate _FAIL label and code
$1 ~ /^\*----------------------/ {
	if (op != "" && !fail) {
		Fail()
		fail = 1
	}
}

{ print $0 >file }

function Fail()
{
	printf "%s_FAIL: bsr PRINT_LINE\n", op, op >file
	printf "   dc.b \"%s_FAIL\",0\n", op >file
	printf "   align\n" >file
	printf "   rts\n" >file
	print "" >file
	print "" >file
	print "" >file
}
