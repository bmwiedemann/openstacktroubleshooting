.PHONY: all clean

SVG := $(shell find img/ -name '*.svg')
DIA := $(shell find img/ -name '*.dia')
SVG_PNG := $(patsubst %.svg, %.png, $(SVG))
DIA_PNG := $(patsubst %.dia, %.PNG, $(DIA))
PNG :=  $(DIA_PNG) $(SVG_PNG)

%.pdf: %.odp
	libreoffice --headless --convert-to pdf $<
%.odp: %.md	template.odp $(PNG)
	odpdown \
	-p 1 \
	--content-master No-Logo_20_Content \
	--break-master Break \
	$< template.odp $@

all: presentation.odp

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

show: presentation.odp
	ooimpress $< &
