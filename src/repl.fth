\ This file is meant to provide a friendlier interactive environment to work in.


\ Safety checks

defer quit

: ?not-found
	dup 0<> ?exit
	drop count type  char ? emit  cr  quit ;

: ?unstructured
	dup ' ; <> ?exit
	sp@ s0 $ 2 cells - = ?exit
	." Unstructured" cr  quit ;

: ?underflow
	sp@ s0 <= ?exit
	." Underflow" cr  quit ;


\ TODO  Safer redefinitions of all words that search the wordlist
: find  seek  dup if  >xt  then ;


\ Redefined REPL with safety checks introduced above

:! (quit)
	s0 sp!  r0 rp!
	postpone \
	begin
		name  dup find
		( cstr xt )
		?not-found
		?unstructured
		nip execute
		( n*x )
		?underflow
	again ;

[ ' (quit) is quit ]
[ quit ]


\ Development utilities

:! undo  lp@ back  lp@ @ lp! ;
:! marker  create  lp@ ,  does!>  @ lp! ;
:! words  lp@ traverse-list>  >name count type space ;

marker reset

\ TODO  forget (consider changing dictionary structure), hide, hook, some kind of debug word, and .s
\ Flawed definition : .s  begin sp@ s0 < while .# bl emit repeat ;
