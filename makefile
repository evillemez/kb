# host commands
###
# host commands
###

build:
	docker build -t elv-kb .

init:
	git submodule update --init --recursive

# connect to shell in container from host
shell:
	docker run --rm -it -v $(shell pwd):/kb elv-kb

###
# container commands - run these from within the container
###

gen:
	ergogen/src/cli.js keyboard/ -o output/keyboard/