

;;;;;;;;;;;;;;;;;;;;;;;;;
; Assembly w/ Professor P


;;;;;;;;;;;;;;
; Data Section
section .data


;;;
; The array of .... bytes?
THE_BYTES			db		"Hello, this is an array of bytes"
THE_BYTES_LEN		equ		$-THE_BYTES


;;;
; CStrings

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
; none yet


; Our entry point
; long looper();
; Loops through an array of bytes (characters), printing each one
; Register usage:
; r12: Running pointer
global looper
looper:
	
	call printTwoTest
	
	; We're done
	mov rax, EXIT_SUCCESS	; Mov 7 into rax (our return code)
	ret						; Return control back to GCC libraries (aka exit our program)


;;;;;;;;;;;;;;;;;;;;;;;;
;	void printTwoTest();
printTwoTest:
	
	;
	mov rdi, THE_BYTES
	call printTwoBytes
	
	;
	mov rdi, THE_BYTES
	inc rdi
	call printTwoBytes
	
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;
;	void printTwoBytes(char* p);
;	prints exactly two bytes
printTwoBytes:
	
	; Prologue
	push r12
	
	; Setup r12 as our running pointer to THE_BYTES
	mov r12, rdi
	
	; Print the first character
	mov rax, SYS_WRITE	; System call code
	mov rdi, FD_STDOUT	; Print to stdout
	mov rsi, r12		; Pointer to first character of string to print
	mov rdx, 1			; Length of the string to print
	syscall
	
	inc r12				; Increase r12 so it points to the second character
	
	; Print the second character
	mov rax, SYS_WRITE	; System call code
	mov rdi, FD_STDOUT	; Print to stdout
	mov rsi, r12		; Pointer to first character of string to print
	mov rdx, 1			; Length of the string to print
	syscall
	
	;
	call crlf
	
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






