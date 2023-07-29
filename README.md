This projects contains the definition and build environment for generating a custom keyboard using Ergogen.

* `keyboards/` - each directory here is a separate keyboard meant to be used as input for ergogen. There may be git submodules in some keyboard directories for side-loading ergogen footprints from other places.
* `archive/` - previous attempts at experimenting with possible layouts. Kept for personal reference.  Some use older versions of the ergogen config, are none are expected to be complete or actually work.

## Initial setup

Getting setup initially, you need to do the following:

* initialize submodules recursively, and/or run `make init`
* build the docker container for the general build environment: `make build`
* run the container: `make shell`
* install the ergogen via `yarn` from within the container: `yarn install`

After that, you should be able to run ergogen within the container to build any of the keyboads defined in  `keyboards/`.

## Developing

Use ergogen.cache.works to more easily edit the `config.yml` file in `keyboard/` and see changes.  Just copy/paste them back to commit changes.

To run ergogen locally, connect to the container and run the ergogen command to generate the files:

* `make shell` to connect to container
* Run erogen on any keyboard defined in a subdirectory, or use the makefile shortcut from the root directory: `make gen KB=elv`

Inspect the makefile if you want the see the exact commands and arguments.

## Resources & Prior Art

Major thanks for, and inspiration from the following resources:

* Ergogen:
  * https://ergogen.xyz
  * https://ergogen.cache.works
* Build guide by FlatFootFox: https://flatfootfox.com/ergogen-introduction
* Experiments in automatic build systems & autorouting:
  * https://github.com/soundmonster/samoklava
  * https://github.com/tbaumann/typematrix_split_ergogen
  * https://github.com/ceoloide/corney-island
