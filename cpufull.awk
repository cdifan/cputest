BEGIN {
	file = "cpufull.s"
}

$1 == "ALL_DONE:" && $2 ~ /^bra/ && $3 == "ALL_DONE" {
	print "ALL_DONE: stop #$2700" >file
	print "   BRA.S ALL_DONE" >file
	next
}

# Uncomment a few checks...
$1 == "***" {
	ins = $0
	sub(/^\*\*\*/, "", ins)
	if (ins ~ /b[a-z][a-z].*\*/)
	{
		sub(/\.s/, "", ins)
		sub(/\*/, "*+4", ins)
	}
	print ins >file
	next
}

# replace all * branch targets with *+2
$1 ~ /^b[a-z][a-z]/ && $2 == "*" {
	ins = $0
	sub(/\.s/, "", ins)
	sub(/\*/, "*+4", ins)
	print ins >file
	next
}

# adjust opcode length verifications to handle non-self branches
$1 ~ /^cmpi\.[wl]$/ && $2 ~ /^#\$67[0-9A-F]*,[0-9][0-9]*\+[A-Z][A-Z][A-Z][A-Z]*/ {
	ins = $0
	sub(/\.[wl]/, ".b", ins)
	sub(/#\$67[0-9A-F]*/, "#$67", ins)
	print ins >file
	next
}

{ print $0 >file }

