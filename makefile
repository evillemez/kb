# host commands
build:
	docker build -t elv-kb .

shell:
	docker run --rm -it -v $(shell pwd):/kb elv-kb

# container commands
gen:
	node ergogen/src/cli.js input/elv.yml -o output/elv