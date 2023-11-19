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

# pass in the name of the keyboard subdirectory to build:
# make gen KB=elv
#
# This runs all the build tools for a specific keyboard:
# - run ergogen to generate keyboard outputs
# - run jscad to convert all .jscad case outputs to STL formats
gen:
	ergogen keyboards/$(KB) --output keyboards/$(KB)/output/ --clear && \
	for i in keyboards/$(KB)/output/cases/*.jscad; do npx @jscad/cli@1 "$$i" -of stla; done