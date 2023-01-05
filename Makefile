
sed-space:
	sed 's/^[ \t]*//' input.md > output.md
find-sed-all:
	LC_ALL=c find ./pages -type f |  xargs -I@ sed 's/^[ \t]*//' @
find-and-remove-private-content:
	LC_ALL=C find ./test -type f | xargs -I@ sed -i '' '/^[ \t]{1,}- #\+BEGIN_PRIVATE/,/^[ \t]{1,}- #\+END_PRIVATE/d' @
find:
	LC_ALL=C find ./pages -type f

remove-slash-from-filename:
	for filename in ./test/*.md; do \
		[ -f "$$filename" ] || continue ;\
		mv "$$filename" "$${filename//%2F/}" ;\
	done ;\