
$(shell mkdir -p build/test)

PROG?=wmbusmeters

database:
	@./generate.sh $(PROG)

web:
	@mkdir -p build/web
	@for i in $(wildcard wmbusmeters.drivers.d/*) ; do xmq $$i render-html --darkbg > build/web/$$(basename $${i}).html; done
	@./generate_index.sh > build/web/index.html

tests:
	@echo -n "// Generated " > build/generated_tests.xmq
	@date +%Y-%m-%d_%H:%M >> build/generated_tests.xmq
	@for i in $(wildcard wmbusmeters.drivers.d/*) ; do xmq $$i select /driver/test to-xmq >> build/generated_tests.xmq; done

install: database tests
	@grep -v "// Generated " < build/generated_database.cc > build/a
	@grep -v "// Generated " < ../wmbusmeters/src/generated_database.cc > build/b
	@if ! diff build/a build/b ; then \
            cp build/generated_database.cc ../wmbusmeters/src ; echo "Installed db"; else echo "No changes db." ; fi
	@grep -v "// Generated " < build/generated_tests.xmq > build/a
	@grep -v "// Generated " < ../wmbusmeters/tests/generated_tests.xmq > build/b
	@if ! diff build/a build/b ; then \
            cp build/generated_tests.xmq ../wmbusmeters/tests/generated_tests.xmq ; echo "Installed tests." ; else echo "No changes test." ; fi

test:
	@for i in $(wildcard wmbusmeters.drivers.d/*) ; do ./test.sh $(PROG) $$i ; done

.PHONY: database web tests install test
