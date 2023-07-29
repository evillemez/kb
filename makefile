###
# host commands
###

init:
	git submodule update --init --recursive

build:
	docker build -t elv-kb .

shell:
	docker run --rm -it -v $(shell pwd):/kb elv-kb

###
# container commands
###

# pass in the name of the subdirectory to build:
# make gen KB=elv
gen:
	ergogen keyboards/$(KB) --output keyboards/$(KB)/output/ --clear