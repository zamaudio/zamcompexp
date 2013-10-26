#!/usr/bin/make -f

PREFIX ?= /usr/local
LIBDIR ?= lib
LV2DIR ?= $(PREFIX)/$(LIBDIR)/lv2

OPTIMIZATIONS ?= -msse -msse2 -mfpmath=sse -ffast-math -fomit-frame-pointer -O3 -fno-finite-math-only

LDFLAGS ?= -Wl,--as-needed
CXXFLAGS ?= $(OPTIMIZATIONS) -Wall
CFLAGS ?= $(OPTIMIZATIONS) -Wall

###############################################################################
BUNDLE = zamcompexp.lv2

CXXFLAGS += -fPIC -DPIC
CFLAGS += -fPIC -DPIC

UNAME=$(shell uname)
ifeq ($(UNAME),Darwin)
  LIB_EXT=.dylib
  LDFLAGS += -dynamiclib
else
  LDFLAGS += -shared -Wl,-Bstatic -Wl,-Bdynamic
  LIB_EXT=.so
endif


ifeq ($(shell pkg-config --exists lv2 lv2core || echo no), no)
  $(error "LV2 SDK was not found")
else
  LV2FLAGS=`pkg-config --cflags --libs lv2 lv2core`
endif

ifeq ($(shell pkg-config --exists lv2-gui || echo no), no)
  $(error "LV2-GUI is required ")
else
  LV2GUIFLAGS=`pkg-config --cflags --libs lv2-gui lv2 lv2core`
endif


$(BUNDLE): manifest.ttl zamcompexp.ttl zamcompexp$(LIB_EXT)
	rm -rf $(BUNDLE)
	mkdir $(BUNDLE)
	cp manifest.ttl zamcompexp.ttl zamcompexp$(LIB_EXT) $(BUNDLE)

zamcompexp$(LIB_EXT): zamcompexp.c
	$(CXX) -o zamcompexp$(LIB_EXT) \
		$(CXXFLAGS) \
		zamcompexp.c \
		$(LV2FLAGS) $(LDFLAGS)

zamcompexp.peg: zamcompexp.ttl
	lv2peg zamcompexp.ttl zamcomp.peg

install: $(BUNDLE)
	install -d $(DESTDIR)$(LV2DIR)/$(BUNDLE)
	install -t $(DESTDIR)$(LV2DIR)/$(BUNDLE) $(BUNDLE)/*

uninstall:
	rm -rf $(DESTDIR)$(LV2DIR)/$(BUNDLE)

clean:
	rm -rf $(BUNDLE) zamcompexp$(LIB_EXT) zamcompexp_gui$(LIB_EXT) zamcompexp.peg

.PHONY: clean install uninstall
