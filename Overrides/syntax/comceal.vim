
 syntax match matchComment1 "\v^\s*#.*"  conceal cchar=||
 syntax match matchComment2 "\v^\s*\".*"  conceal cchar=||
 hi! link matchComment1 Comment
 hi! link matchComment2 Comment

