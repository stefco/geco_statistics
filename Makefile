# Makefile for Sphinx documentation
# Modified for PyPI usage
#

# virtualenv prefix
VIR_ENV_PRE   =
ifdef VIRTUAL_ENV
VIR_ENV_PRE   = $(VIRTUAL_ENV)/bin/
else
ifneq ($(shell test -d env/bin), 0)
VIR_ENV_PRE   = $(shell pwd -P)/env/bin/
endif
endif

# You can set these variables from the command line.
SPHINXOPTS    =
SPHINXBUILD   = $(VIR_ENV_PRE)sphinx-build
PYTHON        = $(VIR_ENV_PRE)python
TWINE         = $(VIR_ENV_PRE)twine
PIP           = $(VIR_ENV_PRE)pip
PAPER         =
CONFDIR       = docs
BUILDDIR      = _build
PYPIBUILDDIR  = build
PYPIDISTDIR   = dist
MODULENAME    = geco_stat

# Internal variables.
PAPEROPT_a4     = -D latex_paper_size=a4
PAPEROPT_letter = -D latex_paper_size=letter
ALLSPHINXOPTS   = -d $(BUILDDIR)/doctrees $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) $(CONFDIR)
# the i18n builder cannot share the environment and doctrees with the others
I18NSPHINXOPTS  = $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) .

.PHONY: help check check-twine check-sphinx check-env clean distclean install uninstall gamut pep version increl decrel zerorel oldver incver decver pypi build upload env hooks html dirhtml singlehtml pickle json htmlhelp qthelp devhelp epub latex latexpdf text man changes linkcheck test unit-test doctest coverage gettext

help:
	@echo "Please use \`make <target>\` where <target> is one of"
	@echo "  check      to check dependencies"
	@echo "  env        to create a virtualenv for development"
	@echo "  clean      to uninstall pkg, remove generated files, but keep env folder"
	@echo "  distclean  to uninstall pkg, remove generated files and the env folder"
	@echo "  install    to clean, build, and install editable version of package with pip"
	@echo "  uninstall  to uninstall editable package without cleaning this directory"
	@echo "  gamut      to clean, install, and test"
	@echo "  pep        to format python code according to (most) pep8 conventions"
	@echo "  test       to run all doctests as well as unit tests"
	@echo "  unit-test  to run all unit-tests"
	@echo "  doctest    to run all doctests embedded in the documentation (if enabled)"
	@echo "  version    to show current version and release numbers"
	@echo "  increl     to increment release number, e.g. 0.0.1 -> 0.0.2"
	@echo "  decrel     to decrement release number, e.g. 0.0.2 -> 0.0.1"
	@echo "  zerorel    to set fix release number to 0, e.g. 0.0.5 -> 0.0.0"
	@echo "  oldver     to restore old version info from last commit"
	@echo "  incver     to increment version number, e.g. 0.1.0 -> 0.2.0"
	@echo "  decver     to decrement version number, e.g. 0.2.0 -> 0.1.0"
	@echo "  pypi       to build and upload packages to PyPI all at once"
	@echo "  build      to build packages for upload to PyPI"
	@echo "  upload     to upload finished PyPI packages"
	@echo "  hooks      to symlink git hooks to the .git/hooks directory"
	@echo "  html       to make standalone HTML files"
	@echo "  dirhtml    to make HTML files named index.html in directories"
	@echo "  singlehtml to make a single large HTML file"
	@echo "  pickle     to make pickle files"
	@echo "  json       to make JSON files"
	@echo "  htmlhelp   to make HTML files and a HTML help project"
	@echo "  qthelp     to make HTML files and a qthelp project"
	@echo "  applehelp  to make an Apple Help Book"
	@echo "  devhelp    to make HTML files and a Devhelp project"
	@echo "  epub       to make an epub"
	@echo "  latex      to make LaTeX files, you can set PAPER=a4 or PAPER=letter"
	@echo "  latexpdf   to make LaTeX files and run them through pdflatex"
	@echo "  latexpdfja to make LaTeX files and run them through platex/dvipdfmx"
	@echo "  text       to make text files"
	@echo "  man        to make manual pages"
	@echo "  texinfo    to make Texinfo files"
	@echo "  info       to make Texinfo files and run them through makeinfo"
	@echo "  gettext    to make PO message catalogs"
	@echo "  changes    to make an overview of all changed/added/deprecated items"
	@echo "  xml        to make Docutils-native XML files"
	@echo "  pseudoxml  to make pseudoxml-XML files for display purposes"
	@echo "  linkcheck  to check all external links for integrity"
	@echo "  coverage   to run coverage check of the documentation (if enabled)"

# User-friendly check for all dependencies.
check: check-env check-twine check-sphinx
	@echo "\nDependency checks passed!\n"

# User-friendly check for twine. indentation puts it in the test proper... v confusing...
check-twine:
ifeq ($(shell which $(TWINE) >/dev/null 2>&1; echo $$?), 1)
	$(error The '$(TWINE)' command was not found. Make sure you have Twine installed, which you can do with 'pip install twine'. See this link for more details on using Twine and PyPI: http://python-packaging-user-guide.readthedocs.org/en/latest/distributing/#setup-py)
endif

# User-friendly check for sphinx-build
check-sphinx:
ifeq ($(shell which $(SPHINXBUILD) >/dev/null 2>&1; echo $$?), 1)
	$(error The '$(SPHINXBUILD)' command was not found. Make sure you have Sphinx installed, then set the SPHINXBUILD environment variable to point to the full path of the '$(SPHINXBUILD)' executable. Alternatively you can add the directory with the executable to your PATH. If you don not have Sphinx installed, grab it from http://sphinx-doc.org/)
endif

# User-friendly check for virtualenv
check-env:
ifndef VIR_ENV_PRE
	$(error 'VIR_ENV_PRE is undefined; this means you are not working in a virtual environment and do not have one installed in this directory. Run "make env" to install a virtual environment using python virtualenv and follow instructions to activate it.')
else
ifdef VIRTUAL_ENV
	@echo "\nvirtual environment ACTIVE, VIRTUAL_ENV is set.\n\nRun\n\n\tdeactivate\n\nto deactivate.\n\n"
else
	@echo "\nvirtual environment INACTIVE, VIRTUAL_ENV is not set.\n\nIf no virtual environment is installed, run\n\n\tmake env\n\nto install it. If it is installed, run\n\n\tsource env/bin/activate\n\nto activate.\n\n"
endif
	@echo "environment used by make:  $(VIR_ENV_PRE)"
	@echo "present working directory: `pwd -P`"
endif

env: hooks
	@echo "\nConfiguring a virtual environment for python...\n"
# Install a virtualenv to allow for local development and usage.
	if ! [ -e "./env" ]; then virtualenv env; fi
# Install some stuff required for pip packaging and development
	$(PIP) install -U "pip>=1.4" "setuptools>=0.9" "wheel>=0.21" twine "ipython" mock autopep8
# Install sphinx itself, plus the Read the Docs theme
	$(PIP) install -U "sphinx" "sphinx_rtd_theme"
# Install required packages
	env/bin/pip install -U "numpy" "matplotlib" "h5py" "tendo"
	@echo "\nDone setting up! To use the virtual environment interactively, run\n\n\tsource env/bin/activate\n\nto start working in this virtual environment, and run\n\n\tdeactivate\n\nwhen finished to return to your normal setup.\n\nFor nice documentation on virtualenv, visit:\nhttps://www.dabapps.com/blog/introduction-to-pip-and-virtualenv-python/"

clean: uninstall
	@echo "Delete autogenerated sphinx files"
	rm -rf $(BUILDDIR)
	@echo "Delete files created during PyPI build"
	rm -rf $(PYPIBUILDDIR)
	rm -rf $(PYPIDISTDIR)
	rm -rf *egg-info
	@echo "Delete autogenerated .pyc files"
	rm -rf *.pyc
	rm -rf __pycache__
	rm -rf */__pycache__
	rm -rf */*.pyc

distclean: clean
# Delete virtualenv
	echo "Deleting virtualenv..."
	rm -rf env
	@echo "\nIf you were in a virtualenv, run deactivate; it will no longer work\n"

install: check-env clean uninstall build
	pip install -e .
	@echo "\nSuccessfully installed `pip list | tr - _ | sed -n '/^$(MODULENAME) .*/p'`\n"
	
uninstall: check-env
	pip uninstall --yes $(MODULENAME) 2>&1 || printf "$(MODULENAME) not installed, moving on.\n"

gamut: clean install test
	@echo "\nRan the gamut successfully.\n"

pep: check
	autopep8 --in-place --recursive --select=E1,E3,E5,E7,W2,W6 geco_stat
	@echo "\nDone reformatting.\n"

test: doctest unit-test
	@echo "\nAll tests passed.\n"

unit-test:
	@echo "\nRunning unit tests...\n"
	$(PYTHON) -c "import $(MODULENAME); $(MODULENAME).run_unit_tests()"

doctest: check-sphinx
	$(SPHINXBUILD) -b doctest $(ALLSPHINXOPTS) $(BUILDDIR)/doctest
	@echo "Testing of doctests in the sources finished, look at the " \
	      "results in $(BUILDDIR)/doctest/output.txt."

version:
	@echo "\ncurrent version and release:\n\n`cat $(MODULENAME)/_version.py`\n"

increl: version
	@echo "\nincrementing python release...\n"
	cp $(MODULENAME)/_version.py _version_backup.py
	printf "`cat _version_backup.py`\nr = eval('[' + __release__.replace('.',',') + ']')\nr[2] += 1\nprint('__version__ = \\\'' + __version__ + '\\\'\\\n__release__ = \\\'' + '.'.join([str(x) for x in r]) + '\\\'')\n" | python | tee $(MODULENAME)/_version.py
	rm _version_backup.py
	@echo "\nsuccess."

decrel: version
	@echo "\ndecrementing python release...\n"
	cp $(MODULENAME)/_version.py _version_backup.py
	printf "`cat _version_backup.py`\nr = eval('[' + __release__.replace('.',',') + ']')\nr[2] -= 1\nprint('__version__ = \\\'' + __version__ + '\\\'\\\n__release__ = \\\'' + '.'.join([str(x) for x in r]) + '\\\'')\n" | python | tee $(MODULENAME)/_version.py
	rm _version_backup.py
	@echo "\nsuccess."

zerorel: version
	@echo "\nsetting python fix release to zero...\n"
	cp $(MODULENAME)/_version.py _version_backup.py
	printf "`cat _version_backup.py`\nr = eval('[' + __release__.replace('.',',') + ']')\nr[2] = 0\nprint('__version__ = \\\'' + __version__ + '\\\'\\\n__release__ = \\\'' + '.'.join([str(x) for x in r]) + '\\\'')\n" | python | tee $(MODULENAME)/_version.py
	rm _version_backup.py
	@echo "\nsuccess."

oldver: version
	@echo "\nrestoring old version info...\n"
	git checkout HEAD -- $(MODULENAME)/_version.py
	@echo "\nrestored version and release:\n\n`cat $(MODULENAME)/_version.py`\n"

incver: version
	@echo "\nincrementing python version...\n"
	cp $(MODULENAME)/_version.py _version_backup.py
	printf "`cat _version_backup.py`\nv = eval('[' + __version__.replace('.',',') + ']')\nr = eval('[' + __release__.replace('.',',') + ']')\nv[1] += 1\nr[1] += 1\nprint('__version__ = \\\'' + '.'.join([str(x) for x in v]) + '\\\'\\\n__release__ = \\\'' + '.'.join([str(x) for x in r]) + '\\\'')\n" | python | tee $(MODULENAME)/_version.py
	rm _version_backup.py
	@echo "\nsuccess."

decver: version
	@echo "\ndecrementing python version...\n"
	cp $(MODULENAME)/_version.py _version_backup.py
	printf "`cat _version_backup.py`\nv = eval('[' + __version__.replace('.',',') + ']')\nr = eval('[' + __release__.replace('.',',') + ']')\nv[1] -= 1\nr[1] -= 1\nprint('__version__ = \\\'' + '.'.join([str(x) for x in v]) + '\\\'\\\n__release__ = \\\'' + '.'.join([str(x) for x in r]) + '\\\'')\n" | python | tee $(MODULENAME)/_version.py
	rm _version_backup.py
	@echo "\nsuccess."

pypi: build upload

build: check-env
	$(PYTHON) setup.py sdist
	$(PYTHON) setup.py bdist_wheel --universal
	@echo "Build finished. You can now upload by running make upload (did you update version.py?)"

upload: check-env check-twine
	$(TWINE) upload $(PYPIDISTDIR)/*

hooks:
	ln -s -f ../../.hooks/post-commit .git/hooks/post-commit

html: check-sphinx
	$(SPHINXBUILD) -b html $(ALLSPHINXOPTS) $(BUILDDIR)/html
	@echo
	@echo "Build finished. The HTML pages are in $(BUILDDIR)/html."

dirhtml: check-sphinx
	$(SPHINXBUILD) -b dirhtml $(ALLSPHINXOPTS) $(BUILDDIR)/dirhtml
	@echo
	@echo "Build finished. The HTML pages are in $(BUILDDIR)/dirhtml."

singlehtml: check-sphinx
	$(SPHINXBUILD) -b singlehtml $(ALLSPHINXOPTS) $(BUILDDIR)/singlehtml
	@echo
	@echo "Build finished. The HTML page is in $(BUILDDIR)/singlehtml."

pickle: check-sphinx
	$(SPHINXBUILD) -b pickle $(ALLSPHINXOPTS) $(BUILDDIR)/pickle
	@echo
	@echo "Build finished; now you can process the pickle files."

json: check-sphinx
	$(SPHINXBUILD) -b json $(ALLSPHINXOPTS) $(BUILDDIR)/json
	@echo
	@echo "Build finished; now you can process the JSON files."

htmlhelp: check-sphinx
	$(SPHINXBUILD) -b htmlhelp $(ALLSPHINXOPTS) $(BUILDDIR)/htmlhelp
	@echo
	@echo "Build finished; now you can run HTML Help Workshop with the" \
	      ".hhp project file in $(BUILDDIR)/htmlhelp."

qthelp: check-sphinx
	$(SPHINXBUILD) -b qthelp $(ALLSPHINXOPTS) $(BUILDDIR)/qthelp
	@echo
	@echo "Build finished; now you can run "qcollectiongenerator" with the" \
	      ".qhcp project file in $(BUILDDIR)/qthelp, like this:"
	@echo "# qcollectiongenerator $(BUILDDIR)/qthelp/GECoStatistics.qhcp"
	@echo "To view the help file:"
	@echo "# assistant -collectionFile $(BUILDDIR)/qthelp/GECoStatistics.qhc"

applehelp: check-sphinx
	$(SPHINXBUILD) -b applehelp $(ALLSPHINXOPTS) $(BUILDDIR)/applehelp
	@echo
	@echo "Build finished. The help book is in $(BUILDDIR)/applehelp."
	@echo "N.B. You will not be able to view it unless you put it in" \
	      "~/Library/Documentation/Help or install it in your application" \
	      "bundle."

devhelp: check-sphinx
	$(SPHINXBUILD) -b devhelp $(ALLSPHINXOPTS) $(BUILDDIR)/devhelp
	@echo
	@echo "Build finished."
	@echo "To view the help file:"
	@echo "# mkdir -p $$HOME/.local/share/devhelp/GECoStatistics"
	@echo "# ln -s $(BUILDDIR)/devhelp $$HOME/.local/share/devhelp/GECoStatistics"
	@echo "# devhelp"

epub: check-sphinx
	$(SPHINXBUILD) -b epub $(ALLSPHINXOPTS) $(BUILDDIR)/epub
	@echo
	@echo "Build finished. The epub file is in $(BUILDDIR)/epub."

latex: check-sphinx
	$(SPHINXBUILD) -b latex $(ALLSPHINXOPTS) $(BUILDDIR)/latex
	@echo
	@echo "Build finished; the LaTeX files are in $(BUILDDIR)/latex."
	@echo "Run \`make`\ in that directory to run these through (pdf)latex" \
	      "(use \`make latexpdf`\ here to do that automatically)."

latexpdf: check-sphinx
	$(SPHINXBUILD) -b latex $(ALLSPHINXOPTS) $(BUILDDIR)/latex
	@echo "Running LaTeX files through pdflatex..."
	$(MAKE) -C $(BUILDDIR)/latex all-pdf
	@echo "pdflatex finished; the PDF files are in $(BUILDDIR)/latex."

latexpdfja: check-sphinx
	$(SPHINXBUILD) -b latex $(ALLSPHINXOPTS) $(BUILDDIR)/latex
	@echo "Running LaTeX files through platex and dvipdfmx..."
	$(MAKE) -C $(BUILDDIR)/latex all-pdf-ja
	@echo "pdflatex finished; the PDF files are in $(BUILDDIR)/latex."

text: check-sphinx
	$(SPHINXBUILD) -b text $(ALLSPHINXOPTS) $(BUILDDIR)/text
	@echo
	@echo "Build finished. The text files are in $(BUILDDIR)/text."

man: check-sphinx
	$(SPHINXBUILD) -b man $(ALLSPHINXOPTS) $(BUILDDIR)/man
	@echo
	@echo "Build finished. The manual pages are in $(BUILDDIR)/man."

texinfo: check-sphinx
	$(SPHINXBUILD) -b texinfo $(ALLSPHINXOPTS) $(BUILDDIR)/texinfo
	@echo
	@echo "Build finished. The Texinfo files are in $(BUILDDIR)/texinfo."
	@echo "Run \`make`\ in that directory to run these through makeinfo" \
	      "(use \`make info`\ here to do that automatically)."

info: check-sphinx
	$(SPHINXBUILD) -b texinfo $(ALLSPHINXOPTS) $(BUILDDIR)/texinfo
	@echo "Running Texinfo files through makeinfo..."
	make -C $(BUILDDIR)/texinfo info
	@echo "makeinfo finished; the Info files are in $(BUILDDIR)/texinfo."

gettext: check-sphinx
	$(SPHINXBUILD) -b gettext $(I18NSPHINXOPTS) $(BUILDDIR)/locale
	@echo
	@echo "Build finished. The message catalogs are in $(BUILDDIR)/locale."

changes: check-sphinx
	$(SPHINXBUILD) -b changes $(ALLSPHINXOPTS) $(BUILDDIR)/changes
	@echo
	@echo "The overview file is in $(BUILDDIR)/changes."

linkcheck: check-sphinx
	$(SPHINXBUILD) -b linkcheck $(ALLSPHINXOPTS) $(BUILDDIR)/linkcheck
	@echo
	@echo "Link check complete; look for any errors in the above output " \
	      "or in $(BUILDDIR)/linkcheck/output.txt."

coverage: check-sphinx
	$(SPHINXBUILD) -b coverage $(ALLSPHINXOPTS) $(BUILDDIR)/coverage
	@echo "Testing of coverage in the sources finished, look at the " \
	      "results in $(BUILDDIR)/coverage/python.txt."

xml: check-sphinx
	$(SPHINXBUILD) -b xml $(ALLSPHINXOPTS) $(BUILDDIR)/xml
	@echo
	@echo "Build finished. The XML files are in $(BUILDDIR)/xml."

pseudoxml: check-sphinx
	$(SPHINXBUILD) -b pseudoxml $(ALLSPHINXOPTS) $(BUILDDIR)/pseudoxml
	@echo
	@echo "Build finished. The pseudo-XML files are in $(BUILDDIR)/pseudoxml."
