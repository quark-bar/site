include config.mk

.SUFFIXES: .rc .kg .eps .png

all: $(IMG)

puttit: $(IMG)
	mv $(IMG) ../../img/daygame_cost_benefit

.eps.png:
	convert -chop 0x180 $< $@
	rm $<

%.eps: draw_all.kg
	kg -l ./$< -e '.x(0)'

clean:
	rm -f $(IMG)

.PHONY: puttit clean
