"" ============================================================================
""   ~/.vim/mail
""   Cedric Duval
"" ============================================================================

" Setup to write mails with vim
" To use with Mutt, just put this line your ~/.vimrc :
"   autocmd BufRead /tmp/mutt*      :source ~/.vim/mail



"" ----------------------------------------------------------------------------
""   Misc
"" ----------------------------------------------------------------------------

set pastetoggle=<f12>   " toggle mouse paste mode with F12
set ft=mail             " needless to say, vim had already guessed that alone :)
set spell


"" ----------------------------------------------------------------------------
""   Automatic line wrap
"" ----------------------------------------------------------------------------

set textwidth=72	" max line length
set formatoptions=tcql
set comments+=n:\|	" '|' is a quote char.
set comments+=n:%	" '%' as well.

" * <F1> to re-format the current paragraph correctly
" * <F2> to format a line which is too long, and go to the next line
" * <F3> to merge the previous line with the current one, with a correct
"        formatting (sometimes useful associated with <F2>)
"
" These keys might be used both in command mode and edit mode.
"
" <F1> might be smarter to use with the Mail_Del_Empty_Quoted() function
" defined below

nmap	<F1>	gqap
nmap	<F2>	gqqj
nmap	<F3>	kgqj
map!	<F1>	<ESC>gqapi
map!	<F2>	<ESC>gqqji
map!	<F3>	<ESC>kgqji



"" ----------------------------------------------------------------------------
""   Suppressing quoted signature(s) if any when replying
"" ----------------------------------------------------------------------------

" Thanks to Luc Hermitte for the original function
" (http://hermitte.free.fr/vim/ressources/vimfiles/ftplugin/mail/Mail_Sig_set_vim.html)
" Thanks to Lo�c Minier and Martin Treusch von Buttlar who pointed out an
" issue with the user's own sig.

function! Mail_Erase_Sig_old()
  let i = line('$')
  let j = i
  " search for the signature pattern (takes into account signature delimiters
  " from broken mailers that forget the space after the two dashes)
  while ((i > 0) && (getline(i) !~ '^> *-- \=$'))
    if (getline(i) =~ '^-- $')
      " this is my own sig. please don't delete it!
      let j = i - 1
    endif
    let i = i - 1
  endwhile

  " if found, then
  if (i != 0)
    " search for the last non empty (non sig) line
    while ((i > 0) && (getline(i - 1) =~ '^\(>\s*\)*$'))
      let i = i - 1
    endwhile
    " and delete those lines plus the signature
    exe ':'.i.','.j.'d'
  endif
endfunction

" this new version handles cases where there are several signatures
" (sometimes added by mailing list software)
function! Mail_Erase_Sig()
  " search for the signature pattern (takes into account signature delimiters
  " from broken mailers that forget the space after the two dashes)
  let i = 0
  while ((i <= line('$')) && (getline(i) !~ '^> *-- \=$'))
    let i = i + 1
  endwhile

  " if found, then
  if (i != line('$') + 1)
    " first, look for our own signature, to avoid deleting it
    let j = i
    while (j < line('$') && (getline(j + 1) !~ '^-- $'))
      let j = j + 1
    endwhile

    " second, search for the last non empty (non sig) line
    while ((i > 0) && (getline(i - 1) =~ '^\(>\s*\)*$'))
      let i = i - 1
    endwhile

    " third, delete those lines plus the signature
    exe ':'.i.','.j.'d'
  endif
endfunction


"" ----------------------------------------------------------------------------
""   Replacing empty quoted lines (e.g. "> $") with empty lines
""   (convenient to automatically reformat one paragraph)
"" ----------------------------------------------------------------------------

function! Mail_Del_Empty_Quoted()
  exe "normal :%s/^>[[:space:]\%\|\#>]\\+$//e\<CR>"
endfunction



"" ----------------------------------------------------------------------------
""   Moving the cursor at the begining of the mail
"" ----------------------------------------------------------------------------

function! Mail_Begining()
  exe "normal gg"
  if getline (line ('.')) =~ '^From: '
    " if we use edit_headers in Mutt, then go after the headers
    exe "normal /^$\<CR>"
  endif
endfunction



"" ----------------------------------------------------------------------------
""
""   Initializations
""
"" ----------------------------------------------------------------------------

call Mail_Erase_Sig()
call Mail_Del_Empty_Quoted()
call Mail_Begining()

"http://permalink.gmane.org/gmane.editors.vim.devel/20890
setlocal foldmethod=expr foldlevel=1 foldminlines=2
setlocal foldexpr=strlen(substitute(substitute(getline(v:lnum),'\\s','','g'),'[^>].*','',''))

fun! LBDBCompleteFn(findstart, base)
    if a:findstart
        " locate the start of the word
        let line = getline('.')
        let start = col('.') - 1
        while start > 0 && line[start - 1] =~ '[^:,]'
            let start -= 1
        endwhile
        while start < col('.') && line[start] =~ '[:, ]'
            let start += 1
        endwhile
        return start
    else
        let res = []
        let query = substitute(a:base, '"', '', 'g')
        let query = substitute(query, '\s*<.*>\s*', '', 'g')
        for m in LbdbQuery(query)
            call add(res, printf('"%s" <%s>', escape(m[0], '"'), m[1]))
        endfor
        return res
    endif
endfun

set completefunc=LBDBCompleteFn
ino <C-n> <C-X><C-U>
ino <C-p> <C-X><C-U>


" To be done elsewhere
" http://dollyfish.net.nz/blog/2008-04-01/mutt-and-vim-custom-autocompletion
":silent! lbdbq | awk '{ print  }' > /tmp/lbdict
"setlocal dictionary+=/tmp/lbdict
"silent! %s/\(^\([a-zA-z-]\+:\|--\)\)\@<!\s\+$//
"silent! %s/^\(>\+\) >/\1>/g
"silent! %s/^\(>\+\) >/\1>/g
" map <F3> and <F4> to go to next inlined reply
" " register save/restore
" "autocmd FileType mail map <buffer> <F3> :/^>//^[^>]/<CR>:nohlsearch<CR>zzzv
" autocmd FileType mail map <buffer> <F3>
" :/^>//^\(>\)\@!\ze\s*\S/<CR>:nohlsearch<CR>zzzv
" autocmd FileType mail map <buffer> <F4>
" :/^>\s*>//^>\(\s*>\)\@!\ze\s*\S/<CR>:nohlsearch<CR>zzzv
" " (doc: that's just ":/pattern1//pattern2/")
"
