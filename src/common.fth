\ TODO  Split into different files?

\ Parenthesis comments
:! char  name 1+ c@ literal ;
:! (  begin key char ) = until ;

\ Word manipulation
: count  1+ dup 1- c@ ;
: type  for dup c@ emit 1+ next drop ;

\ Character constants
: cr  $ a emit ;
:! bl  $ 20 literal ;
: space  bl emit ;

\ Decimal integer i/o
: sign  dup 0<> if  0> 2* 1-  then ;
:! #  $ 0  name count  for  >r  $ a *  r@ c@ digit +  r> 1+  next drop literal ;
: u.  $ 0  begin >r  # 10 /mod  r> 1+  over 0= until  nip  for  char 0 + emit  next ;
:  .  dup 0< if  char - emit  negate  then  u. ;
:  ?  @ . cr ;
\ TODO  Add hexadecimal output

\ Words for embedding data into code
: embed  { ahead }  here swap ;
: with-length  here swap  { then }  over - 2literal ;
: alone  { then }  literal ;

\ Strings
: parse, ( delim -- ) key begin 2dup <> while c, key repeat 2drop ; \ Read keys into memory until delimiter
: parse  ( delim -- str cnt ) here swap parse,  dup there over - ;  \ parse, but temporary (reset data pointer)
:! s"  embed  char " parse,  with-length ;
:! ."  { s" type } ;

\ Data structures
\ Note that since this is a compile-only Forth, create is not immediate, and therefore can't be used "immediately"
: (create)  r> literal ;
:  create   { :!  (create) } ;
: (does>)  lp@ >xt  there r> compile back ;
:! does!>  { (does>) r> } ;
:! does>   { does!>  literal docol } ;
\ ^^ Note the addition of does!> which redefines the created word to be immediate
\ This is in contrast to does>, which is intended to behave more like a normal Forth

\ Side note: Interestingly, the same effect can be achieved by postponing a created word with a does!>
\ TODO  ^ This has the added benefit that only a call instruction is compiled. Can this be leveraged?

\ As an example, compare the following definitions:
:! variable  create cell allot ;
:! 2variable  create $ 2 cells allot ;
:! constant  create , does!>  @ literal ;
:! value     create , does>   @ ;
:! at  name seek >body literal ;
:! to  { at ! } ;

\ Common constants
[ $ 0 ] constant false
[ $ 1 ] constant true
[ sp@ ] constant s0
[ rp@ ] constant r0

\ On/Off
: on   true swap ! ;
: off  false swap ! ;
: on?   @ 0<> ;
: off?  @ 0= ;

\ Return stack manipulation
: ?exit  if rdrop then ;
: later>  2r> >r >r ;

\ Vectored execution
:! alias  { :! postpone ; } ;
:! nothing ;
:! defer  create ' nothing , does>  @execute ;
alias is    to
alias doer  defer
:! make  { at }  docol  r> swap ! ;
\ TODO  ^ Add support for ;and


\ TODO  Find a good conditional compilation mechanism for supporting optimized versions of e.g. below
\ Memory copying
: cstep  swap 1+ swap 1+ ;
: ccopy  swap c@ swap c! ;
: cmove  for  2dup ccopy cstep  next 2drop ;

\ Counted string comparisons
: 2c@  swap c@ swap c@ ;
: ?c=  2c@ = ?exit  rdrop unloop ;
: -match  for  2dup ?c= cstep  next ; \ Find mismatch
: cstr=  dup c@  -match  2c@ = ;

\ TODO  Implement compare (reusing -match)

\ Common address and size calculations
: aligned  1- tuck + swap invert and ; \ Aligns for powers of 2 only
: within  rot tuck  > -rot  <= and ;
: kb  # 10 lshift ;
: mb  # 20 lshift ;
: gb  # 30 lshift ;
