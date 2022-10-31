

;;;;;;;;;;;;;;;;;;;;;;;;;
; Assembly w/ Professor P


;;;;;;;;;;;;;;
; Data Section
section .data


;;;
; CStrings

WELCOME_MSG					db		"Welcome to the coolStuff module!",0


; Data
MY_X						dq		0


; Premade function stuff
CRLF				db		13,10,0
SEPARATOR			db		"================================",0

;	Defines


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
; void coolStuff();
global coolStuff
coolStuff:
	
	; Prologue
	; n/a
	
	;	Welcome message
	mov rdi, WELCOME_MSG
	call printNullTerminatedString
	call crlf
	
	;
	call separator
	
	;
	mov r12, 5
	mov [MY_X], r12
	
	nop
	
	mov r13, 100
	mov [MY_X], r13
	
	nop
	
	mov qword [MY_X], 11
	inc r13
	
	nop
	
	;
	call separator
	
	; Epilogue
	;	n/a
	
	; Return because we're done
	ret						; Return control back to the driver module


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	void printNullTerminatedString(char* p);
;	Prints a null terminated string, pointed to by p
;	Register usage:
;	r12: Running pointer
;
;;	Note: de-optimizing this function for lab 10, so it matches a while(expr){} pattern a bit more closely
printNullTerminatedString:
	
	; Prologue
	push r12
	
	;	Grab incoming args
	mov r12, rdi
	
printNullTerminatedString_loopTop:

printNullTerminatedString_loopTop_eval:
	
	;	while ( (*r12) != 0 )
	cmp byte [r12], 0
	jne printNullTerminatedString_loopTop_eval_true
	jmp printNullTerminatedString_loopTop_eval_false

printNullTerminatedString_loopTop_eval_true:
	
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


printNullTerminatedString_loopTop_eval_false:
	
	nop
	
printNullTerminatedString_done:	
	
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

;;;
; Custom function to print a separator
; void separator();
separator:
	
	call crlf
	
	mov rdi, SEPARATOR
	call printNullTerminatedString
	
	call crlf
	
	mov rdi, SEPARATOR
	call printNullTerminatedString
	
	call crlf
	
	mov rdi, SEPARATOR
	call printNullTerminatedString

	call crlf
	call crlf
	
	ret




