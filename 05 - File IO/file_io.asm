

;;;;;;;;;;;;;;;;;;;;;;;;;
; Assembly w/ Professor P


;;;;;;;;;;;;;;
; Data Section
section .data

;;;
; CStrings

FILE_NAME_INPUT				db		"input.txt",0
FILE_NAME_OUTPUT			db		"output.txt",0

FILE_OPEN_SUCCESS_MSG		db	"Successfully opened the file: "
FILE_OPEN_SUCCESS_MSG_LEN	equ	$-FILE_OPEN_SUCCESS_MSG

FILE_OPEN_FAIL_MSG			db	"Failed to opened the file"
FILE_OPEN_FAIL_MSG_LEN		equ	$-FILE_OPEN_FAIL_MSG

FILE_DONE_MSG				db	"Done reading the file"
FILE_DONE_MSG_LEN			equ	$-FILE_DONE_MSG

FILE_BYTE_DELIMITER_MSG		db	" ==> "
FILE_BYTE_DELIMITER_MSG_LEN	equ	$-FILE_BYTE_DELIMITER_MSG

CRLF				db		13,10
CRLF_LEN			equ		$-CRLF


;;;
; System Calls
SYS_OPEN			equ		2
SYS_CLOSE			equ		3
SYS_READ			equ		0
SYS_WRITE			equ		1
;
FILE_MODE_READONLY	equ		0


;;;
; File descriptors
FD_STDOUT			equ		1


;;;
; Exit codes
EXIT_SUCCESS		equ		0



;;;;;;;;;;;;;
; BSS Section
section .bss

MY_BUFFER			resb	8192


;;;;;;;;;;;;;;
; Text Section
section .text


;;;;;;;;;;;;;;;;;;;;;;
; Our external symbols
extern libPuhfessorP_printSignedInteger64


; Our entry point
; long file_io();
; Calls our tests and stuff
global file_io
file_io:
	
	call read_test
	call crlf
	
	; We're done
	mov rax, EXIT_SUCCESS	; Mov 7 into rax (our return code)
	ret						; Return control back to GCC libraries (aka exit our program)


;;;
;	void read_test()
;	Register usage:
;	r12: File descriptor
read_test:
	
	; Prologue
	push r12
	
	;	Let's open the file!
	mov rax, SYS_OPEN				; System will open a file for us
	mov rdi, FILE_NAME_INPUT		; Address of NULL terminated file name
	mov rsi, FILE_MODE_READONLY		; File status flags (readonly)
	syscall							; Ask the system to open the file
	
	;	Did it succeed?
	mov r12, rax
	cmp r12, 0						; Negative file descriptor means FAIL
	jl read_test_invalidFile		; Jump to read_test_invalidFile if the open failed
	;jmp read_test_validFile		; Otherwise, fall through to read_test_validFile

read_test_validFile:
	
	; Say yay
	mov rax, SYS_WRITE					; System call code
	mov rdi, FD_STDOUT					; Print to stdout
	mov rsi, FILE_OPEN_SUCCESS_MSG		; Pointer to first character of string to print
	mov rdx, FILE_OPEN_SUCCESS_MSG_LEN	; Length of the string to print
	syscall
	
	;	Let's print the raw value of the file descriptor,
	;	just to prove it's a number
	mov rdi, r12
	call libPuhfessorP_printSignedInteger64
	call crlf

read_test_validFile_loopTop:
	
	; Read one character
	mov rax, SYS_READ					; System call code
	mov rdi, r12						; Read from the file
	mov rsi, MY_BUFFER					; Where to store read characters
	mov rdx, 1							; Read one character
	syscall
	
	; Are we done?
	cmp rax, 0							; SYS_READ returns # of chars read, or negative for fail
	jle read_test_validFile_done
	
	; Print the character we read
	mov rax, SYS_WRITE					; System call code
	mov rdi, FD_STDOUT					; Print to stdout
	mov rsi, MY_BUFFER					; Where to print from
	mov rdx, 1							; Print one character
	syscall
	
	; Print the character delimiter
	mov rax, SYS_WRITE						; System call code
	mov rdi, FD_STDOUT						; Print to stdout
	mov rsi, FILE_BYTE_DELIMITER_MSG		; Where to print from
	mov rdx, FILE_BYTE_DELIMITER_MSG_LEN	; Print one character
	syscall
	
	; Print the character as an integer
	mov rdi, [MY_BUFFER]
	call libPuhfessorP_printSignedInteger64
	
	call crlf
	
	jmp read_test_validFile_loopTop

read_test_validFile_done:
	
	; Say we're done
	mov rax, SYS_WRITE			; System call code
	mov rdi, FD_STDOUT			; Print to stdout
	mov rsi, FILE_DONE_MSG		; Pointer to first character of string to print
	mov rdx, FILE_DONE_MSG_LEN	; Length of the string to print
	syscall
	call crlf

read_test_validFile_close:

	;	Tell the system to close the file
	mov rax, SYS_CLOSE					; Code to close a file
	mov rdi, r12						; File handle is still in r12
	syscall								; Invoke the system

	jmp read_test_done					; Yeah we're done

read_test_invalidFile:

	; Say booooo
	mov rax, SYS_WRITE					; System call code
	mov rdi, FD_STDOUT					; Print to stdout
	mov rsi, FILE_OPEN_FAIL_MSG			; Pointer to first character of string to print
	mov rdx, FILE_OPEN_FAIL_MSG_LEN		; Length of the string to print
	syscall
	call crlf

read_test_done:

	;	Epilogue
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






