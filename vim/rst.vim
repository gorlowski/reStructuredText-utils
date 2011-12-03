"
"   Copy or symlink this file to ~/.vim/after/syntax/rst.vim
"

""" must redefine rstDirectives to note that the cluster contains rstCodeBlock
syn cluster rstDirectives           contains=rstFootnote,rstCitation,
      \ rstHyperlinkTarget,rstExDirective,rstCodeBlock

""" Define rstCodeBlock (contains nothing)
syn region rstCodeBlock contained matchgroup=rstDirective
      \ start='code-block::\s\+[[:alnum:]]\+' skip='^$' end='^\s\@!'

""" Note that rstCodeBlock should be highlighted as a String
hi def link rstCodeBlock                    String
