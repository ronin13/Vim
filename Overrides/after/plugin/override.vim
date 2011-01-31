
 " we need the conceal feature (vim ≥ 7.3)
 if !has('conceal')
     finish
 endif

let s:counter=0
 " remove the keywords. we'll re-add them below
"  if ! &ft
"     finish
"  endif
 "let commentType=&ft."Comment"

 "syntax cluster matchi add=&ft."Comment"
 "syntax match matchComment "\v^\s*#.*" contains=@matchi conceal cchar=Ξ
 "syntax cluster matchi add=&ft."Comment"
 syntax conceal on
 syntax match matchComment1 "\v^\s*#.*"  conceal cchar=||
 syntax match matchComment2 "\v^\s*\".*"  conceal cchar=||
 "hi! link matchComment1 Comment
 "hi! link matchComment2 Comment
 set conceallevel=2

 "nnoremap <silent> <leader>C :call comceal#toggle()<CR>

"fun! comceal#toggle()
    "let s:counter = (s:counter+1)%3
    "setlocal conceallevel=s:counter
"endfun

autocmd filetype vim set foldmethod=marker 
