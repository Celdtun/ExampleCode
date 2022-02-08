/**
 * @file
 * @ingroup rtcontroller_inputoutput
 *
 * @brief RT Controller Gpio Controller Prototypes
 * @details Generic GPIO Controller that enables the RT Controller system
 *   to implement GPIOs.
 * 
 * @attention Use the RtController_NxpGpioController class if GPIOs are to
 *   be used in a RTOS system
 *
 * @version **v00.00.01**: Initial Release ( day_month_year)\n
 * @todo Update Version Release Date
 *
 * @details
 *   **Tools**
 *   - SDK: NXP MCUXpresso SDK v2.10.0 (494 2021-7-15) [3.8.0]
 *   - IDE Tool: NXP MCUXpresso IDE v11.3.1 [Build 5262] [2021-04-02]
 *   - Compiler: NXP MCUXpresso IDE v11.3.1 [Build 5262] [2021-04-02]
 *   - Language: Standard C++
 *   .
 *
 * @author C.Graham
 * @date 21 August 2020
 *
 * @bug No Known Bugs
 **/

#ifndef __NxpGpio_included_
#define __NxpGpio_included_

#include <fsl_gpio.h>
#include <stdint.h>

#include "RtControllerEnumerations.hpp"

/**
 * @class NxpGpio NxpGpio.hpp "source/CommonLibrary/NxpGpio.hpp"
 * @brief General Input/Output Controller for RT1060 Family
 * @since v00.00.01
 **/
class NxpGpio
{

  /**
   * @publicsection
   **/
  public:
    //*************************************************************************
    // Public Variables
    //*************************************************************************

    /**
     * @enum ERRORS
     * @brief Enumeration for the different types of errors used in the NxpGpio class.
     * @since v00.00.01
     **/
    enum class ERRORS : uint8_t
    {
      NO_ERRORS, /*!< No error returned */
      PIN_DIRECTION_CONFLICT, /*!< Conflict setting the pin direction */
      UNKNOWN_DIRECTION, /*!< Unspecified direction for the GPIO */
      UNKNOWN_INTERRUPT_MODE /*!< Unspecified interrupt mode for the GPIO */
    };

    /**
     * @enum DIRECTION
     * @brief Enumeration for the GPIO direction
     * @since v00.00.01
     **/
    enum class DIRECTION : uint8_t
    {
      INPUT, /*!< Pin Input */
      OUTPUT, /*!< Pin Output */
      BIDIRECTIONAL /*!< Pin Input/Output */
    };

    /**
     * @enum INTERRUPT_MODE
     * @brief Enumeration for the different types of GPIO interrupts
     * @since v00.00.01
     **/
    enum class INTERRUPT_MODE : uint8_t
    {
      GENERAL_IO, /*!< Non-Interrupt Mode */
      INTERRUPT_LOW, /*!< Interrupt when GPIO is LOW */
      INTERRUPT_HIGH, /*!< Interrupt when GPIO is HIGH */
      INTERRUPT_RISING_EDGE, /*!< Interrupt on the rising edge of the GPIO */
      INTERRUPT_FALLING_EDGE, /*!< Interrupt on the falling edge of the GPIO */
      INTERRUPT_RISING_OR_FALLING_EDGE /*!< Interrupt on either the rising edge or falling edge of the GPIO */
    };

    //*************************************************************************
    // Public Functions/Methods
    //*************************************************************************

    // Generic Constructor
    NxpGpio( void);
    // Generic Destructor
    virtual ~NxpGpio( void);

    void initGpio(
        GPIO_Type * gpio_ptr,
        uint32_t port_pin_number,
        NxpGpio::DIRECTION dir,
        BIT default_value =
            BIT::LOW,
        NxpGpio::INTERRUPT_MODE int_mode =
            NxpGpio::INTERRUPT_MODE::GENERAL_IO);

    uint32_t getGpioNumber(
        void);

    bool isInput(
        void);
    bool isOutput(
        void);
    void setDirection(
        NxpGpio::DIRECTION dir);
    NxpGpio::DIRECTION getDirection(
        void);

    BIT getValue(
        void);
    bool isLow(
        void);
    bool isHigh(
        void);
    void setValue(
        BIT value);
    void setLow(
        void);
    void setHigh(
        void);
    void toggleValue(
        void);

  /**
   * @protectedsection
   **/
  protected:
    //*************************************************************************
    // Protected Variables
    //*************************************************************************

    //*************************************************************************
    // Protected Functions/Methods
    //*************************************************************************

  /**
   * @privatesection
   **/
  private:
    //*************************************************************************
    // Private Variables
    //*************************************************************************
    /**
     * @brief Pin configuration container
     * @since v00.00.01
     **/
    gpio_pin_config_t _config;
    /**
     * @brief Pin GPIO type container
     * @since v00.00.01
     **/
    GPIO_Type * _base_ptr;
    /**
     * @brief Pin port number
     * @since v00.00.01
     **/
    uint32_t _port_pin_number;

    //*************************************************************************
    // Private Functions/Methods
    //*************************************************************************

    BIT _getValue(
        void);
    void _setOutputValue(
        BIT value);

    NxpGpio::DIRECTION _getDirection(
        _gpio_pin_direction dir);
    _gpio_pin_direction _getDirection(
        NxpGpio::DIRECTION dir);

    NxpGpio::INTERRUPT_MODE _getInterruptMode(
        gpio_interrupt_mode_t int_mode);
    gpio_interrupt_mode_t _getInterruptMode(
        NxpGpio::INTERRUPT_MODE int_mode);

};

#endif // __NxpGpio_included_
