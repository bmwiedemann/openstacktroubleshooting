.PHONY: all clean

DOT := $(shell find img/ -name '*.dot')
SVG := $(shell find img/ -name '*.svg')
DIA := $(shell find img/ -name '*.dia')
DOT_SVG := $(patsubst %.dot, %.svg, $(DOT))
SVG_PNG := $(patsubst %.svg, %.png, $(SVG))
DIA_PNG := $(patsubst %.dia, %.PNG, $(DIA))
PNG :=  $(DIA_PNG) $(DOT_SVG)

%.pdf: %.odp
	libreoffice --headless --convert-to pdf $<
%.odp: %.md	template.odp $(PNG)
	odpdown \
	-p 1 \
	--content-master No-Logo_20_Content \
	--break-master Break \
	$< template.odp $@

all: presentation.odp

%.svg: %.dot
	dot -Tsvg -o $@ $<
img/%.png: img/%.svg
	convert -density 200 -transparent white $< $@

# ugly, but will do
img/%.PNG: img/%.dia
	dia -e $@ -t svg $<

clean:
	rm -f presentation.odp
	rm -f presentation.pdf
	rm -f img/*png
	rm -f img/*PNG

showpdf: presentation.pdf
	evince $< &
show: presentation.odp
	ooimpress $< &
