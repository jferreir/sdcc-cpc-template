    .module crt0

    ;; (linker documentation:) where specific ordering is desired - 
    ;; the first linker input file should have the area definitions 
    ;; in the desired order
    .area   _HOME
    .area   _CODE
    .area   _INITIALIZER
    .area   _GSINIT
    .area   _GSFINAL

    .area   _DATA
    .area   _INITIALIZED
    .area   _BSEG
    .area   _BSS
    .area   _HEAP

    .area _CODE

    di
    im 1
    ld sp,#0x0100

    ;; wait vsync
    ld b,#0xf5

vsync_nsync:
    in a,(c)
    rra
    jr nc,vsync_nsync

    ld a,#0xc3
    ld (#0x0038),a
    ld hl,#int_handler
    ld (#0x0039),hl

    ei

	ld	bc, #l__INITIALIZER
	ld	a, b
	or	a, c
	jr	z, gsinit_next
	ld	de, #s__INITIALIZED
	ld	hl, #s__INITIALIZER
	ldir

gsinit_next:
    jp _main

; _raster_vector_table should be located at the start of a page
_raster_vector_table::
    .dw raster_interrupt_handler_default
    .dw raster_interrupt_handler_default
    .dw raster_interrupt_handler_default
    .dw raster_interrupt_handler_default
    .dw raster_interrupt_handler_default
    .dw raster_interrupt_handler_default

int_handler:
    push af
    ex af,af
    push af
    push bc
    push de
    push hl
    exx
    push bc
    push de
    push hl
    push ix
    push iy
 
    ld hl,#_raster_int_idx+1
    ld b,#0xf5
    in a,(c)
    rra
    jr nc,_nexti        ; check VSYNC
    ld (hl),#0xff         ; If VBL happens the interrupt counter will contain a zero
_nexti:
    inc (hl)

_raster_int_idx:
    ld a,#0
    add a
    ld h,#>_raster_vector_table
    ld l,a

    ld a,(hl)
    inc l
    ld h,(hl)
    ld l,a
    ld bc,#_reti
    push bc
    jp (hl)

_reti:
    pop iy
    pop ix
    pop hl
    pop de
    pop bc
    exx
    pop hl
    pop de
    pop bc
    pop af
    ex af,af
    pop af
    
raster_interrupt_handler_default:
    ei
    ret    


