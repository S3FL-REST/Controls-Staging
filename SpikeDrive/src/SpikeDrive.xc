/*
 * SpikeDrive.xc
 *
 *  Created on: Oct 28, 2014
 *      Author: nathan
 */

#include <xs1.h>
#include <stdio.h>
#include <timer.h>

out port wht = XS1_PORT_1G;
out port red = XS1_PORT_1H;

int main(void)
{
    wht <: 0;
    red <: 0;
    while (1)
    {
        wht <: 1;
        red <: 0;
        delay_milliseconds(5000);
        wht <: 0;
        red <: 1;
        delay_milliseconds(5000);
    }
    return 0;
}
