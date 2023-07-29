#!/bin/sh
# EXAMPLE USAGE: ./build.sh elv

container_cmd=docker
# Ensure we switch to the /board working directory, pointing it
# at the repo root (when running the script from there)
container_args="-w /board -v $(pwd):/board --rm"

# get the keyboard to build as an arg from the CLI
keyboard_name=$1
keyboard_path="keyboards/${keyboard_name}"

# Cleanup the output folder or KiCad will error out
rm -rf ${keyboard_path}/output

# Generate unrouted PCBs with Ergogen (definition in package.json)
echo "\n\n>>>>>>>>> RUNNING ERGOGEN >>>>>>>>>>\n\n"
${container_cmd} run ${container_args} elv-kb -c "ergogen ${keyboard_path} --output ${keyboard_path}/output/ --clear"

# Define the boards to autoroute and export, and the plates
boards="${keyboard_name}"
plates="backplate frontplate controller_overlay"

# Define the fabrication profile and additional flags
fab=jlcpcb
flags=--no-assembly

# Define the pcbdraw style
pcbdraw_style=set-black-hasl

for plate in ${plates}
do
    echo "\n\n>>>>>> Processing $plate <<<<<<\n\n"
    echo "Export Gerbers"
    mkdir -p ${keyboard_path}/output/gerbers/${plate}
    ${container_cmd} run ${container_args} yaqwsx/kikit:v1.1.2 kikit fab ${fab} ${flags} --no-drc ${keyboard_path}/output/pcbs/${plate}.kicad_pcb ${keyboard_path}/output/gerbers/${plate}
    mv ${keyboard_path}/output/gerbers/${plate}/gerbers.zip ${keyboard_path}/output/gerbers/${plate}.zip
    echo "Generate PCB images"
    mkdir -p ${keyboard_path}/output/images
    ${container_cmd} run ${container_args} yaqwsx/kikit:v1.1.2 pcbdraw plot --style ${pcbdraw_style} ${keyboard_path}/output/pcbs/${plate}.kicad_pcb ${keyboard_path}/output/images/${plate}.svg
done

for board in ${boards}
do
    echo "\n\n>>>>>> Processing $board <<<<<<\n\n"
    ${container_cmd} run ${container_args} soundmonster/kicad-automation-scripts:latest /bin/sh -c "mkdir -p $HOME/.config/kicad; cp /root/.config/kicad/* $HOME/.config/kicad"
    if [ -e ${keyboard_path}/output/pcbs/${board}.kicad_pcb ]; then
        echo Export DSN 
        ${container_cmd} run ${container_args} soundmonster/kicad-automation-scripts:latest /usr/lib/python2.7/dist-packages/kicad-automation/pcbnew_automation/export_dsn.py ${keyboard_path}/output/pcbs/${board}.kicad_pcb ${keyboard_path}/output/pcbs/${board}.dsn    
    fi
    if [ -e ${keyboard_path}/output/pcbs/${board}.dsn ]; then
        echo Autoroute PCB
        ${container_cmd} run ${container_args} soundmonster/freerouting_cli:v0.1.0 java -jar /opt/freerouting_cli.jar -de ${keyboard_path}/output/pcbs/${board}.dsn -do ${keyboard_path}/output/pcbs/${board}.ses
    fi
    if [ -e ${keyboard_path}/output/pcbs/${board}.ses ]; then
        echo "Import SES"
        ${container_cmd} run ${container_args} soundmonster/kicad-automation-scripts:latest /usr/lib/python2.7/dist-packages/kicad-automation/pcbnew_automation/import_ses.py ${keyboard_path}/output/pcbs/${board}.kicad_pcb ${keyboard_path}/output/pcbs/${board}.ses --output-file ${keyboard_path}/output/pcbs/${board}_routed.kicad_pcb
    fi
    if [ -e ${keyboard_path}/output/pcbs/${board}_routed.kicad_pcb ]; then
        echo "DRC check"
        ${container_cmd} run ${container_args} soundmonster/kicad-automation-scripts:latest /usr/lib/python2.7/dist-packages/kicad-automation/pcbnew_automation/run_drc.py ${keyboard_path}/output/pcbs/${board}_routed.kicad_pcb ${keyboard_path}/output/pcbs/${board}_drc/
        echo "Export Gerbers"
        mkdir -p ${keyboard_path}/output/gerbers/${board}
        ${container_cmd} run ${container_args} yaqwsx/kikit:v0.7 kikit fab ${fab} ${flags} ${keyboard_path}/output/pcbs/${board}_routed.kicad_pcb ${keyboard_path}/output/gerbers/${board}
        mv ${keyboard_path}/output/gerbers/${board}/gerbers.zip ${keyboard_path}/output/gerbers/${board}.zip
        echo "Generate PCB images"
        mkdir -p ${keyboard_path}/output/images
        ${container_cmd} run ${container_args} yaqwsx/kikit:v0.7 pcbdraw --style builtin:${pcbdraw_style}.json ${keyboard_path}/output/pcbs/${board}_routed.kicad_pcb ${keyboard_path}/output/images/${board}_front.png
        ${container_cmd} run ${container_args} yaqwsx/kikit:v0.7 pcbdraw -b --style builtin:${pcbdraw_style}.json ${keyboard_path}/output/pcbs/${board}_routed.kicad_pcb ${keyboard_path}/output/images/${board}_back.png
    fi
done