install:
	mix deps.get
	npm install
	mix compile

start:
	mix phoenix.server

test:
	mix test
