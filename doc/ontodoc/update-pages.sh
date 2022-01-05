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
        https://github.com/BIG-MAP/LabNotebookAppOntology.git ${pagesdir}
    git config pull.rebase false
fi

# Update local copy of gh-pages
cd ${pagesdir}
git pull origin gh-pages

# Copy documentation to gh-pages
# FIXME - generate separate index.html with links to versions
cp -u ${tmpdir}/LabNotebookAppOntology.html index.html
cp -u ${tmpdir}/LabNotebookAppOntology.pdf .

# Update gh-pages
if git add index.html LabNotebookAppOntology.pdf ${PUBLISH_ONTOLOGIES_DIR}; then
    git commit -m "Update LabNotebookAppOntology documentation"
    git push origin gh-pages
fi
