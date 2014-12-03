/**
 * @author Alexander Entinger, MSc / LXRobotics
 * @brief module for controlling three rc servos using a single core
 * @file servo.xc
 * @license CC BY-NC-SA 4.0 ( http://creativecommons.org/licenses/by-nc-sa/4.0/ )
 */

#include "servo.h"
#include <platform.h>
#include <xs1.h>
#include <timer.h>

/* SERVO OUTPUT PORTS */
out port servo_1 = XS1_PORT_1F;
/*out port servo_2 = XS1_PORT_1H;
out port servo_3 = XS1_PORT_1A;*/

/* CONSTANTS */
static uint32_t const SERVO_REFRESH_PERIOD = 20000 * MICROSECOND;
static uint32_t const SERVO_NEUTRAL_POSITION = 1513 * MICROSECOND;

/* TYPEDEFS */
typedef enum {PIN_LOW = 0, PIN_HIGH = 1} E_SERVO_STATE;
typedef struct
{
    uint32_t pulse_duration_us[3];
} s_servo_config_data;

/* INTERFACES */
interface single_servo_control_interface
{
    void set_pulse_duration_us(uint32_t const pulse_duration_us);
};

/* GLOBAL DATA */
static s_servo_config_data m_servo_config_data;

/* FUNCTIONS */

[[combinable]]
void servo_1_task(server interface single_servo_control_interface ssci)
{
    timer tmr;
    uint32_t time;
    E_SERVO_STATE state = PIN_LOW;

    tmr :> time;

    while (1) {
        select
        {
            case ssci.set_pulse_duration_us(uint32_t const duration_us):
            m_servo_config_data.pulse_duration_us[SERVO_1] = duration_us * MICROSECOND;
            break;

            case tmr when timerafter(time) :> void:
            switch(state)
            {
            case PIN_LOW:
            {
                time += m_servo_config_data.pulse_duration_us[SERVO_1];
                servo_1 <: 1;
                state = PIN_HIGH;
            }
            break;
            case PIN_HIGH:
            {
                time += SERVO_REFRESH_PERIOD;
                servo_1 <: 0;
                state = PIN_LOW;
            }
            break;
            }
            break;
        }
    }
}

/*[[combinable]]
void servo_2_task(server interface single_servo_control_interface ssci)
{
    timer tmr;
    uint32_t time;
    E_SERVO_STATE state = PIN_LOW;

    tmr :> time;

    while (1) {
        select
        {
            case ssci.set_pulse_duration_us(uint32_t const duration_us):
            m_servo_config_data.pulse_duration_us[SERVO_2] = duration_us * MICROSECOND;
            break;

            case tmr when timerafter(time) :> void:
            switch(state)
            {
            case PIN_LOW:
            {
                time += m_servo_config_data.pulse_duration_us[SERVO_2];
                servo_2 <: 1;
                state = PIN_HIGH;
            }
            break;
            case PIN_HIGH:
            {
                time += SERVO_REFRESH_PERIOD;
                servo_2 <: 0;
                state = PIN_LOW;
            }
            break;
            }
            break;
        }
    }
}

[[combinable]]
void servo_3_task(server interface single_servo_control_interface ssci)
{
    timer tmr;
    uint32_t time;
    E_SERVO_STATE state = PIN_LOW;

    tmr :> time;

    while (1) {
        select
        {
            case ssci.set_pulse_duration_us(uint32_t const duration_us):
            m_servo_config_data.pulse_duration_us[SERVO_3] = duration_us * MICROSECOND;
            break;

            case tmr when timerafter(time) :> void:
            switch(state)
            {
            case PIN_LOW:
            {
                time += m_servo_config_data.pulse_duration_us[SERVO_3];
                servo_3 <: 1;
                state = PIN_HIGH;
            }
            break;
            case PIN_HIGH:
            {
                time += SERVO_REFRESH_PERIOD;
                servo_3 <: 0;
                state = PIN_LOW;
            }
            break;
            }
            break;
        }
    }
}*/

[[combinable]]
void servo_instruction_task(
        server interface servo_control_interface sci,
        client interface single_servo_control_interface ssci_servo_1,
        client interface single_servo_control_interface ssci_servo_2,
        client interface single_servo_control_interface ssci_servo_3)
{
    while(1)
    {
        select
        {
            case sci.set_pulse_duration_us(E_SERVO const servo, uint32_t const duration_us):
            switch(servo)
            {
            case SERVO_1: ssci_servo_1.set_pulse_duration_us(duration_us); break;
            /*case SERVO_2: ssci_servo_2.set_pulse_duration_us(duration_us); break;
            case SERVO_3: ssci_servo_3.set_pulse_duration_us(duration_us); break;*/
            }
            break;
        }
    }
}

/**
 * @brief the servo task
 */
[[combinable]]
void servo_task(server interface servo_control_interface sci)
{
    m_servo_config_data.pulse_duration_us[SERVO_1] = SERVO_NEUTRAL_POSITION;
    /*m_servo_config_data.pulse_duration_us[SERVO_2] = SERVO_NEUTRAL_POSITION;
    m_servo_config_data.pulse_duration_us[SERVO_3] = SERVO_NEUTRAL_POSITION;*/

    interface single_servo_control_interface ssci_servo_1, ssci_servo_2, ssci_servo_3;

    [[combine]]
    par
    {
        servo_1_task(ssci_servo_1);
        /*servo_2_task(ssci_servo_2);
        servo_3_task(ssci_servo_3);*/
        servo_instruction_task(sci,ssci_servo_1,ssci_servo_2,ssci_servo_3);
    }

}
