" syntax markdown that focuses on paratext and polyphonic things.
"  - quotes
"  - citation key (for pandoc)
"  - footnotes
"  - parentheses
"
"  and comment with ,, (because html comment are much too long).
"
"  and minimal support for basic markdown syntax,
"  taken from tpope: https://github.com/tpope/vim-markdown
"  - italic (emphasis)
"  - bold (strong)
"  - heading
"  - html comment
"  - code (inline and block)
"
"  TODO:
"  - italic + bold

" comment with ,,
setl commentstring=\,,%s\,,

" comment with ,,
syn region Comment
            \ start=/,,/ end=/,,/
            \ contains=@NoSpell
            \ containedin=ALLBUT,Comment,Code,YamlFrontMatter
            \ keepend

" html comments
syn region Comment
            \ start=/<!--/ end=/-->/
            \ containedin=ALLBUT,Comment,Code,YamlFrontMatter
            \ keepend

" citation key: @becker2020
syn match CitationKey "@[a-zÀ-ÿ0-9_]\+"
            \ containedin=ALLBUT,Comment,Code,YamlFrontMatter
            \ contains=@NoSpell

" inline quotes
syn region String start=/"/ skip=/[^\\]\\"/ end=/"/ keepend
syn region String start=/«/ skip=/[^\\]\\»/ end=/»/ keepend
syn region String start=/“/ skip=/[^\\]\\”/ end=/”/ keepend

" block quote
syn region String start="^>.*" end="\n\n"
            \ contains=ItalicString
            \ keepend

" brackets when followed by citation key [@citkey2024]
syn region Paratext matchgroup=ParaMarker
            \ start="\[@\@=" skip="\\\]" end="\]"
            \ containedin=ALLBUT,Comment,Code,YamlFrontMatter
            \ keepend

" [^1]: pretty footnote in a small font
syn region Paratext matchgroup=ParaMarker
            \ start="^\[^\S\+\]:" end="$"
            \ contains=CONTAINED
            \ keepend

" footnote call (in text)
syn match ParaMarker "\[\^\S\+\]" 
            \ contains=@NoSpell
            \ containedin=ALLBUT,Comment,Code,YamlFrontMatter

" horizontal bar with ---
syn match ParaMarker /^---$/

" parentheses
syn region Parenthese
            \ start="(" end=")"
            \ contains=String,Code
            \ containedin=ALLBUT,Comment,Code,String,Title

" url (or file path) in link like this: [magic place](magic url)
syn region Url matchgroup=Paratext 
            \ start=/!\?\[[^\[\]]*\](/ end=/)/
            \ contains=@NoSpell
            \ containedin=ALLBUT,Comment,Code,YamlFrontMatter
            \ keepend

syn match Url "https\?://\S\+"
            \ contains=@NoSpell
            \ containedin=ALLBUT,Comment,Code,YamlFrontMatter,URL
            \ keepend

" italic with *
syn region Italic
            \ start="\S\@<=\*\|\*\S\@=" 
            \ skip="\\\*"
            \ end="\S\@<=\*\|\*\S\@="  
            \ contains=@NoSpell

" italic with _
syn region Italic
            \ start="\W\@<=_\w\@=\|^_\w\@=\|\W\@<=_\W\@="
            \ skip="\\_"
            \ end="\w\@<=_\W\@=\|_$\|\W\@<=_\W\@="
            \ contains=@NoSpell

" italic + string
syn region ItalicString
            \ start="\W\@<=_\w\@=\|^_\w\@=\|\W\@<=_\W\@="
            \ skip="\\_"
            \ end="\w\@<=_\W\@=\|_$\|\W\@<=_\W\@="
            \ containedin=String
            \ contained
            \ contains=@NoSpell
            \ keepend

" italic + string
syn region ItalicParenthese
            \ start="\W\@<=_\w\@=\|^_\w\@=\|\W\@<=_\W\@="
            \ skip="\\_"
            \ end="\w\@<=_\W\@=\|_$\|\W\@<=_\W\@="
            \ containedin=Parenthese
            \ contains=@NoSpell
            \ contained
            \ keepend

" bold
syn region Bold
            \ start="\S\@<=__\|__\S\@=" 
            \ skip="\\__"
            \ end="\S\@<=__\|__\S\@="  

" bold
syn region BoldString
            \ start="\S\@<=__\|__\S\@=" 
            \ skip="\\__"
            \ end="\S\@<=__\|__\S\@="  
            \ containedin=String
            \ contained
            \ keepend

" bold
syn region BoldParenthese
            \ start="\S\@<=__\|__\S\@=" 
            \ skip="\\__"
            \ end="\S\@<=__\|__\S\@="  
            \ containedin=Parenthese
            \ contained
            \ keepend

" inline code: `
syn region Code
            \ start=/[^`]\@<=`\|^`/ skip=/[^\\]\\`/ end=/`[^`]\@=\|`$/
            \ contains=@NoSpell
            \ containedin=ALLBUT,Code,Comment

" code block: ```
syn region Code
            \ start=/^```\S\+/ end=/^```$/
            \ contains=@NoSpell

" yaml frontmatter
syn region YamlFrontMatter
            \ matchgroup=Statement
            \ start=/\%1l^---$/ end=/^---$/
            \ contains=@NoSpell

" keys (fields) in the yaml frontmatter
syn match YamlKey "^[^: ]\+:" containedin=YamlFrontMatter contained contains=@NoSpell

" lists
syn match ListItem "^\s*\- \|^\s*\d\+\."

" defintion list
syn match Concept "[^\n]\+\n\n\?:\@="
syn region Definition start=/^:/ end=/$/

" headings
syn match Title "^.\+\n-\+$" contains=TitleMarker
syn match Title "^.\+\n=\+$" contains=TitleMarker
syn match Title "^#\+ .*" contains=TitleMarker
syn match TitleMarker "^[=-]\+$" contained
syn match TitleMarker "^#\+" contained

" TODO
syn match Todo "TODO" containedin=Comment contains=@NoSpell

" html tag (minimal syntax)
syn region HtmlTag start=/<[^!]/ end=/>/ contains=@NoSpell
syn region HtmlString start=/"/ end=/"/ 
            \ containedin=HtmlTag contains=@NoSpell contained

" some highlights
hi default Italic cterm=italic gui=italic
hi default Bold cterm=bold gui=bold
hi default Concept cterm=underline gui=underline

"  links to highlight groups
hi default link Definition Function
hi default link CitationKey Underlined
hi default link Date        Statement
hi default link Url         Underlined
hi default link Parenthese  Function
hi default link Paratext    Constant
hi default link ParaMarker  Statement
hi default link Footnote    Operator
hi default link Code Type
hi default link TitleMarker Statement
hi default link ListItem Statement
hi default link YamlFrontMatter Function
hi default link YamlKey Statement
hi default link HtmlTag Statement
hi default link HtmlString Paratext

let b:current_syntax = "markdown"
