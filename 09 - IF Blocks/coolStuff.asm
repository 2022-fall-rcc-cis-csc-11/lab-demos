

;;;;;;;;;;;;;;;;;;;;;;;;;
; Assembly w/ Professor P


;;;;;;;;;;;;;;
; Data Section
section .data


;;;
; CStrings

WELCOME_MSG					db		"Welcome to the coolStuff module!",0

REGULAR_IF_BLOCK_WELCOME	db		"Begin regular IF block test",0
REGULAR_IF_ARG_PREFIX		db		"Received: ",0
REGULAR_IF_TRUE				db		"The regular IF block was true!",0
REGULAR_IF_DONE				db		"The regular IF block is done",0

COMPLEX_IF_WELCOME			db		"Begin complex IF block test",0
COMPLEX_IF_ARG1_PREFIX		db		"Arg1 = ",0
COMPLEX_IF_ARG2_PREFIX		db		"Arg2 = ",0
COMPLEX_IF_ARG3_PREFIX		db		"Arg3 = ",0
COMPLEX_IF_IFTRUE			db		"The first IF condition was true!",0
COMPLEX_IF_ELSEIF1TRUE		db		"The first ELSE IF condition was true!",0
COMPLEX_IF_ELSEIF2TRUE		db		"The second ELSE IF condition was true!",0
COMPLEX_IF_ELSE				db		"The ELSE block has executed!",0
COMPLEX_IF_DONE				db		"The complex IF block is done",0

COMPLEX_IF_RHS1				equ		25
COMPLEX_IF_RHS2				equ		50
COMPLEX_IF_RHS3				equ		75


CRLF				db		13,10,0
SEPARATOR			db		"================================",0

;	Defines
IF_BLOCK_COND_RHS	equ		100


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
	
	;	Regular IF tests
	mov rdi, 50
	call regularIfBlock
	call crlf
	;
	mov rdi, 100
	call regularIfBlock
	call crlf
	
	;
	call separator
	
	;	Complex IF block: Execute the primary IF block
	mov rdi, 24
	mov rsi, 45
	mov rdx, 75
	call complexIfBlock
	call crlf
	
	;	Complex IF block: Execute the first ELSE IF block
	mov rdi, 26
	mov rsi, 45
	mov rdx, 75
	call complexIfBlock
	call crlf

	;	Complex IF block: Execute the first ELSE IF block
	mov rdi, 26
	mov rsi, 55
	mov rdx, 75
	call complexIfBlock
	call crlf

	;	Complex IF block: Execute the ELSE block
	mov rdi, 26
	mov rsi, 55
	mov rdx, 1
	call complexIfBlock
	call crlf
	
	; Epilogue
	;	n/a
	
	; Return because we're done
	ret						; Return control back to the driver module



;;;;;;;;;;;;;;;;;;;;;;;;;
;	void regularIfBlock(long leftHandSideArgument)
;	Register usage:
;		r12: The leftHandSide argument we will compare
regularIfBlock:
	
	;	Prologue
	push r12
	
	;	Save the incoming first argument to r12
	mov r12, rdi
	
	;	Say hello
	mov rdi, REGULAR_IF_BLOCK_WELCOME
	call printNullTerminatedString
	call crlf
	
	;	Print the received number
	mov rdi, REGULAR_IF_ARG_PREFIX
	call printNullTerminatedString
	mov rdi, r12
	call libPuhfessorP_printSignedInteger64
	call crlf
	
	;	EXAMPLE:
	;	if (cond)		Will use cmp
	;					Use conditional jumping to jump into or after the block
	;	{				
	;					Once the block is done, can just fall through to after the block
	;	}
	;	more code here
	
	;	Begin the IF block
	cmp	r12, IF_BLOCK_COND_RHS
	jge	regularIfBlock_true			; if (IF_BLOCK_COND_LHS >= IF_BLOCK_COND_RHS)
	jmp	regularIfBlock_done

regularIfBlock_true:				; { // beginning of IF body
	
	;	Print the TRUE message
	mov rdi, REGULAR_IF_TRUE
	call printNullTerminatedString
	call crlf
	
	jmp regularIfBlock_done			; Explicitly jump to the part of code just after the IF block
									;	We don't need to do this here (we COULD fall through),
									;	but this is just easier while we're learning.
									
regularIfBlock_done:				; } // end of the IF body
	
	;	Print the DONE message
	mov rdi, REGULAR_IF_DONE
	call printNullTerminatedString
	call crlf
	
	;	Epilogue
	pop r12
	
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	void complexIfBlock(long lhs1, long lhs2, long lhs3)
;	Register usage:
;		r12: lhs1
;		r13: lhs2
;		r14: lhs3
;	We want to implement the following C++ equivalent:
;	if ( lhs1 <= COMPLEX_IF_RHS1 ) {
;		// Print a message
;	}
;	else if ( lhs2 < COMPLEX_IF_RHS2 ) {
;		// Print a message
;	}
;	else if ( lhs3 == COMPLEX_IF_RHS3 ) {
;		// Print a message
;	}
;	else {
;		// Print a message
;	}
complexIfBlock:
	
	;	Prologue
	push r12
	push r13
	push r14
	
	;	Store the incoming arguments
	mov r12, rdi
	mov r13, rsi
	mov r14, rdx
	
	;	Say hello
	mov rdi, COMPLEX_IF_WELCOME
	call printNullTerminatedString
	call crlf
	
	;	Say all the received arguments
	mov rdi, COMPLEX_IF_ARG1_PREFIX
	call printNullTerminatedString
	mov rdi, r12
	call libPuhfessorP_printSignedInteger64
	call crlf
	;
	mov rdi, COMPLEX_IF_ARG2_PREFIX
	call printNullTerminatedString
	mov rdi, r13
	call libPuhfessorP_printSignedInteger64
	call crlf
	;
	mov rdi, COMPLEX_IF_ARG3_PREFIX
	call printNullTerminatedString
	mov rdi, r14
	call libPuhfessorP_printSignedInteger64
	call crlf
	
	;	Begin the actual IF block
	cmp r12, COMPLEX_IF_RHS1		; if (lhs1 <= COMPLEX_IF_RHS1)
	jle	complexIfBlock_ifTrue
	
	;	Otherwise, check the first else if block
	cmp r13, COMPLEX_IF_RHS2		; else if (lhs2 < COMPLEX_IF_RHS2)
	jl complexIfBlock_elseIf1True
	
	;	Otherwise, check the second else if block
	cmp r14, COMPLEX_IF_RHS3		; else if (lhs3 == COMPLEX_IF_RHS3)
	je complexIfBlock_elseIf2True
	
	;	Otherwise, jump to the ELSE block
	jmp complexIfBlock_else			; else
	

complexIfBlock_ifTrue:				; {	// Begin body of the first IF block
	
	;	Say we're in the IF's true block
	mov rdi, COMPLEX_IF_IFTRUE
	call printNullTerminatedString
	call crlf
	
	jmp complexIfBlock_done			; }

complexIfBlock_elseIf1True:			; { // Begin else if 1 block body
	
	;	Say we're in the first else if true block
	mov rdi, COMPLEX_IF_ELSEIF1TRUE
	call printNullTerminatedString
	call crlf
	
	jmp complexIfBlock_done			; } // End else if 1 block body
	
	
complexIfBlock_elseIf2True:			; { // Begin else if 2 block body

	;	Say we're in the second else if true block
	mov rdi, COMPLEX_IF_ELSEIF2TRUE
	call printNullTerminatedString
	call crlf
	
	jmp complexIfBlock_done			; } // End else if 2 block body

complexIfBlock_else:				; { // Begin else block body

	;	Say we're in the else block
	mov rdi, COMPLEX_IF_ELSE
	call printNullTerminatedString
	call crlf
	
	jmp complexIfBlock_done			; } // End else block body


;	At this point, the IF block is finished, and the following code comes AFTER the if block
complexIfBlock_done:
	
	;
	mov rdi, COMPLEX_IF_DONE
	call printNullTerminatedString
	call crlf
	
	;	Epilogue
	pop r14
	pop r13
	pop r12
	
	ret

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

;;;
; Custom function to print a separator
; void separator();
separator:
	
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




