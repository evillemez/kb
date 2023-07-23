This projects contains the definition and build environment for generating a custom keyboard using Ergogen.

* `keyboard/` - config file for keyboard to use with ergogen. Use https://ergogen.cache.works to view/edit.  Submodule in here contains footprints from another repo.
* `output/` - built files from running ergogen
* `archive/` - previous attempts kept for reference, some using older versions of ergogen config, so not expected to work.
* `ergogen/` - git submodule of ergogen repo

## Initial setup

Getting setup initially, you need to do the following:

* initialize submodules recursively, and/or run `make init`
* build the docker container for the general build environment: `make build`
* run the container: `make shell`
* install the ergogen deps from within the container: `cd ergogen && yarn install`

After that, you should be able to run ergogen within the container to build they keyboard in `keyboard/`

## Developing

Use ergogen.cache.works to more easily edit the `config.yml` file in `keyboard/` and see changes.  Just copy/paste them back to commit changes.

To run ergogen locally, connect to the container and run the ergogen command to generate the files:

* `make shell` to connect to container
* `make gen` to run ergogen and build the keyboard defined in `keyboard/`

Inspect the makefile if you want the see the exact commands and arguments.