=======================================
reStructuredText Blog Authoring Tools
=======================================

-----------
Description
-----------
A project to provide a convenient toolchain for authoring
blogs and/or other web content using:

+ reStructuredText for document markup
+ SyntaxHighlighter for code highlighting
+ a real text editor like vim or emacs

---------------------------
Current Features/Components
---------------------------

r2h:
    A shell script entry point that supports translating reStructuredText to
    HTML, stripping all content outside the main document ``<body>`` tag, and
    optionally copying the result to your X windows CLIPBOARD paste buffer

codeblock.py:
    defines and registers a ``code-block`` reStructuredText markup directive
    for marking up code with `Syntax Highlighter
    <http://alexgorbatchev.com/SyntaxHighlighter/>`_

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
#. symlink r2h somewhere on your PATH::

        ln -s /path/to/inst/dir/r2h /usr/local/bin/r2h

------------------
Usage Examples
------------------

Get usage information for r2h::

    r2h --help

Translate ``myfile.rst`` from reStructuredText to HTML, and print the content of
the ``<body>`` element to STDOUT::

    r2h myfile.rst

Translate ``myfile.rst`` from reStructuredText to HTML, and copy the content of
the ``<body>`` element to the Xwindows CLIPBOARD paste buffer::

    r2h -c myfile.rst

-------------
Tips
-------------

Define an R2h command in vim. When editing an rst file, this command will read
the vim buffer, translate it to html, and copy it to the Xwindows clipboard in
a single step::

    command R2h !r2h --clip %

--------------------------
Misc Notes
--------------------------

I wrote r2h so I can write Blogger posts with reStructuredText syntax in vim
and easily translate the output to HTML. I had to write ``codeblock.py`` so
I could integrate SyntaxHighlighter for code syntax highlighting.

My current process is to write reStructuredText in vim, translate to HTML
and copy the HTML to my clipboard with R2h, and publish a blog article
by pasting the clipboard into a blogtk window and clicking publish. 

I will update this project in the future with a script + some vim commands
to hook GoogleCL into the toolchain to support the following steps from
a single vim command:

#. translate reStructuredText to HTML
#. publish the HTML to a new Blogger post
