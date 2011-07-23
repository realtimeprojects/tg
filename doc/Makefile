# build all targets.
#
# for now: build main.cpp.
all: tgdefinition

tgdefinition: tgdefinition.html
    
%.pdf: %.asciidoc
	a2x -f pdf $*.asciidoc

%.html: %.asciidoc
	asciidoc $*.asciidoc
