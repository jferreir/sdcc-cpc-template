#include "cpclib.h"

void ISR_0(void)
{
    cpclib_set_border(CPCLIB_COLOR_BLACK);
}

void ISR_1(void)
{
    cpclib_set_border(CPCLIB_COLOR_BLUE);
}

void main(void)
{
    cpclib_disable_interrupts();
    cpclib_set_raster_interrupt_handler(0, ISR_0);
    cpclib_set_raster_interrupt_handler(1, ISR_1);
    cpclib_set_raster_interrupt_handler(2, ISR_0);
    cpclib_set_raster_interrupt_handler(3, ISR_1);
    cpclib_set_raster_interrupt_handler(4, ISR_0);
    cpclib_set_raster_interrupt_handler(5, ISR_1);
    cpclib_enable_interrupts();
    while(1);
}
