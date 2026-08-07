

reset:
	rjmp start

.org PORTB_PORT_vect
	rjmp pb5_isr

start:
	clr r16
	out VPORTB_DIR, r16				;set port B as inputs
	out VPORTC_DIR, r16				;set portC as inputs

	ldi r16, 0xFF
	out VPORTD_DIR, r16				;set portD as outputs
	clr r16
	out VPORTD_OUT, r16				;set outputs 0

	lds r16, PORTB_PIN5CTRL
	sbr r16, (1<<0)
	sts PORTB_PIN5CTRL, r16			;enable PB5 rising edge interrupt

	sei

main:
	nop
	rjmp main

pb5_isr:
	cli

	push r16
	in r16, CPU_SREG
	push r16
	push r17

	rcall scan_to_value
	out VPORTD_OUT, r17

	ldi r16, (1<<5)
	sts PORTB_INTFLAGS, r16			;disable pb5 intflags 

	pop r17
	pop r16
	out CPU_SREG, r16
	pop r16

	sei
	reti

scan_to_value:
	in r16, VPORTC_IN
	andi r16, 0xF0					;upper nibble
	swap r16						;switch to lower nibble
	rcall reset_keys				;bring Z pointer back

	ldi r17, 0x00
	add ZL, r16						;ADD OFFSET FROM KEYENCODER TO ZL
	adc ZH, r17						;ADD ANY CARRY FROM ZL TO ZH, R17 SET TO 0

	lpm r17, Z
	ret

reset_keys:
	ldi ZL, LOW(mapped_keys * 2)
	ldi ZH, HIGH(mapped_keys * 2)
	ret

mapped_keys:
	.db 0x01, 0x04, 0x07, 0x0A, 0x02, 0x05, 0x08, 0x00, 
	.db 0x03, 0x06, 0x09, 0x0B, 0x0F, 0x0E, 0x0D, 0x0C