\ : C, HERE C! 1 ALLOT ;
: W, DUP C,  8 RSHIFT C, ;
: D, DUP W, 16 RSHIFT W, ;
: Q, , ;

HEX

( Maybe these are worth considering? )
\ : C,  HERE ! 1 ALLOT ;
\ : W,  HERE ! 2 ALLOT ;
\ : D,  HERE ! 4 ALLOT ;
\ : Q,  HERE ! 8 ALLOT ;

: RAX  0 ; IMMEDIATE
: RCX  1 ; IMMEDIATE
: RDX  2 ; IMMEDIATE
: RBX  3 ; IMMEDIATE
: RSP  4 ; IMMEDIATE
: RBP  5 ; IMMEDIATE
: RSI  6 ; IMMEDIATE
: RDI  7 ; IMMEDIATE

: REX.W,  48 C, ;
: MODR/M,  3 LSHIFT OR 3 LSHIFT OR C, ;
: REL32,  HERE 4 + - D, ;
: REL8,  HERE 1 + - C, ;

: MOV   REX.W, 89 C, 3 MODR/M, ; IMMEDIATE
: MOV!  REX.W, 89 C, 0 MODR/M, ; IMMEDIATE
: MOV@  REX.W, 8B C, 0 MODR/M, ; IMMEDIATE
: MOV$  SWAP B8 + C, Q, ; IMMEDIATE

: MOVC!  88 C, 0 MODR/M, ; IMMEDIATE

: MOVZX@  SWAP REX.W, B60F W, 0 MODR/M, ; IMMEDIATE

: RAXXCHG  REX.W, 90 + C, ; IMMEDIATE

: ADD  REX.W, 01 C, 3 MODR/M, ; IMMEDIATE
: SUB  REX.W, 29 C, 3 MODR/M, ; IMMEDIATE
: ADD$  SWAP REX.W, 81 C, 0 3 MODR/M, D, ; IMMEDIATE
: SUB$  SWAP REX.W, 81 C, 5 3 MODR/M, D, ; IMMEDIATE

: MUL  REX.W, F7 C, 4 3 MODR/M, ; IMMEDIATE
: DIV  REX.W, F7 C, 6 3 MODR/M, ; IMMEDIATE

: PUSH  REX.W, 50 + C, ; IMMEDIATE
: POP   REX.W, 58 + C, ; IMMEDIATE

: RET  C3 C, ; IMMEDIATE

: CALL$  E8 C, REL32, ; IMMEDIATE
: CALL  FF C, 2 3 MODR/M, ; IMMEDIATE

: CMP  REX.W, 39 C, 3 MODR/M, ; IMMEDIATE

: INC  REX.W, FF C, 0 3 MODR/M, ; IMMEDIATE
: DEC  REX.W, FF C, 1 3 MODR/M, ; IMMEDIATE

: JMP$  E9 C, REL32, ; IMMEDIATE
: JZ$  840F W, REL32, ; IMMEDIATE
: JNZ$  850F W, REL32, ; IMMEDIATE

: REPE  F3 C, ; IMMEDIATE
: CMPSB  A6 C, ; IMMEDIATE

\ : LOOP$  E2 C, REL8, ; IMMEDIATE
\ : LOOP$  RCX DEC  JNZ$ ; IMMEDIATE


\ : POSTPONE  WORD FIND POSTPONE CALL$  ( ? ) ;
: (CALLER)  R> POSTPONE CALL$ ;
: CREATE-CALLER  ['] (CALLER) POSTPONE CALL$ ;


\ : DIGIT  DUP 39 > IF 1- DF AND 36 - ELSE 30 - THEN ;
\ : $  NAME COUNT 1- TUCK + 0 ROT FOR 4 LSHIFT OVER I - C@ DIGIT + NEXT NIP ;


\		Testing

: CDUMP  SWAP DO I C@ . LOOP CR ;

: TESTWORD (CALLER) RAX RDX ADD$ RET ;

HERE RAX RBX MOV HERE CDUMP

HERE RSI RDI MOV HERE CDUMP

HERE RAX RBX MOV@ HERE CDUMP

HERE RAX RBX MOV! HERE CDUMP

HERE RAX RBX MOVC! HERE CDUMP

HERE RAX RBX MOVZX@ HERE CDUMP

HERE RAX DEADBEEFDEADBEEF MOV$ HERE CDUMP

HERE RCX DEADBEEF SUB$ HERE CDUMP
HERE RDX DEADBEEF ADD$ HERE CDUMP

HERE 3F - CONSTANT TEST_LABEL \ to match label in test.s

HERE TEST_LABEL CALL$  HERE CDUMP
HERE RCX CALL HERE CDUMP

HERE RDI RAX CMP HERE CDUMP

HERE TEST_LABEL JMP$ HERE CDUMP
HERE TEST_LABEL JZ$ HERE CDUMP

HERE RAX RBX ADD HERE CDUMP
HERE RAX RBX SUB HERE CDUMP

HERE RBX MUL HERE CDUMP
HERE RBX DIV HERE CDUMP

HERE REPE CMPSB HERE CDUMP

HERE RET HERE CDUMP

HERE TESTWORD HERE CDUMP

HERE RCX DEC HERE CDUMP
HERE RCX INC HERE CDUMP

BYE
