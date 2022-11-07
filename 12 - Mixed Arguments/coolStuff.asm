

;;;;;;;;;;;;;;;;;;;;;;;;;
; Assembly w/ Professor P


;;;;;;;;;;;;;;
; Data Section
section .data


;;;
; CStrings

WELCOME_MSG						db	"Welcome to the coolStuff module!",0

CMIXEDARGS_RET_VAL_PREFIX_MSG	db	"c_mixed_args returned: ",0

CMIXEDARGS_PTR_BEFORE_MSG		db	"The value of our variables before C modified them: ",0
CMIXEDARGS_PTR_AFTER_MSG		db	"The value of our variables after C modified them: ",0

RECEIVER_BEGIN_MSG					db	"Assembly receiver - BEGIN",0
RECEIVED_INT_VARS_ANNOUNCE_MSG		db	"Received the following integer arguments: ",0
RECEIVED_FLOAT_VARS_ANNOUNCE_MSG	db	"Received the following float arguments: ",0
RECEIVER_END_MSG					db	"Assembly receiver - END",0

ARRAY_RECEIVER_BEGIN			db	"Begin Array Receiver (asm)",0
ARRAY_RECEIVER_END				db	"End Array Receiver (asm)",0

; Data
MY_FLOAT_1						dq	18761.18761
MY_FLOAT_2						dq	28762.28762
MY_FLOAT_3						dq	38763.38763

MY_INT_FOR_C_PTR_STUFF			dq	1234
MY_FLOAT_FOR_C_PTR_STUFF		dq	12.34

RECEIVER_FLOAT_1				dq	0.0
RECEIVER_FLOAT_2				dq	0.0
RECEIVER_FLOAT_MULTIPLIER_1		dq	3.3
RECEIVER_FLOAT_MULTIPLIER_2		dq	30.3

ARRAY_RECEIVER_DATA_1			dq	10.1
ARRAY_RECEIVER_DATA_2			dq	15.2
ARRAY_RECEIVER_DATA_3			dq	20.3
ARRAY_RECEIVER_DATA_4			dq	25.4
ARRAY_RECEIVER_DATA_5			dq	30.5


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


;;;;;;;;;;;;;
; BSS Section
section .bss

MY_DATA_ARRAY		resq	5

;;;;;;;;;;;;;;
; Text Section
section .text


;;;;;;;;;;;;;;;;;;;;;;
; Our external symbols
extern libPuhfessorP_printRegisters
extern libPuhfessorP_printSignedInteger64
extern libPuhfessorP_printFloat64
extern c_mixed_args
extern receiveFloatArrayFromAssembly


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
	call cMixedArgsTests
	
	;
	call separator
	
	; Epilogue
	;	n/a
	
	; Return because we're done
	ret						; Return control back to the driver module



;;;;;;;;;;;;;;;;;;;;;;;;;;
;	void cMixedArgsTests()
;	Register usage:
;		r12: Return value for function call
cMixedArgsTests:

	;	Prologue
	push r12
	push r12
	
	;	Announce the vaue of our int/float before modification by C via pointer
	mov rdi, CMIXEDARGS_PTR_BEFORE_MSG
	call printNullTerminatedString
	call newline
	;
	mov rdi, [MY_INT_FOR_C_PTR_STUFF]
	call libPuhfessorP_printSignedInteger64
	call newline
	;
	movsd xmm0, [MY_FLOAT_FOR_C_PTR_STUFF]
	call libPuhfessorP_printFloat64
	call newline
	call newline
	
	;	Call c_mixed_args and save its return value
	;	long c_mixed_args(
	;		long a, long b,
	;		double c, double d,
	;		long * pLong, double * pDouble,
	;		long e,
	;		double f
	;	);
	mov rdi, 57372763							; Move value into 1st integer argument
	mov rsi, 11833333							; Move value into 2nd integer argument
	movsd xmm0, [MY_FLOAT_1]					; Move value into 1st float arg
	movsd xmm1, [MY_FLOAT_2]					; Move value into 2nd float arg
	
	mov rdx, MY_INT_FOR_C_PTR_STUFF				; Move pointer (to MY_INT_FOR_C_PTR_STUFF) into 3rd integer arg
	mov rcx, MY_FLOAT_FOR_C_PTR_STUFF			; Move pointer (to MY_FLOAT_FOR_C_PTR_STUFF) into 4th integer arg
	mov r8, 99932272							; Move value into 5rd integer arg
	movsd xmm2, [MY_FLOAT_3]					; Move value into 3rd float arg
	call c_mixed_args
	mov r12, rax
	
	;	Announce the vaue of our int/float AFTER modification by C via pointer
	mov rdi, CMIXEDARGS_PTR_AFTER_MSG
	call printNullTerminatedString
	call newline
	;
	mov rdi, [MY_INT_FOR_C_PTR_STUFF]
	call libPuhfessorP_printSignedInteger64
	call newline
	;
	movsd xmm0, [MY_FLOAT_FOR_C_PTR_STUFF]
	call libPuhfessorP_printFloat64
	call newline
	call newline
	
	;	Print the return value
	mov rdi, CMIXEDARGS_RET_VAL_PREFIX_MSG
	call printNullTerminatedString
	;
	mov rdi, r12
	call libPuhfessorP_printSignedInteger64
	call crlf
	
	;	Epilogue
	pop r12
	pop r12

	ret


;;;;;;;;;;;;;;;;;;;;
;	double receiver(
;		long a, long b, double c, double d,
;		long * e, double * f
;	);
;	Register usage:
;		r12: a
;		r13: b
;		r14: e
;		r15: f
;		
global receiver
receiver:
	
	;	Prologue
	push r12
	push r13
	push r14
	push r15
	
	;	Grab the incoming arguments
	mov r12, rdi
	mov r13, rsi
	movsd [RECEIVER_FLOAT_1], xmm0
	movsd [RECEIVER_FLOAT_2], xmm1
	mov r14, rdx
	mov r15, rcx
	
	;	Print the begin message
	mov rdi, RECEIVER_BEGIN_MSG
	call printNullTerminatedString
	call newline
	
	;	Announce the int arguments and print them
	mov rdi, RECEIVED_INT_VARS_ANNOUNCE_MSG
	call printNullTerminatedString
	call newline
	;
	mov rdi, r12
	call libPuhfessorP_printSignedInteger64
	call newline
	;
	mov rdi, r13
	call libPuhfessorP_printSignedInteger64
	call newline
	
	call newline
	
	;	Announce the float arguments and print them
	push r12
	mov rdi, RECEIVED_FLOAT_VARS_ANNOUNCE_MSG
	call printNullTerminatedString
	call newline
	;
	movsd xmm0, [RECEIVER_FLOAT_1]
	call libPuhfessorP_printFloat64
	call newline
	;
	movsd xmm0, [RECEIVER_FLOAT_2]
	call libPuhfessorP_printFloat64
	call newline
	;
	pop r12
	
	call newline
	
	;	Modify the incoming (pointed-to) values
	inc qword [r14]
	;
	movsd xmm0, [r15]
	mulsd xmm0, [RECEIVER_FLOAT_MULTIPLIER_1]
	movsd [r15], xmm0
	
	;	Print the end message
	mov rdi, RECEIVER_END_MSG
	call printNullTerminatedString
	call newline
	
	movsd xmm0, [r15]
	mulsd xmm0, [RECEIVER_FLOAT_MULTIPLIER_2]
	
	;	Epilogue
	pop r15
	pop r14
	pop r13
	pop r12
	
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	void arrayReceiver(double * d)
;	Register usage:
;		r12: d
global arrayReceiver
arrayReceiver:

	;	Prologue
	push r12
	
	;	Stash incoming args
	mov r12, rdi
	
	;	Say hello
	mov rdi, ARRAY_RECEIVER_BEGIN
	call printNullTerminatedString
	call newline
	
	;	Modify the array data
	movsd xmm0, [ARRAY_RECEIVER_DATA_1]
	movsd [r12 + (0 * 8)], xmm0
	movsd xmm0, [ARRAY_RECEIVER_DATA_2]
	movsd [r12 + (1 * 8)], xmm0
	movsd xmm0, [ARRAY_RECEIVER_DATA_3]
	movsd [r12 + (2 * 8)], xmm0
	movsd xmm0, [ARRAY_RECEIVER_DATA_4]
	movsd [r12 + (3 * 8)], xmm0
	movsd xmm0, [ARRAY_RECEIVER_DATA_5]
	movsd [r12 + (4 * 8)], xmm0
	
	;	Say goodbye
	mov rdi, ARRAY_RECEIVER_END
	call printNullTerminatedString
	call newline
	
	;	Epilogue
	pop r12

	ret


;;;;;;;;;;;;
;	void arraySender();
;	Register usage:
;		r12: Pointer to MY_DATA_ARRAY
global arraySender
arraySender:
	
	;	Prologue
	push r12
	
	;	Call receiveFloatArrayFromAssembly with a pointer to our data
	mov rdi, MY_DATA_ARRAY
	call receiveFloatArrayFromAssembly
	
	mov r12, MY_DATA_ARRAY
	
	movsd xmm0, [r12 + (0 * 8)]
	call libPuhfessorP_printFloat64
	call newline
	movsd xmm0, [r12 + (1 * 8)]
	call libPuhfessorP_printFloat64
	call newline
	movsd xmm0, [r12 + (2 * 8)]
	call libPuhfessorP_printFloat64
	call newline
	movsd xmm0, [r12 + (3 * 8)]
	call libPuhfessorP_printFloat64
	call newline
	movsd xmm0, [r12 + (4 * 8)]
	call libPuhfessorP_printFloat64
	call newline
	
	;	Epilogue
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

;;;;;;;;;;;;;;;;;
; Alias for crlf();
; void newline();
newline:
	call crlf
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




