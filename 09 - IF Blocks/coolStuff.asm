

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


CRLF				db		13,10,0

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
	;;;;
	
	;	Welcome message
	mov rdi, WELCOME_MSG
	call printNullTerminatedString
	call crlf
	
	;
	mov rdi, 50
	call regularIfBlock
	call crlf
	;
	mov rdi, 100
	call regularIfBlock
	call crlf
	
	; Epilogue
	;;;
	
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
									; } // end of the IF body
regularIfBlock_done:
	
	;	Print the DONE message
	mov rdi, REGULAR_IF_DONE
	call printNullTerminatedString
	call crlf
	
	;	Epilogue
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






