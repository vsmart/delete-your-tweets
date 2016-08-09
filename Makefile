install:
	mix deps.get -y
	npm install
	mix compile

start:
	mix phoenix.server

test:
	mix test
