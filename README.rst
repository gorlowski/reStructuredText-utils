=======================================
reStructuredText Blog Authoring Tools
=======================================

-----------
Description
-----------
A project to provide a convenient toolchain for authoring
blogs and/or other web content using:

+ reStructuredText for document markup
+ SyntaxHighlighter or Pygments for code highlighting
+ a real text editor like vim or emacs

---------------------------
Current Features/Components
---------------------------

r2h:
    A shell script entry point that supports translating reStructuredText to
    HTML. r2h supports previewing the HTML in a web browser, validating
    the markup with docutils and/or stripping all content outside the main
    document ``<body>`` and copying the result to your Xwindows CLIPBOARD

codeblock.py:
    defines and registers a ``code-block`` reStructuredText markup directive
    for code syntax highlighting using `Syntax Highlighter
    <http://alexgorbatchev.com/SyntaxHighlighter/>`_ or 
    `Pygments <http://pygments.org/>`_.

css/\*:
    stylesheets to use with docutils. These are generated (when using Pygments)
    or downloaded (when using SyntaxHighlighter) by the Makefile. They
    include both core css files for each syntax highlighting backend and
    pluggable, theme-specific files.

-------------
Requirements
-------------

=================== ================ 
Component           Debian Package
=================== ================
docutils            python-docutils
xsel (optional)     xsel
python >= 2.6       python2.6
=================== ================

---------------------------
Installation Instructions
---------------------------

#. Install all the required packages. Make sure rst2html and (optionally) xsel
   are on your PATH
#. Copy all the files into some directory on your filesystem
#. Run ``make all`` to download or generate css and js files. Run
   ``make help`` for additional Makefile parameters.
#. symlink r2h somewhere on your PATH::

        ln -s /path/to/inst/dir/r2h /usr/local/bin/r2h

------------------
Usage Examples
------------------

Get usage information for r2h (includes some option parameters not specified
here)::

    r2h --help

Translate ``myfile.rst`` from reStructuredText to HTML, and print the content of
the ``<body>`` element to STDOUT::

    r2h myfile.rst

Translate ``myfile.rst`` from reStructuredText to HTML, and copy the content of
the ``<body>`` element to the Xwindows CLIPBOARD paste buffer::

    r2h -c myfile.rst

Preview the html generated from myfile.rst in a web browser, using
SyntaxHighlighter with its midnight theme for syntax highlighting::

    r2h --preview --style=midnight --lib=sh myfile.rst

Preview the html generated from myfile.rst in a web browser, using
Pygments with its manni theme for syntax highlighting. Use the chromium
web browser in "app mode" with a temp browser profile for the preview::

    r2h --preview --style=manni --lib=pygments \
        --browser "chromium-browser --app={FILE} --temp-profile" 
        myfile.rst

Validate the syntax of myfile.rst::

    r2h --valid myfile.rst

Get a list of styles/themes supported by the syntax highlighting backends::

    r2h -L

-------------
Tips
-------------

Copy or symlink vim/rst_html_util.vim in your ~/.vim/plugin directory to
define the following commands

``R2HClip``:
    Translates the rst file in the vim buffer to html, strips everything
    not inside the main ``<body>`` tag, and copies the result into your
    Xwindows CLIPBOARD (for easy pasting into a blogging client)

``R2HValid``:
    Validates the rst content in your vim buffer, printing any syntax
    errors.

``R2HPreview``
    Translates the rst file in the vim buffer to html and opens the html
    in a web browser to preview. Run ``r2h --help`` for customizations
    that you can apply to this command definition (choose the browser,
    etc).

Blogger-Specific
^^^^^^^^^^^^^^^^^

If you're using Blogger, make sure you configure::

    Settings->Formatting->Convert Line Breaks = NO

Here's `a screenshot of the configuration screen
<http://gyazo.com/7c8b02a1a3e41fb665347323bf4fab84.png>`_
from `the blogger.vim project
<https://github.com/ujihisa/blogger.vim>`_. blogger.vim seems like a
good alternative for publishing to blogger from vim, but it does not
support automated ``reStructuredText -> HTML`` translation.

--------------------------
Misc Notes
--------------------------

I wrote r2h so I can write Blogger posts with reStructuredText syntax in vim
and easily translate the output to HTML. I had to write ``codeblock.py`` so
I could integrate SyntaxHighlighter for code syntax highlighting. After
using SyntaxHighlighter a bit, I decided to switch to Pygments because
it supports more file formats. However, I decided to keep the SyntaxHighlighter
support as an optional backend.

If you want to use r2h with some blogging service/platform, view the source of 
the html generated in preview mode, identify the css (and possibly js) files
included in the html, and make sure to include those files somehow in the
``<head>`` element of your blogging template.

My current process is to write reStructuredText in vim, validate it with
``R2HValid``, preview it with ``R2HPreview``, and copy it to my CLIPBOARD
with ``R2HClip`` when I'm ready to publish. I then paste the clipboard
into a blogtk window to publish.

I will update this project in the future with a script + some vim commands to
hook GoogleCL or some other script to support publishing the html generated
from the reStructuredText directly to Blogger (without the need to paste it
into an intermediate client). At some point, I may also add vim commands for
publishing reStructuredText as an update to an existing blog post.
