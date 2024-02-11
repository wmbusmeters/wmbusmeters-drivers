
$(shell mkdir -p build/test)

PROG?=wmbusmeters

database:
	@./generate.sh $(PROG)

web:
	@mkdir -p build/web
	@for i in $(wildcard wmbusmeters.drivers.d/*) ; do xmq $$i render-html --darkbg > build/web/$$(basename $${i}).html; done
	@./generate_index.sh > build/web/index.html

tests:
	@echo -n // > build/generated_tests.xmq
	@date +%Y-%m-%d_%H:%M >> build/generated_tests.xmq
	@for i in $(wildcard wmbusmeters.drivers.d/*) ; do xmq $$i select /driver/test to-xmq >> build/generated_tests.xmq; done

install: build_database build_tests
	cp build/generated_database.cc ../wmbusmeters/src
	cp build/generated_tests.xmq ../wmbusmeters/tests/generated_tests.xmq

test:
	@for i in $(wildcard wmbusmeters.drivers.d/*) ; do ./test.sh $(PROG) $$i ; done
