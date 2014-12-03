/*
 * ServoDrive.xc
 *
 *  Created on: Oct 27, 2014
 *      Author: nathan
 */

#include <xs1.h>
#include <platform.h>
#include "servo.h"

//in port encoderA = XS1_PORT_1H;
//in port encoderB = XS1_PORT_1G;

void servo_drive_task(client interface servo_control_interface sci)
{
    int microseconds = 989;
    while(1)
    {
        sci.set_pulse_duration_us(SERVO_1, microseconds);
        delay_milliseconds(1000);

        microseconds += 50;
        if (microseconds >= 2137)
        {
            microseconds = 989;
        }
    }
}

int main(void)
{
    interface servo_control_interface sci;
    par
    {
        servo_task(sci);
        servo_drive_task(sci);
    }
    return 0;
}
