#!/usr/bin/env sh
# Bash script for uploading generated documentation to GitHub Pages
set -ex

# Directories
rootdir=$(git rev-parse --show-toplevel)
ontodocdir=${rootdir}/${ONTODOC_DIR}
tmpdir=${ontodocdir}/${TMP_DIR}
pagesdir=${tmpdir}/${PAGES_DIR}

# Generate documentation
if [ "$1" != "ALREADY_BUILT" ]; then
    ${ontodocdir}/mkdoc.sh
fi

if [ "$1" = "TEST" ]; then
    echo "Not publishing - just testing (for CI)."
    exit
fi

# Checkout gh-pages
if ! [ -d ${pagesdir} ]; then
    git clone --branch=gh-pages --single-branch \
        https://github.com/BIG-MAP/LabNotebookAppOntology ${pagesdir}
    git config pull.rebase false
fi

# Copy documentation to gh-pages
# FIXME - generate separate index.html with links to versions
cp -f ${tmpdir}/LabNotebookAppOntology.html ${pagesdir}/index.html
cp -f ${tmpdir}/LabNotebookAppOntology.pdf ${pagesdir}/

# Update gh-pages
if [ -n "$(git status --porcelain ${pagesdir}/index.html ${pagesdir}/LabNotebookAppOntology.pdf)" ]; then
    cd ${pagesdir}
    git add index.html LabNotebookAppOntology.pdf
    git commit -m "Update LabNotebookAppOntology documentation"
    git push origin gh-pages
else
    echo "No changes to commit."
fi
