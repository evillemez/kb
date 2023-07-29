###
# host commands
###

init:
	git submodule update --init --recursive

build:
	docker build -t elv-kb .

shell:
	docker run --rm -it -v $(shell pwd):/kb elv-kb

