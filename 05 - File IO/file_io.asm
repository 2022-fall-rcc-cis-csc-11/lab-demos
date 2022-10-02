

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

FILE_OPEN_FAIL_MSG			db	"Failed to opened the input file"
FILE_OPEN_FAIL_MSG_LEN		equ	$-FILE_OPEN_FAIL_MSG

FILE_DONE_MSG				db	"Done reading the input file"
FILE_DONE_MSG_LEN			equ	$-FILE_DONE_MSG

FILE_BYTE_DELIMITER_MSG		db	" ==> "
FILE_BYTE_DELIMITER_MSG_LEN	equ	$-FILE_BYTE_DELIMITER_MSG

FILE_OUT_OPEN_FAIL_MSG		db	"Failed to opened the output file: "
FILE_OUT_OPEN_FAIL_MSG_LEN	equ	$-FILE_OUT_OPEN_FAIL_MSG

PROMPT_MSG					db	"Please enter up to 8K of characters: "
PROMPT_MSG_LEN				equ	$-PROMPT_MSG

ECHO_STDIN_MSG				db	"You entered: "
ECHO_STDIN_MSG_LEN			equ	$-ECHO_STDIN_MSG

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
FILE_MODE_WRITEONLY	equ		1
FILE_MODE_READWRITE equ		2


;;;
; File descriptors
FD_STDIN			equ		0
FD_STDOUT			equ		1


;;;
; Exit codes
EXIT_SUCCESS		equ		0


UPPERCASE_SUBTRACTOR		equ		32


;;;;;;;;;;;;;
; BSS Section
section .bss

MY_BUFFER			resb	8192
MY_CHAR				resb	1


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
	
	call read_write_test
	call crlf
	
	call stdin_test
	call crlf
	
	; We're done
	mov rax, EXIT_SUCCESS	; Mov 7 into rax (our return code)
	ret						; Return control back to GCC libraries (aka exit our program)


;;;
;	void read_write_test()
;	Register usage:
;	r12: Input file descriptor
;	r13: Output file descriptor
read_write_test:
	
	; Prologue
	push r12
	push r13
	
	;	Let's open the input file!
	mov rax, SYS_OPEN				; System will open a file for us
	mov rdi, FILE_NAME_INPUT		; Address of NULL terminated file name
	mov rsi, FILE_MODE_READONLY		; File status flags (readonly)
	syscall							; Ask the system to open the file
	
	;	Did it succeed?
	mov r12, rax
	cmp r12, 0						; Negative file descriptor means FAIL
	jl read_write_test_invalidFile		; Jump to read_write_test_invalidFile if the open failed
	;jmp read_write_test_validFile		; Otherwise, fall through to read_write_test_validFile

read_write_test_validFile:
	
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

read_write_test_openWrite:
	
	;	Let's open the output file!
	mov rax, SYS_OPEN				; System will open a file for us
	mov rdi, FILE_NAME_OUTPUT		; Address of NULL terminated file name
	mov rsi, FILE_MODE_WRITEONLY	; File status flags (writeonly)
	syscall							; Ask the system to open the file
	
	;	Did it succeed?
	mov r13, rax
	cmp r13, 0									; Negative file descriptor means FAIL
	jl read_write_test_openWrite_invalidFile	; Jump to read_write_test_invalidFile if the open failed
	;jmp read_write_test_openWrite_validFile	; Otherwise, fall through to read_write_test_validFile

read_write_test_openWrite_validFile:
	
	jmp read_write_test_validFile_loopTop
	
read_write_test_openWrite_invalidFile:
	
	; Print a complaint
	mov rax, SYS_WRITE					; System call code
	mov rdi, FD_STDOUT					; Print to stdout
	mov rsi, FILE_OUT_OPEN_FAIL_MSG		; Where to print from
	mov rdx, FILE_OUT_OPEN_FAIL_MSG_LEN	; Print one character
	syscall
	
	; Print the bad handle/result
	mov rdi, r13
	call libPuhfessorP_printSignedInteger64
	
	call crlf
	
	;	Tell the system to close the input file
	mov rax, SYS_CLOSE					; Code to close a file
	mov rdi, r12						; File handle is still in r12
	syscall								; Invoke the system
	
	jmp read_write_test_done
	
read_write_test_validFile_loopTop:
	
	; Read one character
	mov rax, SYS_READ					; System call code
	mov rdi, r12						; Read from the file
	mov rsi, MY_BUFFER					; Where to store read characters
	mov rdx, 1							; Read one character
	syscall
	
	; Are we done?
	cmp rax, 0							; SYS_READ returns # of chars read, or negative for fail
	jle read_write_test_validFile_done
	
	;	Before writing the char to the output file
	;	convert it to uppercase
	;	(assumes the file only contains characters)
	mov r11, [MY_BUFFER]
	sub r11, UPPERCASE_SUBTRACTOR
	mov [MY_CHAR], r11
	
	; Write the character into the output file
	mov rax, SYS_WRITE					; System call code
	mov rdi, r13						; Print to stdout
	mov rsi, MY_CHAR					; Where to write from
	mov rdx, 1							; Write one character
	syscall
	
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
	
	jmp read_write_test_validFile_loopTop

read_write_test_validFile_done:
	
	; Say we're done
	mov rax, SYS_WRITE			; System call code
	mov rdi, FD_STDOUT			; Print to stdout
	mov rsi, FILE_DONE_MSG		; Pointer to first character of string to print
	mov rdx, FILE_DONE_MSG_LEN	; Length of the string to print
	syscall
	call crlf

read_write_test_validFile_close:

	;	Tell the system to close the file
	mov rax, SYS_CLOSE					; Code to close a file
	mov rdi, r12						; File handle is still in r12
	syscall								; Invoke the system

	jmp read_write_test_done					; Yeah we're done

read_write_test_invalidFile:

	; Say booooo
	mov rax, SYS_WRITE					; System call code
	mov rdi, FD_STDOUT					; Print to stdout
	mov rsi, FILE_OPEN_FAIL_MSG			; Pointer to first character of string to print
	mov rdx, FILE_OPEN_FAIL_MSG_LEN		; Length of the string to print
	syscall
	call crlf

read_write_test_done:

	;	Epilogue
	pop r13
	pop r12
	
	ret


;;;;;;;;;;;;;;;;;;;;;
;	void stdin_test()
;	Register usage:
;	r12: # of character inputted
stdin_test:
	
	;	Prologue
	push r12
	
	;	Ask user to enter some stuff
	mov rax, SYS_WRITE			; System call code
	mov rdi, FD_STDOUT			; Print to stdout
	mov rsi, PROMPT_MSG			; Pointer to first character of string to print
	mov rdx, PROMPT_MSG_LEN		; Length of the string to print
	syscall
	
	; Read up to 8K of characters
	mov rax, SYS_READ					; System call code
	mov rdi, FD_STDIN					; Read from the file
	mov rsi, MY_BUFFER					; Where to store read characters
	mov rdx, 8192						; Read the characters
	syscall
	
	mov r12, rax						; For simplicity, assume it was successful
	
	;	Tell the user they entered something ... 
	mov rax, SYS_WRITE			; System call code
	mov rdi, FD_STDOUT			; Print to stdout
	mov rsi, ECHO_STDIN_MSG		; Pointer to first character of string to print
	mov rdx, ECHO_STDIN_MSG_LEN	; Length of the string to print
	syscall
	
	;	Echo the user's input back to them
	mov rax, SYS_WRITE			; System call code
	mov rdi, FD_STDOUT			; Print to stdout
	mov rsi, MY_BUFFER			; Pointer to first character of string to print
	mov rdx, r12				; Length of the string to print
	syscall
	
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






