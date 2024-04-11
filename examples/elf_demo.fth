[ $ 400000 ] constant load-addr
[ $ 42000 ] constant extra-mem

variable elf-header
: target  elf-header @ ;
: paddr  - ;
: vaddr  paddr load-addr + ;
: filesz  $ 60 + ;
: memsz  $ 68 + ;
: entry  $ 18 + ;

:! set-entry  name find  target vaddr  target entry ! ;

: update-size  here target paddr  dup target filesz !  extra-mem +  target memsz ! ;
:! dump-binary  update-size  target  target filesz @  type  bye ;

:! header
	here elf-header !
	\ ELF Header
	$ 464c457f d, \ ei_mag ("\x7fELF")
	$ 2 c, \ ei_class (64-bit format)
	$ 1 c, \ ei_data (little endian)
	$ 1 c, \ ei_version (1)
	$ 0 c, \ ei_osabi (System v)
	$ 0 , \ ei_abiversion, ei_pad
	$ 2 w, \ e_type (et_exec)
	$ 3e w, \ e_machine (x86-64)
	$ 1 d, \ e_version (1)
	load-addr , \ e_entry (tbd)
	$ 40 , \ e_phoff
	$ 0 , \ e_shoff
	$ 0 d, \ e_flags
	$ 40 w, \ e_ehsize
	$ 38 w, \ e_phentsize
	$ 1 w, \ e_phnum
	$ 40 w, \ e_shentsize
	$ 0 w, \ e_shnum
	$ 0 w, \ e_shstrndx
	\ Program Header
	$ 1 d, \ p_type
	$ 7 d, \ p_flags
	$ 0 , \ p_offset
	load-addr , \ p_vaddr
	load-addr , \ p_paddr
	$ 78 , \ p_filesz
	$ 78 , \ p_memsz
	$ 1000 , \ p_align
	;

header

link start
	rax [ $ 3c ] movabs$
	rdi [ $ 4d ] movabs$
	syscall

set-entry start
dump-binary
