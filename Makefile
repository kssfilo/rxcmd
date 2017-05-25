.SUFFIXES:

VERSION=0.4.0

#=

COMMANDS=help pack test clean

#=

DESTDIR=dist
COFFEES=$(wildcard *.coffee)
TARGETNAMES=package.json LICENSE $(patsubst %.coffee,%.js,$(COFFEES)) 
TARGETS=$(patsubst %,$(DESTDIR)/%,$(TARGETNAMES))
ALL=$(TARGETS) $(DESTDIR)/README.md
SDK=node_modules/.gitignore
TOOLS=$(PWD)/node_modules/.bin

#=

.PHONY:$(COMMANDS)

test:$(ALL)|$(DESTDIR)
	cd $(DESTDIR);$(TOOLS)/mocha

pack:$(ALL)|$(DESTDIR)

clean:
	-rm -r $(DESTDIR) node_modules

help:
	@echo "Targets:$(COMMANDS)"

#=

$(DESTDIR):
	mkdir -p $@

$(DESTDIR)/README.md:README.md $(TARGETS)
	cp README.md $@

$(DESTDIR)/package.json:package.json $(SDK)|$(DESTDIR)
	cat $<|$(TOOLS)/partpipe VERKEY@version VERSION@$(VERSION) >$@

$(DESTDIR)/%.js:%.coffee $(SDK)|$(DESTDIR)
ifndef NC
	$(TOOLS)/coffee-jshint -o node $< 
endif
	head -n1 $<|grep '^#!'|sed 's/coffee/node/'  >$@ 
	cat $<|$(TOOLS)/coffee -bcs >> $@

$(DESTDIR)/%:%|$(DESTDIR)
	cp $< $@

$(SDK):package.json
	npm install
	@touch $@
