\ Forth defining words

link :!  enter  { link  enter }  exit
:! ;  { exit }  exit
:! :  { link  docol enter } ;


\ Basic assembler words

:! int3   $ cc c, ;
:! int3!  int3 ;

:! rax  $ 0 ;
:! rcx  $ 1 ;
:! rdx  $ 2 ;
:! rbx  $ 3 ;
:! rsp  $ 4 ;
:! rbp  $ 5 ;
:! rsi  $ 6 ;
:! rdi  $ 7 ;

:  mem      $ 0 ;
:  mem+8    $ 1 ;
:  mem+32   $ 2 ;
:  reg      $ 3 ;
:  modr/m,  $ 3 << + $ 3 << + c, ;

:! pushq  $ 50 + c, ;
:! popq   $ 58 + c, ;

:  rex.w,           $ 48 c, ;
:! addq     rex.w,  $ 01 c,  reg modr/m, ;
:! subq     rex.w,  $ 29 c,  reg modr/m, ;
:! movq     rex.w,  $ 89 c,  reg modr/m, ;
:! stosb            $ aa c, ;
:! stosd            $ ab c, ;
:! stosw   $ 66 c,  $ ab c, ;
:! stosq   rex.w,   $ ab c, ;


\ Basic Forth primitives

:! dup   { rax pushq } ;
:! drop  { rax popq } ;
:! swap  { rdx popq  rax pushq  rax rdx movq } ;
:! +     { rdx popq  rax rdx addq } ;
:! -     { rdx rax movq  rax popq  rax rdx subq } ;

:! c,      { stosb drop } ;
:! w,      { stosw drop } ;
:! d,      { stosd drop } ;
:!  ,      { stosq drop } ;
:! here    { rax pushq  rax rdi movq } ;
:  rel32,   here -  $ 4 - d, ;


\ More assembler words

:! orq      rex.w,    $ 09 c,            reg modr/m, ;
:! andq     rex.w,    $ 21 c,            reg modr/m, ;
:! xorq     rex.w,    $ 31 c,            reg modr/m, ;
:! cmpq     rex.w,    $ 39 c,  swap      reg modr/m, ;
:! addq$    rex.w,    $ 81 c,  swap  $ 0 reg modr/m, d, ;
:! cmpq$    rex.w,    $ 81 c,  swap  $ 7 reg modr/m, d, ;
:! testq    rex.w,    $ 85 c,            reg modr/m, ;
:! xchgq    rex.w,    $ 87 c,            reg modr/m, ;
:! movb!              $ 88 c,            mem modr/m, ; \ TODO  swap like movq@
:! movq!    rex.w,    $ 89 c,            mem modr/m, ; \ TODO  swap like movq@
:! movq@    rex.w,    $ 8b c,  swap      mem modr/m, ;
:! shrq$    rex.w,    $ c1 c,  swap  $ 5 reg modr/m, c, ;
:! shlq$    rex.w,    $ c1 c,  swap  $ 6 reg modr/m, c, ;
:! sarq$    rex.w,    $ c1 c,  swap  $ 7 reg modr/m, c, ;
:! 1shlq    rex.w,    $ d1 c,   $ 6      reg modr/m, ;
:! 1sarq    rex.w,    $ d1 c,   $ 7      reg modr/m, ;
:! clshrq   rex.w,    $ d3 c,   $ 5      reg modr/m, ;
:! clshlq   rex.w,    $ d3 c,   $ 6      reg modr/m, ;
:! clsarq   rex.w,    $ d3 c,   $ 7      reg modr/m, ;
:! jmp$               $ e9 c,                 rel32, ;
:! notq     rex.w,    $ f7 c,   $ 2      reg modr/m, ;
:! negq     rex.w,    $ f7 c,   $ 3      reg modr/m, ;
:! mulq     rex.w,    $ f7 c,   $ 4      reg modr/m, ;
:! divq     rex.w,    $ f7 c,   $ 6      reg modr/m, ;
:! incq     rex.w,    $ ff c,   $ 0      reg modr/m, ;
:! decq     rex.w,    $ ff c,   $ 1      reg modr/m, ;
:! callq    rex.w,    $ ff c,   $ 2      reg modr/m, ;
:! jmpq     rex.w,    $ ff c,   $ 4      reg modr/m, ;
:! cmovlq   rex.w,  $ 4c0f w,  swap      reg modr/m, ;
:! cmovgq   rex.w,  $ 4f0f w,  swap      reg modr/m, ;
:! jz$              $ 840f w,                 rel32, ;
:! jnz$             $ 850f w,                 rel32, ;
:! jg$              $ 8f0f w,                 rel32, ;
:! seteb            $ 940f w,   $ 0      reg modr/m, ;
:! setneb           $ 950f w,   $ 0      reg modr/m, ;
:! setlb            $ 9c0f w,   $ 0      reg modr/m, ;
:! setgeb           $ 9d0f w,   $ 0      reg modr/m, ;
:! setleb           $ 9e0f w,   $ 0      reg modr/m, ;
:! setgb            $ 9f0f w,   $ 0      reg modr/m, ;
:! movzxb@  rex.w,  $ b60f w,  swap      mem modr/m, ;
:! movzxbl          $ b60f w,            reg modr/m, ;
:! movabs$          $ b848 w,                      , ;
\ Aliases
:! setzb   { seteb } ;
:! setnzb  { setneb } ;


\ More Forth primitives

:! nip   { rdx popq } ;
:! tuck  { rdx popq  rax pushq  rdx pushq } ;
:! over  { rdx rsp movq@  rax pushq  rax rdx movq } ;

:! <r>  { rsp rbp xchgq } ;
\ TODO  probably need to optimize these
:! >r   { <r> rax pushq <r> rax popq } ;
:! r>   { rax pushq  <r> rax popq <r> } ;
:! 2>r  { rdx popq  <r> rdx pushq  rax pushq <r>  rax popq } ;
:! 2r>  { rax pushq  <r> rax popq  rdx popq <r>  rdx pushq } ;

:! >>   { rcx rax movq  rax popq  rax clshrq } ;
:! <<   { rcx rax movq  rax popq  rax clshlq } ;
:! >>>  { rcx rax movq  rax popq  rax clsarq } ;
:! <<<  { << } ;

:! *     { rdx popq  rdx mulq } ;
:! /     { rdx rdx xorq  rcx rax movq  rax popq  rcx divq } ;
:! mod   { /  rax rdx movq } ;
:! /mod  { /  rdx pushq } ;

:! there  { rax rdi xchgq } ;
:! back   { rdi rax movq  rax popq } ;
:! allot  { rdi rax addq  rax popq } ;

:! sp@    { rax pushq  rax rsp movq } ;
:! rp@    { rax pushq  rax rbp movq } ;
:! lp@    { rax pushq  rax rsi movq } ;
:! sp!    { rsp rax movq  rax popq } ;
:! rp!    { rbp rax movq  rax popq } ;
:! lp!    { rsi rax movq  rax popq } ;

:! invert  { rax notq } ;
:! negate  { rax negq } ;
:! and     { rdx popq  rax rdx andq } ;
:! or      { rdx popq  rax rdx orq } ;
:! xor     { rdx popq  rax rdx xorq } ;

:! 1+  { rax incq } ;
:! 1-  { rax decq } ;
:! 2*  { rax 1shlq } ;
:! 2/  { rax 1sarq } ;

:  literal  { dup movabs$ } ;

:! begin   here ;
:! cond    { rax rax testq  rax popq } ;
:! until   { cond jz$ } ;
:! again   { jmp$ } ;
:! ahead   $ 0 { jmp$ }  here $ 4 - ;
:! if      { cond }  $ 0 { jz$ }  here $ 4 - ;
:! then    there  dup rel32,  back ;
:! else    { ahead } swap { then } ;
:! while   { if } swap ;
:! repeat  { again then } ;

\ TODO consider including range checks
:! for     { <r> rbx pushq <r>  rbx rax movq  rax popq }  here  { rbx decq } ;
:! i       { dup  rax rbx movq } ;
:! unloop  { <r> rbx popq <r> } ;
:! next    { rbx } $ 0 { cmpq$  jg$  unloop } ;

:! 0=   { rax rax testq  rax setzb   rax rax movzxbl } ;
:! 0<>  { rax rax testq  rax setnzb  rax rax movzxbl } ;
:! 0>   { rax rax testq  rax setgb   rax rax movzxbl } ;
:! 0<   { rax rax testq  rax setlb   rax rax movzxbl } ;
:! 0>=  { rax rax testq  rax setgeb  rax rax movzxbl } ;
:! 0<=  { rax rax testq  rax setleb  rax rax movzxbl } ;
:! =    { rdx popq  rax rdx cmpq  rax seteb   rax rax movzxbl } ;
:! <>   { rdx popq  rax rdx cmpq  rax setneb  rax rax movzxbl } ;
:! >    { rdx popq  rax rdx cmpq  rax setgb   rax rax movzxbl } ;
:! <    { rdx popq  rax rdx cmpq  rax setlb   rax rax movzxbl } ;
:! >=   { rdx popq  rax rdx cmpq  rax setgeb  rax rax movzxbl } ;
:! <=   { rdx popq  rax rdx cmpq  rax setleb  rax rax movzxbl } ;
:! max  { rdx popq  rax rdx cmpq  rax rdx cmovgq } ;
:! min  { rdx popq  rax rdx cmpq  rax rdx cmovlq } ;

:! execute  { rdx rax movq  rax popq  rdx callq } ;
:! jump     { rdx rax movq  rax popq  rdx jmpq } ;

:!  @  { rax rax movq@ } ;
:! c@  { rax rax movzxb@ } ;
:!  !  { rdx popq  rax rdx movq!  rax popq } ;
:! c!  { rdx popq  rax rdx movb!  rax popq } ;

:! cell  $ 8 literal ;
:! cell+  { rax } $ 8 { addq$ } ;
:! cells  { rax } $ 3 { shlq$ } ;

:!  rot  { rcx popq  rdx popq  rcx pushq  rax pushq  rax rdx movq } ;
:! -rot  { rcx popq  rdx popq  rax pushq  rdx pushq  rax rcx movq } ;

:! 2dup   { rdx rsp movq@  rax pushq  rdx pushq } ;
:! 2drop  { drop drop } ;


\ Benchmark

: collatz-step  dup $ 1 and  if  dup 2* + 1+  else  2/  then ;
: collatz-len   $ 0 swap begin  dup $ 1 > while  collatz-step  swap 1+ swap repeat drop ;
: max-collatz   $ 0 swap for  i collatz-len max  next ;

:! test  $ f4240 max-collatz  int3 ;
test

int3!
