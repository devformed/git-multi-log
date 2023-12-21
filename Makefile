PREFIX ?= /usr/local

.PHONY: install
install:
		install -d $(DESTDIR)$(PREFIX)/bin
		install -d $(DESTDIR)$(PREFIX)/etc
		install -m 755 mglog $(DESTDIR)$(PREFIX)/bin/