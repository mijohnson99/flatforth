\ Words relying on Linux system calls

: sys_exit
	rdi rax movq
	rax [ # 60 ] movabs$
	syscall ;

alias bye  sys_exit


\ rbx, rdi, and rsi are clobbered by syscalls and must be preserved
:! save     { rbx pushq  rdi pushq  rsi pushq } ;
:! restore  { rsi popq   rdi popq   rbx popq  } ;


variable clock_type
: realtime   $ 0 clock_type ! ;
: monotonic  $ 1 clock_type ! ;
[ monotonic ]

2variable timespec
: sys_clock_gettime
	clock_type @
	save
	rdi rax movq
	rsi [ timespec ] movabs$
	rax [ # 228 ] movabs$
	syscall
	restore
	drop ;

[ # 1000000000 ] constant resolution
: clock  sys_clock_gettime  timespec 2@  resolution * + ;

: time  realtime clock  resolution / ;

variable timer
: tick  monotonic clock  timer ! ;
: tock  monotonic clock  timer @ - ;
