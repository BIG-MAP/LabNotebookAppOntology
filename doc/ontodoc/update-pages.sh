#!/usr/bin/env sh
# Bash script for uploading generated documentation to GitHub Pages
set -ex

# Directories
rootdir=$(git rev-parse --show-toplevel)
ontodocdir=${rootdir}/${ONTODOC_DIR}
tmpdir=${ontodocdir}/${TMP_DIR}
pagesdir=${GITHUB_WORKSPACE}/../${PAGES_DIR}

# Generate documentation
if [ "$1" != "ALREADY_BUILT" ]; then
    ${ontodocdir}/mkdoc.sh
fi

if [ "$1" = "TEST" ]; then
    echo "Not publishing - just testing (for CI)."
    exit
fi

# # Checkout gh-pages
# if ! [ -d ${pagesdir} ]; then
#     git clone --branch=gh-pages --single-branch \
#         https://github.com/BIG-MAP/LabNotebookAppOntology ${pagesdir}
#     git config pull.rebase false
# fi

# Copy documentation to gh-pages
# FIXME - generate separate index.html with links to versions
mkdir -p ${pagesdir}
cp -f ${tmpdir}/LabNotebookAppOntology.html ${pagesdir}/index.html
cp -f ${tmpdir}/LabNotebookAppOntology.pdf ${pagesdir}/

# Checkout gh-pages
cd ${GITHUB_WORKSPACE}
git checkout -f gh-pages

cp -f ${pagesdir}/index.html .
cp -f ${pagesdir}/LabNotebookAppOntology.pdf .

# Update gh-pages
if [ -n "$(git status --porcelain index.html LabNotebookAppOntology.pdf)" ]; then
    git add index.html LabNotebookAppOntology.pdf
    git commit -m "Update LabNotebookAppOntology documentation"
else
    echo "No changes to commit."
fi
