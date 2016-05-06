OPENRESTY_PREFIX=/usr/local/openresty-debug

PREFIX ?=          /usr/local
LUA_INCLUDE_DIR ?= $(PREFIX)/include
LUA_LIB_DIR ?=     $(PREFIX)/lib/lua/$(LUA_VERSION)
INSTALL ?= install

export TEST_NGINX_NO_CLEAN=1

.PHONY: all test install

all: ;

install: all
	$(INSTALL) -d $(DESTDIR)/$(LUA_LIB_DIR)/resty
	$(INSTALL) lib/resty/ini.lua $(DESTDIR)/$(LUA_LIB_DIR)/resty

test:
	PATH=$(OPENRESTY_PREFIX)/nginx/sbin:$$PATH prove -I../../test-nginx/lib -r t/

