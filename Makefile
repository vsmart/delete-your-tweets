install:
	mix deps.get
	mix compile

start:
	mix phoenix.server
