if exists("g:RSTHtmlLoaded")
    finish
endif
let g:RSTHtmlLoaded = 1

""" Translate the contents of the current VIM buffer from reStructuredText ->
""" HTML and copy to the clipboard
command R2HClip w ! r2h --clip

""" Validate that the reStructuredText in the current VIM buffer is well-formed
command R2HValid w ! r2h --valid

""" Translate the contents of the current VIM buffer from reStructuredText ->
""" HTML and preview the result in a web browser
command R2HPreview sil w ! r2h --preview --browser='chromium-browser --app={FILE} --temp-profile' --tmpfile="%:t:r"
