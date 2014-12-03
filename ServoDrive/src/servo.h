/**
 * @author Alexander Entinger, MSc / LXRobotics
 * @brief module for controlling three rc servos using a single core
 * @file servo.h
 * @license CC BY-NC-SA 4.0 ( http://creativecommons.org/licenses/by-nc-sa/4.0/ )
 */

#ifndef SERVO_H_
#define SERVO_H_

#include <stdint.h>

/* DEFINES */
#define MICROSECOND 100

/* TYPEDEFS */
typedef enum {SERVO_1 = 0, SERVO_2 = 1, SERVO_3 = 2} E_SERVO;

/* INTERFACES */
interface servo_control_interface
{
    void set_pulse_duration_us(E_SERVO const servo, uint32_t const duration_us);
};

/* PROTOTYPES */

/**
 * @brief the servo task
 */
[[combinable]]
void servo_task(server interface servo_control_interface sci);


#endif /* SERVO_H_ */
