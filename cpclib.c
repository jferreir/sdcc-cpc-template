#include "cpclib.h"

/* inline handling See https://sourceforge.net/p/sdcc/discussion/1864/thread/78ab297c/ */
extern inline void cpclib_set_raster_interrupt_handler(uint8_t interrupt, void (*interrupt_handler)(void));

void cpclib_set_border(uint8_t c)
{
    (void)c;    
    __asm;
    ld bc, #0x7f10
    out (c), c
    out (c), a
    __endasm;
}

