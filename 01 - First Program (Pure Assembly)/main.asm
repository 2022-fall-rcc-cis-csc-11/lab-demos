

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Data section is for our global vars in system ram
section .data


;;;;;
; System calls
SYS_WRITE		equ		1
SYS_EXIT		equ		60


;;;;;
; File descriptors
FD_STDOUT		equ		1


;;;;;;;;;;;;
; Exit codes
EXIT_SUCCESS		equ		0


;;;;;
; Strings
HELLO_MESSAGE		db		"Hello, my name is Gibsin Montgomery-Gibson !!",13,10
HELLO_MESSAGE_LEN	equ		$-HELLO_MESSAGE


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Text section is for our instructions
section .text


;; The _start label is the entry point for our pure assembly program
global _start
_start:

	;;;;;;;;;;;;;;;;;;;;
	; Print out our hello message with a system call
	mov rax, SYS_WRITE		; System call code goes into rax
	mov rdi, FD_STDOUT		; Tell the system to print to STDOUT
	mov rsi, HELLO_MESSAGE		; Provide the memory location to start reading our characters to print
	mov rdx, HELLO_MESSAGE_LEN	; Provide the number of characters print
	syscall				; Now that we have everything setup, actually do the system call
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; Properly exit with a system call
	mov rax, SYS_EXIT		; System call code for a proper exit!
	mov rdi, EXIT_SUCCESS		; Exit code into rdi (EXIT_SUCCESS = 0)
	syscall				; Now that everything's setup, do the syscall to exit






