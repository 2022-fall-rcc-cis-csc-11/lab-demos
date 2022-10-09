

;;;;;;;;;;;;;;;;;;;;;;;;;
; Assembly w/ Professor P


;;;;;;;;;;;;;;
; Data Section
section .data


CHAR_ARRAY_LENGTH	equ		50
CHAR_SIZE			equ		1

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
extern libPuhfessorP_printSignedInteger64


; Our entry point
; long looper();
global looper
looper:
	
	;
	call localArrayTest
	
	; We're done
	mov rax, EXIT_SUCCESS	; Mov the EXIT_SUCCESS code into rax (our return code)
	ret						; Return control back to GCC libraries (aka exit our program)

;;;;;;;;;;;;;;;;;;;;;;;;;
;	void localArrayTest()
; Initializes and loops through a LOCAL array of bytes (characters), printing each one
; Register usage:
; r12: Current index of the byte we're looking at
; r13: Computed address of the current byte
localArrayTest:
	
	; Prologue
	push r12
	push r13
	push rbp				; Preserve the base pointer register,
							; because messing it up would be BAD
	
	;	NOW, we can utilize the base pointer to keep track
	;	of where our stack started
	mov rbp, rsp
	
	;	Use r10 to represent how many bytes we need on the stack
	;	for our local array of chars
	mov r10, CHAR_ARRAY_LENGTH
	imul r10, CHAR_SIZE
	sub rsp, r10

localArrayTest_loopInit:
	
	mov r12, 0				; Init r12 (index of byte) to 0

localArrayTest_loopTop:
	
	;	We're finished once r12 (index of byte) is out of bounds
	cmp r12, CHAR_ARRAY_LENGTH
	je localArrayTest_loopDone
	
	;	Calculate a pointer to the current byte
	lea r10, [rbp - (CHAR_ARRAY_LENGTH * CHAR_SIZE)]	; Pointer to first byte
	lea r13, [r10 + (r12 * CHAR_SIZE)]					; Pointer to the current byte
	
	;	Fill the current byte with something ... how about the index + 65
	mov r10, r12			; Setup the value to fill
	add r10, 65
	mov [r13], r10b			; Actually set r10 into the byte POINTED TO BY r13 (yes, dereferencing)
							; In this example, we use the r10b form of the r10 register,
							;	to indicate that we only want to consider the lowest BYTE (not full 8 bytes)
							;	of the register, when moving into memory. This ensures that
							;	only one byte is actualy written into memory.
							;	If we had used r10, then we'd be using an 8 byte register,
							;	and it would be assumed that we wanted to write 8 bytes into
							;	memory as well, which would corrupt some data beyond our array (once we reached the end)
							;	and generally not work.
	
	;	Increase the index, then jump to the top of the loop
	inc r12
	jmp localArrayTest_loopTop
	
localArrayTest_loopDone:
	
	;	Test: Try to print our character using printNBytes
	lea rdi, [rbp - (CHAR_ARRAY_LENGTH * CHAR_SIZE)]	; Pointer to first byte
	mov rsi, CHAR_ARRAY_LENGTH
	call printNBytes
	call crlf
	
	; Epilogue
	mov rsp, rbp
	pop rbp
	pop r13
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
	
	; Print the CRLF!
	mov rax, SYS_WRITE	; System call code
	mov rdi, FD_STDOUT	; Print to stdout
	mov rsi, CRLF		; Pointer to first character of string to print
	mov rdx, CRLF_LEN	; Length of the string to print
	syscall

	ret






