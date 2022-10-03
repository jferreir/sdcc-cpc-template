#ifndef CPCLIB_H
#define CPCLIB_h

#include <stdint.h>

#define CPCLIB_COLOR_BLACK          (0x54)
#define CPCLIB_COLOR_BLUE           (0x44)
#define CPCLIB_COLOR_BRIGHT_BLUE    (0x55)

extern void (*raster_vector_table[6])(void);

#define cpclib_enable_interrupts() do { \
    __asm; \
    ei \
    __endasm; \
} while(0)

#define cpclib_disable_interrupts() do { \
    __asm; \
    di \
    __endasm; \
} while(0)

#define break() do { \
    __asm; \
    .db 0xed, 0xff \
    __endasm; \
} while(0)

inline void cpclib_set_raster_interrupt_handler(uint8_t interrupt, void (*interrupt_handler)(void))
{
    raster_vector_table[interrupt] = interrupt_handler;
}

void cpclib_set_border(uint8_t c);

#endif