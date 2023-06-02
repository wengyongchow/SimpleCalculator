TITLE Calculator

.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

INCLUDE irvine32.inc

.data
;Title, subtitle and error message
sectionTitle	BYTE "-----Math Calculator-----", 0
errorMsg		BYTE "Please select a number between -10000 to 10000 (Except 0)...", 0
errorMsg2		BYTE "The value cannot be an alphabet or a 0", 0
divErrMsg		BYTE "No data available for division because the divisor is 0",0dh, 0ah, 0dh, 0ah, 0
addTitle		BYTE "Addition		: ", 0
subsTitle		BYTE "Substraction		: ", 0
mulTitle		BYTE "Multiplication		: ", 0
divTitle		BYTE "Division		: ", 0
endProgram		BYTE "Program Ended...", 0dh, 0ah, 0dh, 0ah, 0
prompt1	byte "Enter 1st Number (-10000 to 10000): ", 0
prompt2	byte "Enter 2nd Number (-10000 to 10000): ", 0

;Arithmetic Symbols
equals	byte " = ", 0
plus	byte " + ", 0
minus	byte " - ", 0
times	byte " * ", 0
over	byte " / ", 0

;Variable and result variable
num1				sdword ?
num2				sdword ?
substraction		sdword ?
addition			sdword ?
multiplication		sdword ?
division			sdword ?
divRemainder		sdword ?
.code

main proc
	mov edx, OFFSET sectionTitle	;display title here
	call WriteString
	call crLF

	mov ecx, 0						;Maximum loops = 4,294,967,296
L1 :								;Loop to validate input for num 1
	call crLF
	mov edx, OFFSET prompt1
	call WriteString
	call ReadInt

	.IF (eax > 10000) && (eax < -10000)		;if the input is out of range, display error message and loop
		mov edx, OFFSET errorMsg
		call WriteString
		call crLF
	.ELSEIF (eax == 0)
		mov edx, OFFSET errorMsg2
		call WriteString
		call crLF
	.ELSE							;assign the input to num1
		mov ecx, 1
		mov num1, eax
	.ENDIF
	loop L1
	
	
	mov ecx, 0						;Maximum loops = 4,294,967,296
L2 :								;Loop to validate input for num 2
	call crLF						;print a new line
	mov edx, OFFSET prompt2
	call WriteString
	call ReadInt
	.IF (eax > 10000) && (eax < -10000)					;Same as L1
		mov edx, OFFSET errorMsg
		call WriteString
		call crLF
	.ELSEIF (eax == 0)
		mov edx, OFFSET errorMsg2
		call WriteString
		call crLF
	.ELSE							;assign the input to num1	
		mov ecx, 1
		mov num2, eax
	.ENDIF
	loop L2

;calculate and display add
	call crLF
	mov eax, num1					;calculate the addiion of 2 numbers
	add eax, num2
	mov addition, eax				;assign addition result to a variable

	mov edx, OFFSET addTitle		;Display result of addition
	call WriteString
	mov eax, num1
	call WriteInt
	mov edx, OFFSET plus			;Display the arithmetic symbol 
	call WriteString
	mov eax, num2
	call WriteInt
	mov edx, OFFSET equals			;Display the arithmetic symbol
	call WriteString
	mov eax, addition
	call WriteInt

;calcualte and display Sub
	call crLF
	mov eax, num1					;calculate the substraction of 2 numbers
	sub eax, num2
	mov substraction, eax			;assign subtraction result to a variable

	mov edx, OFFSET subsTitle		;Display result of substraction
	call WriteString
	mov eax, num1
	call WriteInt
	mov edx, OFFSET minus			;Display the arithmetic symbol
	call WriteString
	mov eax, num2
	call WriteInt
	mov edx, OFFSET equals			;Display the arithmetic symbol
	call WriteString
	mov eax, substraction
	call WriteInt
		
;calcualte and display multiplication
	call crLF
	mov eax, num1					;calculate the multiplication of 2 numbers
	xor edx, edx					;clear the high Dword
	imul num2
	mov multiplication, eax			;assign multiplication result to a variable

	mov edx, OFFSET mulTitle		;Display result of multiplication
	call WriteString
	mov eax, num1
	call WriteInt
	mov edx, OFFSET times			;Display the arithmetic symbol
	call WriteString
	mov eax, num2
	call WriteInt
	mov edx, OFFSET equals			;Display the arithmetic symbol
	call WriteString
	mov eax, multiplication
	call WriteInt


	call crLF
	cmp num2, 0						;Check if the divisor is 0
	JE divisionerror				
	JMP divisionFunction

divisionerror:						;prompt error and exit the program
	call crLF
	mov edx, OFFSET divErrMsg
	call WriteString
	jmp endFunction


divisionFunction:					;calculate and display the division
	mov eax, num1
	CDQ								;Clear the high qword
	mov ebx, num2
	idiv ebx

	;assign division result to a variable
	mov division, eax
	mov divRemainder, edx

	;Display result of division
	mov edx, OFFSET divTitle
	call WriteString
	mov eax, num1
	call WriteInt
	mov edx, OFFSET over			;Display the arithmetic symbol
	call WriteString
	mov eax, num2
	call WriteInt
	mov edx, OFFSET equals			;Display the arithmetic symbol
	call WriteString
	
	.IF(division == 0)
		.IF((num1 < 0) || (num2 < 0))
			mov edx, OFFSET minus			
			call WriteString
		.ENDIF
	.ENDIF

	mov eax, division				;Quotient 
	call WriteInt
	mov al, '.'						;Decimal point
    call WriteChar

	xor edx,edx						;clear the high dword
	xor eax,eax						;clear the low dword
	imul eax, divRemainder, 100		;multiply the remainder with 100
	CDQ								;extend the singed 
	idiv num2						;divide by the divisor to get the 2 digit of the decimal point
	
	;Check if the remainder is negative value, if the remainder is a negative value then change it to positive value
	.IF(num1 < 0 && num2 > 0)
		neg eax
	.ELSEIF(num1 > 0 && num2 < 0)
		neg eax
	.ENDIF

	call WriteDec	
	jmp endFunction


endFunction:						;exit the program
	call crLF
	mov edx, OFFSET endProgram
	call WriteString

main endp
end main
