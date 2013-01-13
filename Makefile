.PHONY: static node
NM=node_modules
JSLIB=static/js/lib

JADE=$(NM)/jade/bin/jade
COFFEE=$(NM)/coffee-script/bin/coffee

LODASH=$(NM)/lodash/lodash.min.js
SOCKETIO=$(NM)/socket.io/node_modules/socket.io-client/dist/socket.io.js

all: static node jades

modules:
	npm install
	cp $(LODASH) $(JSLIB)

static:
	$(COFFEE) -c static/js/*.coffee
node:
	$(COFFEE) -c *.coffee
jades:
	$(JADE) static/html/*.jade

start:
	python2 -m SimpleHTTPServer 8000

clean:
	rm -f *.js
	rm -f static/js/*.js
	rm -f static/html/*.html
