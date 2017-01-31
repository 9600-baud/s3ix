[BITS 32]
global enter_long_mode

enter_long_mode:
	
.fast_a20:
	in 	 al, 0x92
	or 	 al, 2
	jnz	.disable_paging
	or	al, 2
	and al, 0xFE
	out	0x92, al

.disable_paging:
	mov eax, cr0
	and eax, 01111111111111111111111111111111b
	mov cr0, eax

.clear_tables:
	mov	edi, 0x1000
	mov	cr3, edi
	xor	eax, eax
	mov	ecx, 4096
	rep	stosd
	mov	edi, cr3

.setup_tables:
	mov 	DWORD [edi], 0x2003
	add 	edi, 0x1000
	mov 	DWORD [edi], 0x3003
	add 	edi, 0x1000
	mov 	DWORD [edi], 0x4003
	add 	edi, 0x1000

.map:
	mov 	ebx, 0x00000003
	mov 	ecx, 512
 
.SetEntry:
	mov 	DWORD [edi], ebx
	add 	ebx, 0x1000
	add 	edi, 8
	loop 	.SetEntry	; Next entry

.enable_pae:
	mov	eax, cr4
	or	eax, 1 << 5
	mov	cr4, eax

	;; TODO: Check for protected mode here:
.from_real:
	mov	ecx, 0xC0000080	;EFER_MSR
	rdmsr
	or	eax, 1 << 8	; EFER_MSR:LM
	wrmsr

	mov	eax, cr0
	or	eax, 1 << 31 | 1 << 0 ; CR0:PG, CR0:PM
	mov	cr0, eax

GDT64:                           ; Global Descriptor Table (64-bit).
	.Null: equ $ - GDT64         ; The null descriptor.
	dw 0                         ; Limit (low).
	dw 0                         ; Base (low).
	db 0                         ; Base (middle)
	db 0                         ; Access.
	db 0                         ; Granularity.
	db 0                         ; Base (high).
	.Code: equ $ - GDT64         ; The code descriptor.
	dw 0                         ; Limit (low).
	dw 0                         ; Base (low).
	db 0                         ; Base (middle)
	db 10011010b                 ; Access (exec/read).
	db 00100000b                 ; Granularity.
	db 0                         ; Base (high).
	.Data: equ $ - GDT64         ; The data descriptor.
	dw 0                         ; Limit (low).
	dw 0                         ; Base (low).
	db 0                         ; Base (middle)
	db 10010010b                 ; Access (read/write).
	db 00000000b                 ; Granularity.
	db 0                         ; Base (high).
	.Pointer:                    ; The GDT-pointer.
	dw $ - GDT64 - 1             ; Limit.
	dq GDT64                     ; Base.

	lgdt [GDT64.Pointer]
	
.enter_64:
	jmp GDT64.Code:Realm64
	
.done:
	hlt

[BITS 64]
Realm64:
	cli
	ret
