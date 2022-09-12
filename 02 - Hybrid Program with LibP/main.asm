

;;;;;;;;;;;;;;;;;;;;;;;;;
; Assembly w/ Professor P


;;;;;;;;;;;;;;
; Data Section
section .data


;;;
; CStrings
ASK_INPUT_MSG			db		"Please enter an unsigned 64-bit integer: "
ASK_INPUT_MSG_LEN		equ		$-ASK_INPUT_MSG

ECHO_INPUT_BEFORE_MSG		db		"You entered the super cool number *****"
ECHO_INPUT_BEFORE_MSG_LEN	equ		$-ECHO_INPUT_BEFORE_MSG
ECHO_INPUT_AFTER_MSG		db		"*****. How cool !",13,10
ECHO_INPUT_AFTER_MSG_LEN	equ		$-ECHO_INPUT_AFTER_MSG


;;;
; Ints
MY_INT			dq		0


;;;
; System Calls
SYS_WRITE		equ		1


;;;
; File descriptors
FD_STDOUT		equ		1


;;;
; Exit codes
EXIT_SUCCESS		equ		0


;;;;;;;;;;;;;;
; Text Section
section .text


;;;;;;;;;;;;;;;;;;;;;;
; Our external symbols
extern libPuhfessorP_inputSignedInteger64
extern libPuhfessorP_printSignedInteger64
extern hybrid_cool


; Our entry point
global main
main:

	; Ask the user for input
	mov rax, SYS_WRITE		; System call code
	mov rdi, FD_STDOUT		; Print to stdout
	mov rsi, ASK_INPUT_MSG		; Pointer to first character of string to print
	mov rdx, ASK_INPUT_MSG_LEN	; Length of the string to print
	syscall

	; Ask libP to help us input an int64
	call libPuhfessorP_inputSignedInteger64
	mov [MY_INT], rax

	; Echo the user's input back to them (before part)
	mov rax, SYS_WRITE			; System call code
	mov rdi, FD_STDOUT			; Print to stdout
	mov rsi, ECHO_INPUT_BEFORE_MSG		; Pointer to first character of string to print
	mov rdx, ECHO_INPUT_BEFORE_MSG_LEN	; Length of the string to print
	syscall

	; Increase the integer
	inc qword [MY_INT]

	; Utilize libP to print the integer back to the user
	; It's using the signature: void libPuhfessorP_inputSignedInteger64(long)
	mov rdi, [MY_INT]
	call libPuhfessorP_printSignedInteger64

	; Echo the user's input back to them (after part)
	mov rax, SYS_WRITE			; System call code
	mov rdi, FD_STDOUT			; Print to stdout
	mov rsi, ECHO_INPUT_AFTER_MSG		; Pointer to first character of string to print
	mov rdx, ECHO_INPUT_AFTER_MSG_LEN	; Length of the string to print
	syscall

	; We're done
	mov rax, EXIT_SUCCESS	; Mov 7 into rax (our return code)
	ret			; Return control back to GCC libraries (aka exit our program)





