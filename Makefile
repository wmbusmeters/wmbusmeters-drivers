
$(shell mkdir -p build)

DRIVERS=$(basename $(notdir $(wildcard wmbusmeters.drivers.d/*)))
COMPACT=$(addprefix build/,$(DRIVERS))

all: $(COMPACT)
	@echo Done

$(COMPACT): build/% : wmbusmeters.drivers.d/%.xmq
	@xmq $< delete /driver/test to-xmq --compact > $@
	@echo IN $< OUT $@

PROG?=wmbusmeters

test:
	@mkdir -p build/test
	@for i in $(wildcard wmbusmeters.drivers.d/*) ; do ./test.sh $(PROG) $$i ; done
