NM=node_modules
JSLIB=static/js/lib

SERVE_BIN=$(NM)/serve/bin/serve
JADE_BIN=$(NM)/jade/bin/jade
COFFEE_BIN=$(NM)/coffee-script/bin/coffee

LODASH_LIB=$(NM)/lodash/lodash.min.js
SOCKETIO_LIB=$(NM)/socket.io/node_modules/socket.io-client/dist/socket.io.min.js
ZEPTO_LIB=$(NM)/zepto/zepto.min.js

SP=.serve.pid
CP=.watch.pid

JADE=$(wildcard *.jade static/html/*.jade)
HTML=$(JADE:.jade=.html)
%.html: %.jade
	$(JADE_BIN) < $< --path $< > $@

COFFEE=$(wildcard *.coffee static/js/*.coffee)
JS=$(COFFEE:.coffee=.js)
%.js: %.coffee
	$(COFFEE_BIN) -c $<

all: $(HTML) $(JS)

node_modules:
	npm install
	cp $(LODASH_LIB) $(JSLIB)
	cp $(SOCKETIO_LIB) $(JSLIB)
	cp $(ZEPTO_LIB) $(JSLIB)

run_server:
	$(SERVE_BIN) & echo "$$!" > $(SP)
kill_server:
	kill $(shell cat $(SP))
	rm $(SP)

run_watch:
	$(COFFEE_BIN) -cw . & echo "$$!" > $(CP)
kill_watch:
	kill $(shell cat $(CP))
	rm $(CP)

clean:
	rm -f $(HTML) $(JS)

mrproper: clean
	rm -rf $(NM)
	rm -f $(JSLIB)/*.js

.PHONY: node_modules run_server kill_server run_watch kill_watch clean mrproper
