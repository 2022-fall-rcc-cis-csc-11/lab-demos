

;;;;;;;;;;;;;;;;;;;;;;;;;
; Assembly w/ Professor P


;;;;;;;;;;;;;;
; Data Section
section .data


;;;
; CStrings

WELCOME_MSG					db		"Welcome to the coolStuff module!",0

CURRENT_COUNT_PREFIX_MSG	db		"The current count is: ",0


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
	
	call forLoopTests
	
	;
	call separator
	
	; Epilogue
	;	n/a
	
	; Return because we're done
	ret						; Return control back to the driver module


;;;;;;;;;;;;;;;;;;;;;;;
;	void forLoopTests()
forLoopTests:
	
	mov rdi, 10
	call theForLoop
	
	call separator
	
	mov rdi, 20
	call theForLoop
	
	ret


;;;;;;;;;;;;
;;	void theForLoop(long count)
;;	Example: for (long i = 0; i < X; i++ ) {Do stuff}
;;	Incoming arguments:
;;		rdi (1st int arg): Expected loop iterations
;;	Register usage:
;;		r12: Expected loop iterations
;;		r13: Counter (i.e., long i)
theForLoop:
	
	;	Prologue
	push r12
	push r13
	
	;	Save incoming arguments
	mov r12, rdi					;	Save the expected count
	
	;	Recall that a for loop has three parts:
	;	for (
	;		INIT PART; e.g., long i = 0 ;
	;		Eval part; e.g., i < 10 ;
	;		Progression part; e.g., i++
	;	)
	
	;	Init part! Start a counter at 0 (i.e., long i = 0)
	mov r13, 0

theForLoop_topEval:
	
	;	Determine if the loop should continue (i.e., i < X)
	cmp r13, r12
	jl theForLoop_topEval_true
	jmp theForLoop_topEval_false

theForLoop_topEval_true:	;	{ // Begin the body of the for loop
	
	;	Start printing the current loop counter value
	mov rdi, CURRENT_COUNT_PREFIX_MSG
	call printNullTerminatedString
	;
	mov rdi, r13
	call libPuhfessorP_printSignedInteger64
	call crlf
	
	;	Progression part of the for loop (i.e, i++)
	inc r13
	jmp theForLoop_topEval

							;	} // End the body of the for loop
	
theForLoop_topEval_false:
	
	nop
	
theForLoop_done:
	
	;	Epilogue
	pop r13
	pop r12
	
	ret


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




