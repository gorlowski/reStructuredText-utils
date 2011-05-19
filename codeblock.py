from docutils import nodes
from docutils.parsers.rst import Directive
from docutils.parsers.rst import directives

class CodeBlock(Directive):

    has_content = True
    required_arguments = 1
    optional_arguments = 0

    def run(self):
        self.assert_has_content()
        pre_tag_content = str.join("\n", self.content)
        element = nodes.literal_block(pre_tag_content,pre_tag_content)
        element['classes'].append('brush: ' + self.arguments[0])
        return [ element ]

### Register it:
directives.register_directive('code-block', CodeBlock)
