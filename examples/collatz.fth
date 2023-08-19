: COLLATZ-STEP  DUP $ 1 AND  IF  DUP 2* + 1+  ELSE  2/  THEN ;
: COLLATZ-LEN   $ 0 SWAP BEGIN  DUP $ 1 > WHILE  COLLATZ-STEP  SWAP 1+ SWAP REPEAT DROP ;
: MAX-COLLATZ   $ 0 SWAP FOR  I COLLATZ-LEN MAX  NEXT ;

[ # 1000000 MAX-COLLATZ .# CR BYE ]
