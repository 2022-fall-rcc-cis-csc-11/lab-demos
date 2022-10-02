

;;;;;;;;;;;;;;;;;;;;;;;;;
; Assembly w/ Professor P


;;;;;;;;;;;;;;
; Data Section
section .data

;;;
; CStrings

ARGC_MSG			db		"You entered this many arguments: ",0
ARG_PREFIX			db		"] ",0

CRLF				db		13,10
CRLF_LEN			equ		$-CRLF


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


; Our entry point
; int main();
; Calls our tests and stuff
; Register usage:
;	r12: argc
;	r13: argv
;	r14: Current index of argument to print
global main
main:
	
	;	Prologue
	push r12
	push r13
	push r14
	
	;	Quickly save incoming arguments somewhere
	mov r12, rdi
	mov r13, rsi
	
	;	Opening message about # of args
	mov rdi, ARGC_MSG
	call printNullTerminatedString
	
	;	Print the number of arguments
	mov rdi, r12
	call libPuhfessorP_printSignedInteger64
	call crlf

main_loopSetup:
	
	mov r14, 0
	
main_loopTop:
	
	; 	Jump out of the loop if we're done
	cmp r14, r12
	jge main_done
	
	;	Print the current index
	mov rdi, r14
	call libPuhfessorP_printSignedInteger64
	
	;	Print the next argument's prefix
	mov rdi, ARG_PREFIX
	call printNullTerminatedString
	
	;	Print the next argument
	mov rdi, [r13 + (r14 * 8)]
	call printNullTerminatedString
	call crlf
	
	;	Advance the index and continue looping
	inc r14
	jmp main_loopTop
	
main_done:
	
	;	Epilogue
	pop r14
	pop r13
	pop r12
	
	; We're done
	mov rax, EXIT_SUCCESS	; Mov 7 into rax (our return code)
	ret						; Return control back to GCC libraries (aka exit our program)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	void printNullTerminatedString(char * theString)
;	r12: Running pointer
printNullTerminatedString:
	
	; Prologue
	push r12
	
	; Grab pointer
	mov r12, rdi
	
printNullTerminatedString_loopTop:
	
	; Grab next byte and possibly exit if we found our null terminator
	mov r10b, byte [r12]
	cmp r10b, 0
	je printNullTerminatedString_done
	
	; Print this next character
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, r12
	mov rdx, 1
	syscall
	
	; Increment and continue looping
	inc r12
	jmp printNullTerminatedString_loopTop
	
	
printNullTerminatedString_done:
	
	; Epilogue
	pop r12
	
	ret



;;;
; Custom function to print a CRLF
; void crlf();
crlf:
	
	; Print the CRLF!
	mov rax, SYS_WRITE	; System call code
	mov rdi, FD_STDOUT	; Print to stdout
	mov rsi, CRLF		; Pointer to first character of string to print
	mov rdx, CRLF_LEN	; Length of the string to print
	syscall

	ret






