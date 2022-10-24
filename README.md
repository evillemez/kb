> NOTE: Next step is to copy `input/elv.yml` to the samaklava project and try the 
> automated build process and autorouting.

This is a working directory for a custom keyboard project.  I'm mostly following along with this video (https://www.youtube.com/watch?v=M_VuXVErD6E&t=74s) and learning/adapting as I go.

* `input/` - config files for keyboards to use with ergogen. Use https://ergogen.cache.works to view/edit
* `output/` - built files from running ergogen
* `ergogen/` - git clone of Ben Vallacks ergogen fork: git@github.com:benvallack/ergogen.git

## Initial setup

Getting setup initially, you need to do the following:

* clone the ergogen repo, or a fork of it: `git clone git@github.com:benvallack/ergogen.git`
* build the docker container for the general build environment: `make build`
* run the container: `make shell`
* install the ergogen deps: `cd ergogen && yarn install`

After that, you should be able to run ergogen within the container to build any keyboards defined in `input/`

## Developing

Use ergogen.cache.works to more easily edit the layout files in `input/` and see changes.  Just copy/paste them back to commit changes.

To run ergogen locally, connect to the container and run it: `node ergogen/src/cli.js input/elv.yml -o output/elv`