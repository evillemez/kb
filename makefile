# host commands
###
# host commands
###

build:
	docker build -t elv-kb .

# connect to shell in container from host
shell:
	docker run --rm -it -v $(shell pwd):/kb elv-kb

###
# container commands - run these from within the container
###

gen:
	node ergogen/src/cli.js input/elv.yml -o output/elv