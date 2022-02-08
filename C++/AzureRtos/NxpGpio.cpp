/**
 * @file
 * @ingroup rtcontroller_inputoutput
 *
 * @brief RT Controller Gpio Controller
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

#include "NxpGpio.hpp"

/**
 * @brief Class generic constructor
 * @details Generic constructor for the NxpGpio class
 * @attention Not intended to be called directly.
 * @since v00.00.01
 **/
NxpGpio::NxpGpio( void)
{
}

/**
 * @brief Class generic deconstructor
 * @details Generic deconstructor for the NxpGpio class
 * @attention Not intended to be called directly.
 * @since v00.00.01
 **/
NxpGpio::~NxpGpio( void)
{
}

/**
 * @brief GPIO Initialization
 * @details GPIO initialization function that setups a GPIO on the RT1060
 * @since v00.00.01
 *
 * @param[ in,out] gpio_ptr Pointer to GPIO registers\n
 *   ( GPIO_Type *) Valid pointer to GPIO base register; Range GPIO1 thru GPIO9
 * @param[ in] port_pin_number GPIO pin number specific to the port\n
 *   ( uint32_t) Pin number
 * @param[ in] dir Pin direction\n
 *   ( NxpGpio::DIRECTION) NxpGpio::DIRECTION::INPUT or NxpGpio::DIRECTION::OUTPUT
 * @param[ in] default_value Pin default value after initialization\n
 *   ( BIT) BIT::LOW or BIT::HIGH; Default BIT::LOW.
 * @param[ in] int_mode Pin interrupt setting\n
 *   ( NxpGpio::INTERRUPT_MODE) Interrupt setting; Default NxpGpio::INTERRUPT_MODE::GENERAL_IO
 *
 * @exception NxpGpio::ERRORS::UNKNOWN_DIRECTION Pin direction is unknown.
 *   Exception Derived from _getDirection( NxpGpio::DIRECTION)
 **/
void NxpGpio::initGpio(
    GPIO_Type * gpio_ptr,
    uint32_t port_pin_number,
    NxpGpio::DIRECTION dir,
    BIT default_value,
    NxpGpio::INTERRUPT_MODE int_mode)
{

  _base_ptr = gpio_ptr;
  _port_pin_number = port_pin_number;

  // Throws NxpGpio::ERRORS::UNKNOWN_DIRECTION
  _config.direction = _getDirection( dir);

  if( default_value == BIT::LOW)
  {
    _config.outputLogic = 0;
  }
  else
  {
    _config.outputLogic = 1;
  }

  _config.interruptMode = _getInterruptMode( int_mode);

  GPIO_PinInit( _base_ptr, _port_pin_number, &_config);
}

/**
 * @brief Get the GPIO Port Pin Number
 * @details Get the GPIO port pin number assigned to the GPIO
 * @since v00.00.01
 *
 * @return <tt>uint32_t</tt> GPIO Port Pin Number
 **/
uint32_t NxpGpio::getGpioNumber(
    void)
{
  return( _port_pin_number);
}

/**
 * @brief Confirm GPIO Direction is an Input
 * @details Check if the GPIO is setup as an input and return true if it is an input
 * @since v00.00.01
 *
 * @return <tt>bool</tt> GPIO Direction\n
 *   - true: GPIO is an Input\n
 *   - false: GPIO is Not an Input
 **/
bool NxpGpio::isInput(
    void)
{
  if( _config.direction == _gpio_pin_direction::kGPIO_DigitalInput)
  {
    return( true);
  }
  else
  {
    return( false);
  }
}

/**
 * @brief Confirm GPIO Direction is an Output
 * @details Check if the GPIO is setup as an output and return true if it is an output
 * @since v00.00.01
 *
 * @return <tt>bool</tt> GPIO Direction\n
 *   - true: GPIO is an Output\n
 *   - false: GPIO is Not an Output
 **/
bool NxpGpio::isOutput(
    void)
{
  if( _config.direction == _gpio_pin_direction::kGPIO_DigitalOutput)
  {
    return( true);
  }
  else
  {
    return( false);
  }
}

/**
 * @brief Set the GPIO Direction
 * @details Changes the GPIO direction to the provided direction
 * @since v00.00.01
 *
 * @param[ in] dir Pin direction\n
 *   ( NxpGpio::DIRECTION) NxpGpio::DIRECTION::INPUT or NxpGpio::DIRECTION::OUTPUT
 *
 * @exception NxpGpio::ERRORS::UNKNOWN_DIRECTION Pin direction is unknown.
 *   Exception Derived from getDirection() and _getInterruptMode( NxpGpio::DIRECTION)
 **/
void NxpGpio::setDirection(
    NxpGpio::DIRECTION dir)
{
  try
  {
    if( dir != getDirection())
    {
      _config.direction = _getDirection( dir);
      GPIO_PinInit( _base_ptr, _port_pin_number, &_config);
    }
  }
  catch( NxpGpio::ERRORS exception)
  {
    throw;
  }
}

/**
 * @brief Get the GPIO Direction by calling _getDirection( _gpio_pin_direction)
 * @details Get the GPIO direction assigned to the GPIO
 * @since v00.00.01
 *
 * @exception NxpGpio::ERRORS::UNKNOWN_DIRECTION Pin direction is unknown.
 *   Exception Derived from _getDirection( NxpGpio::DIRECTION)
 *
 * @return <tt>NxpGpio::DIRECTION</tt> GPIO Direction
 **/
NxpGpio::DIRECTION NxpGpio::getDirection(
    void)
{
  try
  {
    // Throws NxpGpio::ERRORS::UNKNOWN_DIRECTION
    return( _getDirection( _config.direction));
  }
  catch( NxpGpio::ERRORS exception)
  {
    throw;
  }
}

/**
 * @brief Get the current GPIO HIGH/LOW Value by calling _getValue()
 * @details Return the current value of the GPIO class.
 *   - For an @b input, the returned value is the value as seen by the input pin.
 *   - For an @b output, the returned value is the output value being produced by the pin.
 *
 * @since v00.00.01
 *
 * @return <tt>BIT</tt> GPIO Value
 **/
BIT NxpGpio::getValue(
    void)
{
  return( _getValue());
}

/**
 * @brief Confirm the GPIO Value is BIT::LOW
 * @details Check if the GPIO is BIT::LOW and return true if it is BIT::LOW
 *   - For an @b input, the compared value is the value as seen by the input pin.
 *   - For an @b output, the compared value is the output value being produced by the pin.
 *
 * @since v00.00.01
 *
 * @return <tt>bool</tt> GPIO is BIT::LOW\n
 *   - true: GPIO is BIT::LOW\n
 *   - false: GPIO is Not BIT::LOW
 **/
bool NxpGpio::isLow(
    void)
{
  if( getValue() == BIT::LOW)
  {
    return( true);
  }
  else
  {
    return( false);
  }
}

/**
 * @brief Confirm the GPIO Value is BIT::HIGH
 * @details Check if the GPIO is BIT::HIGH and return true if it is BIT::HIGH
 * - For an @b input, the compared value is the value as seen by the input pin.
 * - For an @b output, the compared value is the output value being produced by the pin.
 *
 * @since v00.00.01
 *
 * @return <tt>bool</tt> GPIO is BIT::HIGH\n
 *   - true: GPIO is BIT::HIGH\n
 *   - false: GPIO is Not BIT::HIGH
 **/
bool NxpGpio::isHigh(
    void)
{
  if( getValue() == BIT::HIGH)
  {
    return( true);
  }
  else
  {
    return( false);
  }
}

/**
 * @brief Set the GPIO Output Value to a Specified Value by calling isOutput()
 * @details After confirming that the GPIO is an output, set the output value to the
 *   desired output value
 * @since v00.00.01
 *
 * @exception NxpGpio::ERRORS::PIN_DIRECTION_CONFLICT Pin is setup as an input.
 *
 * @param[ in] value Pin output value\n
 *   ( BIT) BIT::HIGH or BIT::LOW
 *
 * @todo Add log message before exception
 **/
void NxpGpio::setValue(
    BIT value)
{
  if( !isOutput())
  {
    throw NxpGpio::ERRORS::PIN_DIRECTION_CONFLICT;
  }

  _setOutputValue( value);
}

/**
 * @brief Set the GPIO Output Value to BIT::LOW
 * @details After confirming that the GPIO is an output, set the output value
 *   to BIT::LOW
 * @since v00.00.01
 *
 * @exception NxpGpio::ERRORS::PIN_DIRECTION_CONFLICT Pin is setup as an input.
 *   Exception Derived from setValue( BIT).
 **/
void NxpGpio::setLow(
    void)
{
  try
  {
    // Throws NxpGpio::ERRORS::PIN_DIRECTION_CONFLICT
    setValue( BIT::LOW);
  }
  catch( NxpGpio::ERRORS exception)
  {
    throw;
  }
}

/**
 * @brief Set the GPIO Output Value to BIT::HIGH
 * @details After confirming that the GPIO is an output, set the output value
 *   to BIT::HIGH
 * @since v00.00.01
 *
 * @exception NxpGpio::ERRORS::PIN_DIRECTION_CONFLICT Pin is setup as an input.
 *   Exception Derived from setValue( BIT).
 **/
void NxpGpio::setHigh(
    void)
{
  try
  {
    // Throws NxpGpio::ERRORS::PIN_DIRECTION_CONFLICT
    setValue( BIT::HIGH);
  }
  catch( NxpGpio::ERRORS exception)
  {
    throw;
  }
}

/**
 * @brief Toggle the GPIO Output Value
 * @details After confirming that the GPIO is an output, toggle the current
 *   output.  If the output is currently set as BIT::LOW, the output will be
 *   changed to BIT::HIGH.  If the output is currently set as BIT::HIGH, the
 *   output will be changed to BIT::LOW.
 * @since v00.00.01
 *
 * @exception NxpGpio::ERRORS::PIN_DIRECTION_CONFLICT Pin is setup as an input.
 *   Exception Derived from isLow() and setValue( BIT).
 **/
void NxpGpio::toggleValue(
    void)
{

  try
  {
    // Throws NxpGpio::ERRORS::PIN_DIRECTION_CONFLICT
    if( isLow())
    {
      // Throws NxpGpio::ERRORS::PIN_DIRECTION_CONFLICT
      setHigh();
    }
    else
    {
      // Throws NxpGpio::ERRORS::PIN_DIRECTION_CONFLICT
      setLow();
    }
  }
  catch( NxpGpio::ERRORS exception)
  {
    throw;
  }

}

/**
 * @brief Get the current GPIO HIGH/LOW Value
 * @details Return the current value of the GPIO class.
 *   - For an @b input, the returned value is the value as seen by the input pin.
 *   - For an @b output, the returned value is the output value being produced by the pin.
 *
 * @since v00.00.01
 *
 * @return <tt>BIT</tt> GPIO Value
 **/
BIT NxpGpio::_getValue(
    void)
{
  uint32_t current_state = GPIO_PinRead( _base_ptr, _port_pin_number);

  if( current_state == 0)
  {
    return( BIT::LOW);
  }
  else
  {
    return( BIT::HIGH);
  }
}

/**
 * @brief Set the GPIO Output Value to a Specified Value
 * @details After confirming that the GPIO is an output, set the output value to the
 *   desired output value
 * @since v00.00.01
 *
 * @exception NxpGpio::ERRORS::PIN_DIRECTION_CONFLICT Pin is setup as an input.
 *
 * @param[ in] value Pin output value\n
 *   ( BIT) BIT::HIGH or BIT::LOW
 **/
void NxpGpio::_setOutputValue(
    BIT value)
{
  if( value == BIT::LOW)
  {
    GPIO_PinWrite( _base_ptr, _port_pin_number, 0);
  }
  else
  {
    GPIO_PinWrite( _base_ptr, _port_pin_number, 1);
  }
}

/**
 * @brief Get the GPIO Direction
 * @details Get the GPIO direction assigned to the GPIO
 * @since v00.00.01
 *
 * @param[ in] dir Pin direction\n
 *   ( _gpio_pin_direction) _gpio_pin_direction::kGPIO_DigitalInput or
 *   _gpio_pin_direction::kGPIO_DigitalOutput
 *
 * @return <tt>NxpGpio::DIRECTION</tt> GPIO Direction
 *
 * @exception NxpGpio::ERRORS::UNKNOWN_DIRECTION Pin direction is unknown.
 *
 * @todo Add log message before exception
 **/
NxpGpio::DIRECTION NxpGpio::_getDirection(
    _gpio_pin_direction dir)
{
  switch( dir)
  {
    case _gpio_pin_direction::kGPIO_DigitalInput:
      return( NxpGpio::DIRECTION::INPUT);
      break;
    case _gpio_pin_direction::kGPIO_DigitalOutput:
      return( NxpGpio::DIRECTION::OUTPUT);
      break;
    default:
      throw NxpGpio::ERRORS::UNKNOWN_DIRECTION;
      break;
  }
}

/**
 * @brief Get the GPIO Direction
 * @details Get the GPIO direction assigned to the GPIO
 * @since v00.00.01
 *
 * @param[ in] dir Pin direction\n
 *   ( NxpGpio::DIRECTION) NxpGpio::DIRECTION::INPUT or NxpGpio::DIRECTION::OUTPUT
 *
 * @return <tt>NxpGpio::DIRECTION</tt> GPIO Direction
 *
 * @exception NxpGpio::ERRORS::UNKNOWN_DIRECTION Pin direction is unknown.
 *
 * @todo Add log message before exception
 **/
_gpio_pin_direction NxpGpio::_getDirection(
    NxpGpio::DIRECTION dir)
{
  switch( dir)
  {
    case NxpGpio::DIRECTION::INPUT:
      return( _gpio_pin_direction::kGPIO_DigitalInput);
      break;
    case NxpGpio::DIRECTION::OUTPUT:
      return( _gpio_pin_direction::kGPIO_DigitalOutput);
      break;
    default:
      throw NxpGpio::ERRORS::UNKNOWN_DIRECTION;
      break;
  }
}

/**
 * @brief Get the GPIO Interrupt Mode
 * @details Get the GPIO interrupt mode assigned to the GPIO.  Converts the interrupt
 *   mode from gpio_interrupt_mode_t to NxpGpio::INTERRUPT_MODE
 * @since v00.00.01
 *
 * @param[ in] int_mode Interrupt mode\n
 *   ( gpio_interrupt_mode_t) kGPIO_NoIntmode, kGPIO_IntLowLevel, kGPIO_IntHighLevel,
 *   kGPIO_IntRisingEdge, kGPIO_IntFallingEdge, or kGPIO_IntRisingOrFallingEdge
 *
 * @return <tt>NxpGpio::INTERRUPT_MODE</tt> Interrupt mode
 *
 * @exception NxpGpio::ERRORS::UNKNOWN_INTERRUPT_MODE Pin interrupt mode is unknown.
 *
 * @todo Add log message before exception
 **/
NxpGpio::INTERRUPT_MODE NxpGpio::_getInterruptMode(
    gpio_interrupt_mode_t int_mode)
{
  switch( int_mode)
  {
    case gpio_interrupt_mode_t::kGPIO_NoIntmode:
      return( NxpGpio::INTERRUPT_MODE::GENERAL_IO);
      break;
    case gpio_interrupt_mode_t::kGPIO_IntLowLevel:
      return( NxpGpio::INTERRUPT_MODE::INTERRUPT_LOW);
      break;
    case gpio_interrupt_mode_t::kGPIO_IntHighLevel:
      return( NxpGpio::INTERRUPT_MODE::INTERRUPT_HIGH);
      break;
    case gpio_interrupt_mode_t::kGPIO_IntRisingEdge:
      return( NxpGpio::INTERRUPT_MODE::INTERRUPT_RISING_EDGE);
      break;
    case gpio_interrupt_mode_t::kGPIO_IntFallingEdge:
      return( NxpGpio::INTERRUPT_MODE::INTERRUPT_FALLING_EDGE);
      break;
    case gpio_interrupt_mode_t::kGPIO_IntRisingOrFallingEdge:
      return( NxpGpio::INTERRUPT_MODE::INTERRUPT_RISING_OR_FALLING_EDGE);
      break;
    default:
      throw NxpGpio::ERRORS::UNKNOWN_INTERRUPT_MODE;
      break;
  }
}

/**
 * @brief Get the GPIO Interrupt Mode
 * @details Get the GPIO interrupt mode assigned to the GPIO.  Converts the interrupt
 *   mode from NxpGpio::INTERRUPT_MODE to gpio_interrupt_mode_t
 * @since v00.00.01
 *
 * @param[ in] int_mode Interrupt mode\n
 *   ( NxpGpio::INTERRUPT_MODE) NxpGpio::INTERRUPT_MODE::GENERAL_IO,
 *   NxpGpio::INTERRUPT_MODE::INTERRUPT_LOW, NxpGpio::INTERRUPT_MODE::INTERRUPT_HIGH,
 *   NxpGpio::INTERRUPT_MODE::INTERRUPT_RISING_EDGE,
 *   NxpGpio::INTERRUPT_MODE::INTERRUPT_FALLING_EDGE, or
 *   NxpGpio::INTERRUPT_MODE::INTERRUPT_RISING_OR_FALLING_EDGE
 *
 * @return <tt>gpio_interrupt_mode_t</tt> Interrupt mode
 *
 * @exception NxpGpio::ERRORS::UNKNOWN_INTERRUPT_MODE Pin interrupt mode is unknown.
 *
 * @todo Add log message before exception
 **/
gpio_interrupt_mode_t NxpGpio::_getInterruptMode(
    NxpGpio::INTERRUPT_MODE int_mode)
{
  switch( int_mode)
  {
    case NxpGpio::INTERRUPT_MODE::GENERAL_IO:
      return( gpio_interrupt_mode_t::kGPIO_NoIntmode);
      break;
    case NxpGpio::INTERRUPT_MODE::INTERRUPT_LOW:
      return( gpio_interrupt_mode_t::kGPIO_IntLowLevel);
      break;
    case NxpGpio::INTERRUPT_MODE::INTERRUPT_HIGH:
      return( gpio_interrupt_mode_t::kGPIO_IntHighLevel);
      break;
    case NxpGpio::INTERRUPT_MODE::INTERRUPT_RISING_EDGE:
      return( gpio_interrupt_mode_t::kGPIO_IntRisingEdge);
      break;
    case NxpGpio::INTERRUPT_MODE::INTERRUPT_FALLING_EDGE:
      return( gpio_interrupt_mode_t::kGPIO_IntFallingEdge);
      break;
    case NxpGpio::INTERRUPT_MODE::INTERRUPT_RISING_OR_FALLING_EDGE:
      return( gpio_interrupt_mode_t::kGPIO_IntRisingOrFallingEdge);
      break;
    default:
      throw NxpGpio::ERRORS::UNKNOWN_INTERRUPT_MODE;
      break;
  }
}

