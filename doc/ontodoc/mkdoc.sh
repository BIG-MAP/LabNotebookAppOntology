#!/usr/bin/env sh
# Bash script for generating documentation
set -ex

# Directories
rootdir=$(git rev-parse --show-toplevel)
ontodocdir=${rootdir}/doc/ontodoc
tmpdir=${ontodocdir}/tmp

cd ${ontodocdir}

mkdir -p ${tmpdir}/figs
cp -u ${rootdir}/bigmap.png ${tmpdir}/figs/.

ontograph -m ${rootdir}/LabNotebookAppOntology.ttl ${tmpdir}/LabNotebookAppOntology-structure.png
ontoconvert -si ${rootdir}/LabNotebookAppOntology.ttl ${tmpdir}/LabNotebookAppOntology-inferred.ttl

ontodoc --template=LabNotebookAppOntology.md --format=html ${tmpdir}/LabNotebookAppOntology-inferred.ttl \
        ${tmpdir}/LabNotebookAppOntology.html

ontodoc --template=LabNotebookAppOntology.md ${tmpdir}/LabNotebookAppOntology-inferred.ttl \
        ${tmpdir}/LabNotebookAppOntology.pdf
