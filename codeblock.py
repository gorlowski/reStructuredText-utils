from os import environ
from docutils import nodes
from docutils.parsers.rst import Directive, directives

class SyntaxHighlighter(Directive):

    has_content = True
    required_arguments = 1
    optional_arguments = 0

    def run(self):
        self.assert_has_content()
        pre_tag_content = str.join("\n", self.content)
        element = nodes.literal_block(pre_tag_content,pre_tag_content)
        element['classes'].append('brush: ' + self.arguments[0])
        return [ element ]

"""
    The Pygments reStructuredText directive
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    This fragment is a Docutils_ 0.5 directive that renders source code
    (to HTML only, currently) via Pygments.

    To use it, adjust the options below and copy the code into a module
    that you import on initialization.  The code then automatically
    registers a ``sourcecode`` directive that you can use instead of
    normal code blocks like this::

        .. sourcecode:: python

            My code goes here.

    If you want to have different code styles, e.g. one with line numbers
    and one without, add formatters with their names in the VARIANTS dict
    below.  You can invoke them instead of the DEFAULT one by using a
    directive option::

        .. sourcecode:: python
            :linenos:

            My code goes here.

    Look at the `directive documentation`_ to get all the gory details.

    .. _Docutils: http://docutils.sf.net/
    .. _directive documentation:
       http://docutils.sourceforge.net/docs/howto/rst-directives.html

    :copyright: Copyright 2006-2010 by the Pygments team, see AUTHORS.
    :license: BSD, see LICENSE for details.
"""

# Options
# ~~~~~~~

from pygments.formatters import HtmlFormatter

# Set to true to inline css styles rather than use classes
INLINESTYLES = False

# The default formatter
DEFAULT = HtmlFormatter(noclasses=INLINESTYLES, linenos=True)

# Add name -> formatter pairs for every variant you want to use
VARIANTS = {
    'no_linenos': HtmlFormatter(noclasses=INLINESTYLES, linenos=False),
}

from pygments import highlight
from pygments.lexers import get_lexer_by_name, TextLexer

class Pygments(Directive):
    """ Source code syntax hightlighting with Pygments 
    """
    required_arguments = 1
    optional_arguments = 0
    final_argument_whitespace = True
    option_spec = dict([(key, directives.flag) for key in VARIANTS])
    has_content = True

    def run(self):
        self.assert_has_content()
        try:
            lexer = get_lexer_by_name(self.arguments[0])
        except ValueError:
            # no lexer found - use the text one instead of an exception
            lexer = TextLexer()
        # take an arbitrary option if more than one is given
        formatter = self.options and VARIANTS[self.options.keys()[0]] or DEFAULT
        parsed = highlight(u'\n'.join(self.content), lexer, formatter)
        return [nodes.raw('', parsed, format='html')]

framework_map = {}
for k in ('p','pygments','pygment'): framework_map[k] = Pygments
for k in ('sh','syntaxhighlighter'): framework_map[k] = SyntaxHighlighter

# Use Pygments by default:
syntax_highlighting_framework = 'pygments'

if environ.has_key('SYNTAX_HIGHLIGHTING_FRAMEWORK'):
    syntax_highlighting_framework = environ['SYNTAX_HIGHLIGHTING_FRAMEWORK'].lower()

### Register it:
directives.register_directive('code', framework_map[syntax_highlighting_framework])
directives.register_directive('code-block', framework_map[syntax_highlighting_framework])
