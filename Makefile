VERSIONCMD = git describe --dirty --tags --always 2> /dev/null
VERSION := $(shell $(VERSIONCMD) || cat VERSION)

PREFIX ?= /usr/local
BINPREFIX ?= $(PREFIX)/bin
MANPREFIX ?= $(PREFIX)/share/man

MANPAGE = auto-inhibit.1

all: $(MANPAGE)

$(MANPAGE): man/$(MANPAGE).pod
	pod2man -n=auto-inhibit -c=auto-inhibit -r=$(VERSION) $< $(MANPAGE)

install:
	mkdir -p $(DESTDIR)$(BINPREFIX)
	cp -p auto-inhibit $(DESTDIR)$(BINPREFIX)
	mkdir -p $(DESTDIR)/etc
	cp -p auto-inhibit.conf $(DESTDIR)/etc
	mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	cp -p $(MANPAGE) $(DESTDIR)$(MANPREFIX)/man1

uninstall:
	rm -f $(DESTDIR)$(BINPREFIX)/auto-inhibit
	rm -f $(DESTDIR)/etc/auto-inhibit.conf
	rm -f $(DESTDIR)$(MANPREFIX)/man1/iniq.1

clean:
	rm -f $(MANPAGE)

test:
	$(MAKE) -C test

.PHONY: all install uninstall clean test
