#!/bin/sh
container_cmd=docker
# Ensure we switch to the /board working directory, pointing it
# at the repo root (when running the script from there)
container_args="-w /board -v $(pwd):/board --rm"

# Cleanup the output folder or KiCad will error out
rm -rf keyboard/output

# Generate unrouted PCBs with Ergogen (definition in package.json)
echo "\n\n>>>>>>>>> RUNNING ERGOGEN >>>>>>>>>>\n\n"
${container_cmd} run ${container_args} node:18.10-alpine3.16 /bin/sh -c "npm run debug"

# Define the boards to autoroute and export, and the plates
boards="elv"
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
    mkdir -p keyboard/output/gerbers/${plate}
    ${container_cmd} run ${container_args} yaqwsx/kikit:v1.1.2 kikit fab ${fab} ${flags} --no-drc keyboard/output/pcbs/${plate}.kicad_pcb keyboard/output/gerbers/${plate}
    mv keyboard/output/gerbers/${plate}/gerbers.zip keyboard/output/gerbers/${plate}.zip
    echo "Generate PCB images"
    mkdir -p keyboard/output/images
    ${container_cmd} run ${container_args} yaqwsx/kikit:v1.1.2 pcbdraw plot --style ${pcbdraw_style} keyboard/output/pcbs/${plate}.kicad_pcb keyboard/output/images/${plate}.svg
done

for board in ${boards}
do
    echo "\n\n>>>>>> Processing $board <<<<<<\n\n"
    ${container_cmd} run ${container_args} soundmonster/kicad-automation-scripts:latest /bin/sh -c "mkdir -p $HOME/.config/kicad; cp /root/.config/kicad/* $HOME/.config/kicad"
    if [ -e keyboard/output/pcbs/${board}.kicad_pcb ]; then
        echo Export DSN 
        ${container_cmd} run ${container_args} soundmonster/kicad-automation-scripts:latest /usr/lib/python2.7/dist-packages/kicad-automation/pcbnew_automation/export_dsn.py keyboard/output/pcbs/${board}.kicad_pcb keyboard/output/pcbs/${board}.dsn    
    fi
    if [ -e keyboard/output/pcbs/${board}.dsn ]; then
        echo Autoroute PCB
        ${container_cmd} run ${container_args} soundmonster/freerouting_cli:v0.1.0 java -jar /opt/freerouting_cli.jar -de keyboard/output/pcbs/${board}.dsn -do keyboard/output/pcbs/${board}.ses
    fi
    if [ -e keyboard/output/pcbs/${board}.ses ]; then
        echo "Import SES"
        ${container_cmd} run ${container_args} soundmonster/kicad-automation-scripts:latest /usr/lib/python2.7/dist-packages/kicad-automation/pcbnew_automation/import_ses.py keyboard/output/pcbs/${board}.kicad_pcb keyboard/output/pcbs/${board}.ses --output-file keyboard/output/pcbs/${board}_routed.kicad_pcb
    fi
    if [ -e keyboard/output/pcbs/${board}_routed.kicad_pcb ]; then
        echo "DRC check"
        ${container_cmd} run ${container_args} soundmonster/kicad-automation-scripts:latest /usr/lib/python2.7/dist-packages/kicad-automation/pcbnew_automation/run_drc.py $GITHUB_WORKSPACE/keyboard/output/pcbs/${board}_routed.kicad_pcb $GITHUB_WORKSPACE/keyboard/output/pcbs/${board}_drc/
        echo "Export Gerbers"
        mkdir -p keyboard/output/gerbers/${board}
        ${container_cmd} run ${container_args} yaqwsx/kikit:v0.7 kikit fab ${fab} ${flags} keyboard/output/pcbs/${board}_routed.kicad_pcb keyboard/output/gerbers/${board}
        mv keyboard/output/gerbers/${board}/gerbers.zip keyboard/output/gerbers/${board}.zip
        echo "Generate PCB images"
        mkdir -p keyboard/output/images
        ${container_cmd} run ${container_args} yaqwsx/kikit:v0.7 pcbdraw --style builtin:${pcbdraw_style}.json keyboard/output/pcbs/${board}_routed.kicad_pcb keyboard/output/images/${board}_front.png
        ${container_cmd} run ${container_args} yaqwsx/kikit:v0.7 pcbdraw -b --style builtin:${pcbdraw_style}.json keyboard/output/pcbs/${board}_routed.kicad_pcb keyboard/output/images/${board}_back.png
    fi
done