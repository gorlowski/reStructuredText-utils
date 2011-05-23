
SYNTAX_HIGHLIGHTER=1
PYGMENTS=1
COMPONENTS :=

ifeq ($(strip $(SYNTAX_HIGHLIGHTER)),1)
    COMPONENTS += syntax_highlighter
endif
ifeq ($(strip $(PYGMENTS)),1)
    COMPONENTS += pygments
endif

JS_DIR := js
CSS_DIR := css
TMPL_DIR := templates

PYGMENTS_SCRIPT := pygmentize
PYGMENTS_INSTALLED := $(strip $(shell which $(PYGMENTS_SCRIPT)))
PYGMENTS_CSS_DIR := $(CSS_DIR)/pygments
PYGMENTS_TMPL := $(TMPL_DIR)/pygments_template.txt

SH_CSS_DIR := $(CSS_DIR)/syntax_highlighter
SH_JS_DIR := $(JS_DIR)/syntax_highlighter
SH_CORE_CSS_FILES := shCore.css shCoreDefault.css 
SH_CORE_JS_FILES := shCore.js
SH_TMPL := $(TMPL_DIR)/syntax_highlighter_template.txt

SH_CSS_BASE_URL := http://alexgorbatchev.com/pub/sh/current/styles
SH_PROJ_PAGE_THEMES_URL := http://alexgorbatchev.com/SyntaxHighlighter/manual/themes/ 
SH_PROJ_PAGE_JS_URL := http://alexgorbatchev.com/SyntaxHighlighter/manual/brushes/
SH_JS_BASE_URL := http://alexgorbatchev.com/pub/sh/current/scripts

all: $(COMPONENTS)

help:
	@echo
	@echo "    -----------------------------------"
	@echo "    Makefile Target Help"
	@echo "    -----------------------------------"
	@echo
	@echo "    Use this Makefile to build/update "
	@echo "    pygments and SyntaxHighlighter templates"
	@echo "    and build/download/update any necessary css"
	@echo "    and/or javascript themes + syntax highlighting"
	@echo "    rules."
	@echo
	@echo "    To build with support for all syntax highlighting libs (default):"
	@echo "		make all"
	@echo
	@echo "    To build without pygments support:"
	@echo "		make PYGMENTS=0"
	@echo
	@echo "    To build without SyntaxHighlighter support:"
	@echo "		make SYNTAX_HIGHLIGHTER=0"
	@echo
	
pygments: pygments_header pygments_css pygments_tmpl

pygments_header:
	@echo -----------------------------------
	@echo Setting Up Pygments Support
	@echo -----------------------------------

check_pygments:
	@if [ -z "$(PYGMENTS_INSTALLED)" ]; then \
	    echo "-------------------------------------------------------" ; \
	    echo "ERROR: $(PYGMENTS_SCRIPT) not found." ; \
	    echo "-------------------------------------------------------" ; \
	    echo "To use pygments syntax highlighting, you must install pygments and put" ; \
	    echo "$(PYGMENTS_SCRIPT) on your path. You can do this with:" ; \
	    echo "" ; \
	    echo "    easy_install Pygments	 (may need to run with sudo or as root)" ; \
	    echo "" ; \
	    echo "	OR " ; \
	    echo "" ; \
	    echo "    sudo apt-get install python-pygments (on debian-based distros)" ; \
	    echo "" ; \
	    echo "-------------------------------------------------------" ; \
	    echo "" ; \
	    echo "If you do not want pygments support, make with PYGMENTS=0" ; \
	    echo "" ; \
	    echo "-------------------------------------------------------" ; \
	    exit 1 ; \
	fi

# Generate .css stylesheet files for every style supported by pygments.
# pygments uses short css class names that can easily collide with other style
# definitions. To reduce the possibility of css class name collisions, make the
# class matchers more specific by qualifying that they only apply within a div
# element of css-class highlight, which is how pygments encapsulates a code
# block in its output.
pygments_css: check_pygments
	@echo -----------------------------------
	@echo Generating Pygments CSS stylesheets
	@echo -----------------------------------
	mkdir -p $(PYGMENTS_CSS_DIR)
	for style in `$(PYGMENTS_SCRIPT) -L styles \
	    | awk '/^\*/ {print gensub(":","",1,$$2)}'`; do \
	    cat src/css/pygments/common.css > $(PYGMENTS_CSS_DIR)/$${style}.css; \
	    $(PYGMENTS_SCRIPT) -S $$style -f html \
		| sed 's/^/div.highlight /' \
		>> $(PYGMENTS_CSS_DIR)/$${style}.css; \
	done

pygments_tmpl:
	@echo ----------------------------
	@echo Generating Pygments Template
	@echo ----------------------------
	$(RM) $(PYGMENTS_TMPL)
	cat src/templates/template_{head,tail}.txt >> $(PYGMENTS_TMPL)
	@echo

#========================================
#	SyntaxHighlighter
#========================================

syntax_highlighter: sh_header sh_css sh_js sh_tmpl

sh_header:
	@echo -----------------------------------
	@echo Setting Up SyntaxHighlighter Support
	@echo -----------------------------------

sh_css:
	@echo ---------------------------------------------
	@echo Downloading SyntaxHighlighter CSS stylesheets
	@echo ---------------------------------------------
	mkdir -p $(SH_CSS_DIR)
	for style in $(SH_CORE_CSS_FILES) `curl $(SH_PROJ_PAGE_THEMES_URL) 2>/dev/null \
	    | grep shTheme | grep SyntaxHighlighter \
	    | sed -e 's/.*<code>//' -e 's|</code>.*||' `; do \
	    curl -L $(SH_CSS_BASE_URL)/$$style -o $(SH_CSS_DIR)/$$style ; \
	done

sh_js:
	@echo ----------------------------------------
	@echo Downloading SyntaxHighlighter JavaScript 
	@echo ----------------------------------------
	mkdir -p $(SH_JS_DIR)
	for js in $(SH_CORE_JS_FILES) `curl '$(SH_PROJ_PAGE_JS_URL)' 2>/dev/null \
	    | grep 'SyntaxHighlighter.*shBrush.*js' \
	    | sed -e 's/.*\(shBrush\)/\1/' -e 's|</td.*||' `; do \
	    curl -L $(SH_JS_BASE_URL)/$$js -o $(SH_JS_DIR)/$$js ; \
	done

sh_tmpl:
	@echo -------------------------------------
	@echo Generating SyntaxHighlighter Template
	@echo -------------------------------------
	$(RM) $(SH_TMPL)
	cat src/templates/template_head.txt >> $(SH_TMPL)
	echo >> $(SH_TMPL)
	for css_file in $(SH_CORE_CSS_FILES); do \
	    abs_css_file=`readlink -f $(SH_CSS_DIR)/$$css_file` ; \
	    echo "<link href='file://$$abs_css_file' rel='stylesheet' type='text/css'/>" \
	    >> $(SH_TMPL) ; \
	done
	echo >> $(SH_TMPL)
	for js in `find $(SH_JS_DIR) -type f |xargs -L1 readlink -f |sort -r`; do \
	    echo "<script src='file://$$js' type='text/javascript'></script>" \
	    >> $(SH_TMPL) ; \
	done
	echo >> $(SH_TMPL)
	echo "<script language='javascript' type='text/javascript'>" >> $(SH_TMPL)
	echo "  SyntaxHighlighter.config.bloggerMode = true;" >> $(SH_TMPL)
	echo "  SyntaxHighlighter.all();" >> $(SH_TMPL)
	echo "</script>" >> $(SH_TMPL)
	echo >> $(SH_TMPL)
	cat src/templates/template_tail.txt >> $(SH_TMPL)

.PHONY: pygments_css
