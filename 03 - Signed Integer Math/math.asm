

;;;;;;;;;;;;;;;;;;;;;;;;;
; Assembly w/ Professor P


;;;;;;;;;;;;;;
; Data Section
section .data


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


; Integers
MY_INT_A			dq		233
MY_INT_B			dq		256


;;;;;;;;;;;;;
; BSS Section

MY_INT_C			resq	1


;;;;;;;;;;;;;;
; Text Section
section .text


;;;;;;;;;;;;;;;;;;;;;;
; Our external symbols
extern libPuhfessorP_printSignedInteger64
extern libPuhfessorP_printRegisters


; Our entry point
global math
math:
	
	; Load 
	call multiplyTest
	call divideTest
	
	; We're done
	mov rax, EXIT_SUCCESS	; Mov 7 into rax (our return code)
	ret						; Return control back to GCC libraries (aka exit our program)

;;;;;;;;;;;;;;;
; Multiply test
; void multiplyTest();
multiplyTest:
	
	; Prologue
	push r12
	push r13
	push r14
	push r15
	
	; Multiply immediates
	mov r12, 233	; Setup r12
	mov r13, 256	; Setup r13
	imul r12, r13	; Multiply (signed int64) r12 by r13, and put the result into r12
					; This could also be commented as r12 = r12 * r13
	
	; Ask libP to print the result (immediates)
	mov rdi, r12								; First integer argument goes into rdi
	call libPuhfessorP_printSignedInteger64		; Do a call (will return like a func)
	call crlf
	
	; Multiply global memory (slow)
	mov r14, [MY_INT_A]	; Setup r14
	mov r15, [MY_INT_B]	; Setup r15
	imul r14, r15		; r14 = r14 * r15
	
	; Extra stuff for fun
	inc qword r14		; r14++
	add r14, 5			; r14 = r14 + 5
	
	; Ask libP to print the result (global memory)
	mov rdi, r14								; First integer argument goes into rdi
	call libPuhfessorP_printSignedInteger64		; Do a call (will return like a func)
	call crlf
	
	; Epilogue
	pop r15
	pop r14
	pop r13
	pop r12
	
	ret


;;;;;;;;;;;;;
; Divide Test
; void divideTest();
divideTest:
	
	; Prologue
	push r12
	push r14
	push r15
	
	mov rax, 256	; Setup rax (numerator)
	cqo				; Stretch rax (64-bits) onto the 128-bit combination of rdx:rax
					; The numerator is now setup
	
	mov r12, 233
	idiv r12		; Divide the numerator by 233
					; rax now contains the answer
					; rdx now contains the remainder
	
	; Save the result of our division elsewhere
	; rax and rdx are not callee-saved, so they are unsafe across any function call
	; Let's just use other registers, since registers are very fast
	mov r14, rax
	mov r15, rdx
	
	; Ask libP to print the answer
	mov rdi, r14								; First integer argument goes into rdi
	call libPuhfessorP_printSignedInteger64		; Do a call (will return like a func)
	call crlf
	
	; Ask libP to print the remainder
	mov rdi, r15								; First integer argument goes into rdi
	call libPuhfessorP_printSignedInteger64		; Do a call (will return like a func)
	call crlf
	
	; Epilogue
	pop r15
	pop r14
	pop r12
	
	ret

;;;
; Custom function to print a CRLF
; void crlf();
crlf:

	; Prologue
	push r12
	push r13

	; Just to have a reason to preserve some callee-saved registers,
	; let's mess with the values of r12 and r13
	mov r12, 5
	mov r13, 9

	; Print the CRLF!
	mov rax, SYS_WRITE	; System call code
	mov rdi, FD_STDOUT	; Print to stdout
	mov rsi, CRLF		; Pointer to first character of string to print
	mov rdx, CRLF_LEN	; Length of the string to print
	syscall

	; Epilogue
	pop r13
	pop r12

	ret






