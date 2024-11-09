VERSION		:= 3.18.1

PREFIX		?=

SBIN_FILES	:= setup-openfortivm\
		setup-openfortivm-interfaces\
		setup-openfortivm-user

BIN_FILES	:= vpn-menu

SCRIPTS		:= $(SBIN_FILES)

FULL_VERSION	:= $(VERSION)


DESC="Openfortivm configuration scripts"
WWW="https://github.com/vuhuy/openfortivm-conf"


SED		:= sed

SED_REPLACE	:= -e 's:@VERSION@:$(FULL_VERSION):g' \
			-e 's:@PREFIX@:$(PREFIX):g' \

.SUFFIXES:	.sh.in .in
%.sh: %.sh.in
	${SED} ${SED_REPLACE} ${SED_EXTRA} $< > $@

%: %.in
	${SED} ${SED_REPLACE} ${SED_EXTRA} $< > $@ && chmod +x $@

.PHONY:	all apk clean install uninstall
all:	$(SCRIPTS) $(BIN_FILES)

apk:	$(APKF)

install: $(BIN_FILES) $(SBIN_FILES)
	install -m 755 -d $(DESTDIR)/$(PREFIX)/bin
	install -m 755 $(BIN_FILES) $(DESTDIR)/$(PREFIX)/bin
	install -m 755 -d $(DESTDIR)/$(PREFIX)/sbin
	install -m 755 $(SBIN_FILES) $(DESTDIR)/$(PREFIX)/sbin

uninstall:
	for i in $(BIN_FILES); do \
		rm -f "$(DESTDIR)/$(PREFIX)/bin/$$i";\
	for i in $(SBIN_FILES); do \
		rm -f "$(DESTDIR)/$(PREFIX)/sbin/$$i";\
	done

clean:
	rm -rf $(SCRIPTS) $(BIN_FILES)
