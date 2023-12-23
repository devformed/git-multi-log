.PHONY: install
install:
		install -d /usr/local/bin
		install -m 755 mglog /usr/local/bin
		install -d /usr/local/etc
		install -m 766 /usr/local/etc/mglog.cfg