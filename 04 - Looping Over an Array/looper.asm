

;;;;;;;;;;;;;;;;;;;;;;;;;
; Assembly w/ Professor P


;;;;;;;;;;;;;;
; Data Section
section .data


;;;
; The array of .... bytes?
THE_BYTES					db		"Hello, this is an array of bytes"
THE_BYTES_LEN				equ		$-THE_BYTES


;	Junk data
JUNK_DATA					db		1,2,3,4,5,233


;	Null terminated string
NULL_TERMINATED_STRING		db		"YO, this is a null-terminated string, baby!!!",0


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
	
	; Do the printTwoTest
	call printTwoTest
	call crlf
	call crlf
	
	; Print the whole string
	mov rdi, THE_BYTES
	mov rsi, THE_BYTES_LEN
	call printNBytes
	call crlf
	call crlf
	
	; Print the null-terminated string
	mov rdi, NULL_TERMINATED_STRING
	call printNullTerminatedString
	call crlf
	call crlf
	
	; OOFF, printNullTerminatedString doesn't work well with
	; strings that aren't null-terminated
	mov rdi, THE_BYTES
	call printNullTerminatedString
	call crlf
	call crlf
	
	; We're done
	mov rax, EXIT_SUCCESS	; Mov EXIT_SUCCESS into rax (our return code)
	ret						; Return control back to GCC libraries (aka exit our program)


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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	void printNBytes(char* p, long numberOfBytes);
;	Prints a specified number of bytes, starting at the given pointer
;	Register usage:
;	r12: Running pointer
;	r13: Number of bytes left to print
printNBytes:
	
	; Prologue
	push r12
	push r13
	
	;	Grab function arguments
	mov r12, rdi
	mov r13, rsi
	
printNBytes_loopTop:	; while (r13 != 0)
	
	cmp r13, 0					; if ( r13 == 0 ) {
	je printNBytes_loopDone		; 	goto printNBytes_loopDone
								; }

printNBytes_loopBody:	; {

	; Print the character pointed to by r12
	mov rax, SYS_WRITE	; System call code
	mov rdi, FD_STDOUT	; Print to stdout
	mov rsi, r12		; Pointer to first character of string to print
	mov rdx, 1			; Length of the string to print
	syscall

	; Advance stuff
	inc r12				; (r12++) Advance the running pointer
	dec r13				; (r13--) Decrease number of characters to print remaining

						; }
	
	; Jump back up to the top of the loop
	jmp printNBytes_loopTop

printNBytes_loopDone:
	
	; Epilogue
	pop r13
	pop r12
	
	ret

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






