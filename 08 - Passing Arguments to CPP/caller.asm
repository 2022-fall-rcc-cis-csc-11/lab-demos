

;;;;;;;;;;;;;;;;;;;;;;;;;
; Assembly w/ Professor P


;;;;;;;;;;;;;;
; Data Section
section .data


;;;
; CStrings


CALLER_BEGAN		db		"The caller function has began",0

STRING_FOR_CPP		db		"This string is to be printed by C++",0

RETURN_VAL_PREFIX	db		"Caller got the following return value from the driver: ",0

CRLF				db		13,10,0


;;;
; System Calls
SYS_WRITE			equ		1


;;;
; File descriptors
FD_STDOUT			equ		1


;;;
; Exit codes
EXIT_SUCCESS		equ		0


;;;;;;;;;;;;;;
; Text Section
section .text


;;;;;;;;;;;;;;;;;;;;;;
; Our external symbols
extern libPuhfessorP_printSignedInteger64
extern doStuff


; Our entry point
; void caller();
global caller
caller:
	
	; Prologue
	push r12
	
	;
	mov rdi, CALLER_BEGAN
	call printNullTerminatedString
	call crlf
	
	;	Let's call the following CPP function:
	; 	long doStuff(char * cs, long someNumber);
	mov rdi, STRING_FOR_CPP
	mov rsi, 72
	call doStuff
	
	;	Now, grab the return value
	mov r12, rax
	
	;	Announce the return value
	mov rdi, RETURN_VAL_PREFIX
	call printNullTerminatedString
	mov rdi, r12
	call libPuhfessorP_printSignedInteger64
	
	call crlf
	
	; Epilogue
	pop r12
	
	; Return because we're done
	ret						; Return control back to the driver module



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	void printNullTerminatedString(char* p);
;	Prints a null terminated string, pointed to by p
;	Register usage:
;	r12: Running pointer
printNullTerminatedString:
	
	; Prologue
	push r12
	
	;	Grab incoming args
	mov r12, rdi
	
printNullTerminatedString_loopTop:
	
	;	while ( (*r12) != 0 )
	cmp byte [r12], 0
	je printNullTerminatedString_loopDone
	
	;	{
	
	; Print the character pointed to by r12
	mov rax, SYS_WRITE	; System call code
	mov rdi, FD_STDOUT	; Print to stdout
	mov rsi, r12		; Pointer to first character of string to print
	mov rdx, 1			; Length of the string to print
	syscall
	
	; Advance the running pointer
	inc r12
	
	;	}
	
	jmp printNullTerminatedString_loopTop
	
printNullTerminatedString_loopDone:	
	
	; Epilogue
	pop r12
	
	ret

;;;
; Custom function to print a CRLF
; void crlf();
crlf:
	
	mov rdi, CRLF
	call printNullTerminatedString

	ret






