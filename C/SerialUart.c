/*******************************************************************************
//  Program:  None - Common Library
//  Project:  None - Common Library
//
//  Author:   Chad Graham
//  Date:     March 06, 2018
//
//  IDE Tool: MPLAB X IDE v4.15
//  Compiler: MPLAB XC8 v1.45
//  Language: Standard C
//
//  Hardware Platform:
//    N/A - Common Library with Common Names
//
/*******************************************************************************
//
//  Class:        SerialUart
//
//  Derived From: N/A
//
//  Description:
//    Generic Serial UART Library.  Contains all functions required to
//    set communicate to an external device using a Serial UART interface.
//
/*******************************************************************************
//
//  Revision History:
//
//  Rev 0:
//    Initial Code Release
//
*******************************************************************************/

/*******************************************************************************
//
//  Serial UART Support Expectations:
//    __SERIAL_UART_BUFFER_DEPTH_ is Reasonable deep and defined as a
//        compiler definition
//    UART Pins are Already Setup as UART Pins
//    SerialUartDefinitions Supports the Desired PIC
//      Note - See SerialUartDefinitions.h for Details
//    Before Using the Serial Ports, buffers will be initialized by calling
//        SerialUart_InitilizeBuffers()
//    Ports are 0x01 and 0x02
//      Note - If a port is not setup, it is not used as a serialChannel
//    All Transmit Calls are SerialUart_TransmitXXXX()
//    All transmit and receive commands utilize a true/false return that
//        should be tested whenever a function is called
//      True - The command was successful
//      False - Something didn't work and it is up to the program to
 //         determine what didn't work and how to react to is
//    If Interrupts are Not Used, all serialWait commands must be false
//    If Interrupts are Used, all Interrupts are Already Setup
//    If Interrupts are Used, the RX Service Routine is Handled Externally
//      Routine Must:
//        - Handle all Interrupt Flags
//        - Set a Flag to Call SerialUart_SendCharacter() in a Later Routine
//        - Save the Received Character to be Added to the RX Buffer Later
//    Buffer over-runs have been reasonable prevented and will force wait
//        until the buffer has room if an over-run occurs
//
*******************************************************************************/

/*******************************************************************************
//
//  Serial UART Integration Instructions:
//    1 ) Define __SERIAL_UART_BUFFER_DEPTH_
//    2 ) Setup Serial UART Pins
//    3 ) Call SerialUart_InitilizeBuffers() to initialize the serial buffers
//    4 ) Call SerialUart_SetBaudRate() to set the baud rate for each port
//    5 ) Set any Additional Registers Required to Support the Serial UARTs
//    6 ) If Interrupts are to be Used, Add Interrupt Flag
//    7 ) If Interrupts are to be Used, Add Service Routines to Respond to
//        Interrupt Flags
//    8 ) Turn on the Serial UART Receivers
//
*******************************************************************************/

// Serial UART Communication Control
#include "SerialUart.h"

#ifdef __SERIAL_UART_PORT_1_ENABLE_
  // Serial UART Port 1 TX Buffer
  static unsigned char SerialUart_TxBuffer_1[__SERIAL_UART_BUFFER_DEPTH_ + 1];
  // Serial UART Port 1 RX Buffer
  static unsigned char SerialUart_RxBuffer_1[__SERIAL_UART_BUFFER_DEPTH_ + 1];
  
  // Constant Pointer to the Top of the TX 1 Buffer
  unsigned char *SerialUart_TxBufferTop_1 = &SerialUart_TxBuffer_1[0];
  // Working Pointer for Serial UART Port 1 TX Buffer
  unsigned char *SerialUart_TxBufferPointer_1;
  // Constant Pointer to the Top of the RX 1 Buffer
  unsigned char *SerialUart_RxBufferTop_1 = &SerialUart_RxBuffer_1[0];
  // Working Pointer for Serial UART Port 1 RX Buffer
  unsigned char *SerialUart_RxBufferPointer_1;
  
  // Serial UART Port 1 Echo Enable
  //   true == Echo all received characters back to source
  //   false == Do not echo any characters
  bool SerialUart_EnableEcho_1;
#endif // #ifdef__SERIAL_UART_PORT_1_ENABLE_

// Only provision these if the PIC supports a second UART port
#if __SERIAL_UART_CHANNELS_ == 2 && defined(__SERIAL_UART_PORT_2_ENABLE_)
  // Serial UART Port 2 TX Buffer
  static unsigned char SerialUart_TxBuffer_2[__SERIAL_UART_BUFFER_DEPTH_];
  // Serial UART Port 2 RX Buffer
  static unsigned char SerialUart_RxBuffer_2[__SERIAL_UART_BUFFER_DEPTH_];

  // Constant Pointer to the Top of the TX 2 Buffer
  unsigned char *SerialUart_TxBufferTop_2 = &SerialUart_TxBuffer_2[0];
  // Working Pointer for Serial UART Port 2 TX Buffer
  unsigned char *SerialUart_TxBufferPointer_2;
  // Constant Pointer to the Top of the RX 2 Buffer
  unsigned char *SerialUart_RxBufferTop_2 = &SerialUart_RxBuffer_2[0];
  // Working Pointer for Serial UART Port 2 RX Buffer
  unsigned char *SerialUart_RxBufferPointer_2;

  // Serial UART Port 2 Echo Enable
  //   true == Echo all received characters back to source
  //   false == Do not echo any characters
  bool SerialUart_EnableEcho_2;
#endif // #if __SERIAL_UART_CHANNELS_ == 2 && defined(__SERIAL_UART_PORT_2_ENABLE_)

// Serial UART Temporary Buffer
static unsigned char SerialUart_TempBuffer[(2 * __SERIAL_UART_BUFFER_DEPTH_) 
    + 1];
// Constant Pointer to the Top of the Temporary Buffer
unsigned char *SerialUart_TempBufferTop = &SerialUart_TempBuffer[0];
// Working Pointer for Serial UART Temporary Buffer
unsigned char *SerialUart_TempBufferPointer;

// Temporary Buffer Setup
bool SerialUart_TempBufferReady = false;

// <editor-fold defaultstate="collapsed" desc="unsigned long SerialUart_InitilizePort(unsigned char serialChannel, unsigned long systemFrequency, unsigned long baudRateTarget)">
/*******************************************************************************
//  Method: SerialUart_InitilizePort
//  Description:
//    To set all pointers to their respective buffers, flush each buffer to
//    ensure it is empty, initialize the temporary buffer if it isn't already
//    and to set the baud rate of the specified channel
//
//  Inputs:
//    unsigned char serialChannel - Serial port to modify
//    unsigned long systemFrequency - System FOSC in Hz; 32MHz would be
//        32000000
//    unsigned long baudRateTarget - Desired serial UART baud rate in bits
//        per second; 115.2kbps would be 115200
//
//  Outputs:
//    None
//
//  Returns:
//    Actual calculated baud rate with the lowest error.  If it is not
//    possible to achieve the desired baud rate given the system frequency,
//    then 0xFFFFFFFF will be returned in place of the calculated baud rate.
//
//  Global Variable Usage:
//    SerialUart_EnableEcho_1 - Setting for Serial UART 1 Echo; Will be set
//        true to enable echos
//    SerialUart_TxBufferPointer_1 - Working Pointer for Serial UART 1 
//        TX Buffer; Will be set to point to buffer top
//    SerialUart_TxBuffer_1 - Serial UART 1 TX Buffer; Will be flushed
//    SerialUart_RxBufferPointer_1 - Working Pointer for Serial UART 1 
//        RX Buffer; Will be set to point to buffer top
//    SerialUart_RxBuffer_1 - Serial UART 1 RX Buffer; Will be flushed
//    SerialUart_TempBufferPointer - Working Pointer for Temporary Buffer; 
//        Will be set to point to buffer top
//    SerialUart_TempBuffer - Temporary Buffer; Will be flushed
//    SerialUart_EnableEcho_2 - Setting for Serial UART 2 Echo; Will be set
//        true to enable echos
//    SerialUart_TxBufferPointer_2 - Working Pointer for Serial UART 2 
//        TX Buffer; Will be set to point to buffer top
//    SerialUart_TxBuffer_2 - Serial UART 2 TX Buffer; Will be flushed
//    SerialUart_RxBufferPointer_2 - Working Pointer for Serial UART 2 
//        RX Buffer; Will be set to point to buffer top
//    SerialUart_RxBuffer_2 - Serial UART 2 RX Buffer; Will be flushed
//
//  Local Variable Usage:
//    None
//
//  Exceptions:
//    None
//
*******************************************************************************/
unsigned long SerialUart_InitilizePort(unsigned char serialChannel, 
    unsigned long systemFrequency, unsigned long baudRateTarget) {

  #ifdef __SERIAL_UART_PORT_1_ENABLE_
    if(serialChannel == 1) {
      // Set Serial UART 1 to Echo by Default
      SerialUart_EnableEcho_1 = true;

      // Point Serial UART 1 TX Pointer to the Top of the Tx 1 Buffer
      SerialUart_TxBufferPointer_1 = &SerialUart_TxBuffer_1[0];
      // Point Serial UART 1 RX Pointer to the Top of the Rx 1 Buffer
      SerialUart_RxBufferPointer_1 = &SerialUart_RxBuffer_1[0];

      // Flush the Serial UART TX 1 Buffer
      SerialUart_TxBufferPointer_1 = SerialUart_FlushBuffer(
          SerialUart_TxBufferTop_1);
      // Flush the Serial UART RX 1 Buffer
      SerialUart_RxBufferPointer_1 = SerialUart_FlushBuffer(
          SerialUart_RxBufferTop_1);
  #endif // #ifdef __SERIAL_UART_PORT_1_ENABLE_

  // If the PIC has 2 Serial Ports
  #if __SERIAL_UART_CHANNELS_ == 2 && defined(__SERIAL_UART_PORT_2_ENABLE_)
    #ifdef __SERIAL_UART_PORT_1_ENABLE_
      } else if(serialChannel == 2) {
    #else
      if(serialChannel == 2) {
    #endif // #ifdef __SERIAL_UART_PORT_1_ENABLE_
        // Set Serial UART 2 to Echo by Default
        SerialUart_EnableEcho_2 = true;

        // Point Serial UART 2 TX Pointer to the Top of the Tx 2 Buffer
        SerialUart_TxBufferPointer_2 = &SerialUart_TxBuffer_2[0];
        // Point Serial UART 2 RX Pointer to the Top of the Rx 2 Buffer
        SerialUart_RxBufferPointer_2 = &SerialUart_RxBuffer_2[0];

        // Flush the Serial UART TX 2 Buffer
        SerialUart_TxBufferPointer_2 = SerialUart_FlushBuffer(
            SerialUart_TxBufferTop_2);
        // Flush the Serial UART RX 2 Buffer
        SerialUart_RxBufferPointer_2 = SerialUart_FlushBuffer(
          SerialUart_RxBufferTop_2);
  #endif // #if __SERIAL_UART_CHANNELS_ == 2 && defined(__SERIAL_UART_PORT_2_ENABLE_)
  } else
    return(0xFFFFFFFF);

  if(SerialUart_TempBufferReady == false) {
    // Point Temp Buffer Pointer to the Top of the Temp Buffer
    SerialUart_TempBufferPointer = &SerialUart_TempBuffer[0];
  
    // Flush the Temp Buffer
    SerialUart_TempBufferPointer = SerialUart_FlushBuffer(
        SerialUart_TempBufferTop);
  }

  // Set Serial Port Baud Rate
  return(SerialUart_SetBaudRate(serialChannel, systemFrequency,
      baudRateTarget));

} // unsigned long SerialUart_InitilizePort(unsigned char serialChannel, unsigned long systemFrequency, unsigned long baudRateTarget)
// </editor-fold>
// <editor-fold defaultstate="collapsed" desc="unsigned char * SerialUart_FlushBuffer(unsigned char *bufferTop)">
/*******************************************************************************
//  Method: SerialUart_FlushBuffer
//  Description:
//    To set all pointers to their respective buffers and flush each buffer
//    to ensure it is empty
//
//  Inputs:
//    unsigned char *bufferTop - Pointer to the top of the buffer to be flushed
//
//  Outputs:
//    None
//
//  Returns:
//    unsigned char *bufferTop - Pointer to flushed buffer
//
//  Global Variable Usage:
//    None
//
//  Local Variable Usage:
//    unsigned char *bufferPointer - Working pointer to move through the buffer
//    unsigned int bufferLength - Length of the Buffer to be Flushed
//    unsigned int i - Counting variable
//
//  Exceptions:
//    None
//
*******************************************************************************/
unsigned char * SerialUart_FlushBuffer(unsigned char *bufferTop) {

  // Set working pointer to the top of the buffer
  unsigned char *bufferPointer = bufferTop;
  // Length of the Buffer to be Flushed
  unsigned int bufferLength;
  
  // Determine the Length of the buffer
  if(bufferTop == SerialUart_TempBufferTop)
    // Buffer to be Flushed is the Temporary Buffer
    bufferLength = (2 * __SERIAL_UART_BUFFER_DEPTH_);
  else
    // Buffer to be Flushed is on of the TX or RX Buffers
    bufferLength =  __SERIAL_UART_BUFFER_DEPTH_;

  // Walk buffer, setting each position to 0x00 until the buffer appears empty
  for(unsigned int i = 0; i < bufferLength; i++) {
    // Check if pointer is pointing to a null character
    if(*bufferPointer == 0x00)
      // If the character is NULL, then we must be at the end of the buffer
      i = bufferLength;
    else {
      /* If the character is not NULL, then set it to NULL and move to the
         next position
      */
      *bufferPointer = 0x00;
      bufferPointer++;
    }
  }

  // Return the pointer to the top of the buffer
  return(bufferTop);
} // unsigned char * SerialUart_FlushBuffer(unsigned char *bufferTop)
// </editor-fold>
// <editor-fold defaultstate="collapsed" desc="bool SerialUart_GetEcho(unsigned char serialChannel)">
/*******************************************************************************
//  Method: SerialUart_GetEcho
//  Description:
//    To return the boolean value of the specified serial port's echo value
//
//  Inputs:
//    unsigned char serialChannel - Serial port to check
//
//  Outputs:
//    None
//
//  Returns:
//    The SerialUart_EnableEcho_x value for the specified port
//
//  Global Variable Usage:
//    SerialUart_EnableEcho_1 - Setting for Serial UART 1 Echo
//    SerialUart_EnableEcho_2 - Setting for Serial UART 2 Echo
//
//  Local Variable Usage:
//    None
//
//  Exceptions:
//    None
//
*******************************************************************************/
bool SerialUart_GetEcho(unsigned char serialChannel) {
  
  #if __SERIAL_UART_CHANNELS_ == 2 && defined(__SERIAL_UART_PORT_2_ENABLE_)
    #ifdef __SERIAL_UART_PORT_1_ENABLE_
      /* If more than 1 channel is supported, determine which channel is
         to be returned
      */
      if(serialChannel == 2)
    #endif // #ifdef __SERIAL_UART_PORT_1_ENABLE_
      // Return channel 2's echo value
      return(SerialUart_EnableEcho_2);
  #endif // #if __SERIAL_UART_CHANNELS_ == 2 && defined(__SERIAL_UART_PORT_2_ENABLE_)

  #ifdef __SERIAL_UART_PORT_1_ENABLE_
    // Return channel 1's echo value by default
    return(SerialUart_EnableEcho_1);
  #endif // #ifdef __SERIAL_UART_PORT_1_ENABLE_
  
} // bool SerialUart_GetEcho(unsigned char serialChannel)
// </editor-fold>
// <editor-fold defaultstate="collapsed" desc="bool SerialUart_SetEcho(unsigned char serialChannel, bool enableEcho)">
/*******************************************************************************
//  Method: SerialUart_SetEcho
//  Description:
//    To set the boolean value of the specified serial port's echo value
//
//  Inputs:
//    unsigned char serialChannel - Serial port to check
//    bool enableEcho - New echo value
//
//  Outputs:
//    None
//
//  Returns:
//    None
//
//  Global Variable Usage:
//    SerialUart_EnableEcho_1 - Setting for Serial UART 1 Echo; Will be
//        updated if serialChannel is 0x01
//    SerialUart_EnableEcho_2 - Setting for Serial UART 2 Echo; Will be
//        updated if serialChannel is 0x02
//
//  Local Variable Usage:
//    None
//
//  Exceptions:
//    None
//
*******************************************************************************/
void SerialUart_SetEcho(unsigned char serialChannel, bool enableEcho) {
  
  #ifdef __SERIAL_UART_PORT_1_ENABLE_
    if(serialChannel == 0x01)
      // Set serial UART 1 echo value is serialChannel is 0x01
      SerialUart_EnableEcho_1 = enableEcho;
  #endif // #ifdef __SERIAL_UART_PORT_1_ENABLE_

  #if __SERIAL_UART_CHANNELS_ == 2 && defined(__SERIAL_UART_PORT_2_ENABLE_)
    #ifdef __SERIAL_UART_PORT_1_ENABLE_
      else if(serialChannel == 0x02)
    #else
        if(serialChannel == 0x02)
    #endif // #ifdef __SERIAL_UART_PORT_1_ENABLE_
        // Set serial UART 2 echo value is serialChannel is 0x02
        SerialUart_EnableEcho_2 = enableEcho;
  #endif // __SERIAL_UART_CHANNELS_ == 2 && defined(__SERIAL_UART_PORT_2_ENABLE_)
  // Do nothing if serialChannel isn't 0x01 or 0x02
} // void SerialUart_SetEcho(unsigned char serialChannel, bool enableEcho)
// </editor-fold>
// <editor-fold defaultstate="collapsed" desc="void SerialUart_WaitForTransmitToComplete(unsigned char serialChannel)">
/*******************************************************************************
//  Method: SerialUart_WaitForTransmitToComplete
//  Description:
//    To wait for the current byte to be transmitted on the specified channel
//
//  Inputs:
//    unsigned char serialChannel - Serial port to check
//
//  Outputs:
//    None
//
//  Returns:
//    None
//
//  Global Variable Usage:
//    None
//
//  Local Variable Usage:
//    None
//
//  Exceptions:
//    None
//
*******************************************************************************/
void SerialUart_WaitForTransmitToComplete(unsigned char serialChannel) {
  
  #if __SERIAL_UART_CHANNELS_ == 2 && defined(__SERIAL_UART_PORT_2_ENABLE_)
    // Determine Which Channel to Wait For
    if(serialChannel == 0x02)
      // Wait for Channel 2 to Complete
      while(__SERIAL_UART_TRANSMIT_ENABLE_2_ == 1 && 
          __SERIAL_UART_TRANSMIT_SHIFT_REGISTER_2_ == 0);
  #endif // #if __SERIAL_UART_CHANNELS_ == 2 && defined(__SERIAL_UART_PORT_2_ENABLE_)
    
  #ifdef __SERIAL_UART_PORT_1_ENABLE_
    #if __SERIAL_UART_CHANNELS_ == 2 && defined(__SERIAL_UART_PORT_2_ENABLE_)
      else
    #endif // #if __SERIAL_UART_CHANNELS_ == 2 && defined(__SERIAL_UART_PORT_2_ENABLE_)
        // Wait for Channel 1 to Complete
        while(__SERIAL_UART_TRANSMIT_ENABLE_1_ == 1 && 
            __SERIAL_UART_TRANSMIT_SHIFT_REGISTER_1_ == 0);
  #endif // #ifdef __SERIAL_UART_PORT_1_ENABLE_
} // void SerialUart_WaitForTransmitToComplete(unsigned char serialChannel)
// </editor-fold>
// <editor-fold defaultstate="collapsed" desc="bool SerialUart_TransmitString(unsigned char serialChannel, unsigned char *serialString, bool serialWait)">
/*******************************************************************************
//  Method: SerialUart_TransmitString
//  Description:
//    To add an unsigned char array (String) to the specified TX Buffer; If
//    the String is too long to fit into the Temporary Buffer, the method 
//    will return false.  If the remaining message length in the TX Buffer 
//    plus the message length is too big to fit into the Temporary Buffer, 
//    then the method will wait until there is room.  Note - The method will 
//    disable all Interrupts while adding the String to the TX Buffer
//
//  Inputs:
//    unsigned char serialChannel - Serial port to check
//    unsigned char *serialString - (unsigned char array) to add to the buffer
//    bool serialWait - If the method is to send the entire buffer before
//        returning
//
//  Outputs:
//    None
//
//  Returns:
//    True if the String was successfully added to the TX buffer
//    False if the String was not added to the TX buffer
//
//  Global Variable Usage:
//    None
//
//  Local Variable Usage:
//    unsigned char *serialMessage - Local pointer to the new message
//    unsigned int serialMessageSize - Length of the new message
//
//  Exceptions:
//    None
//
*******************************************************************************/
bool SerialUart_TransmitString(unsigned char serialChannel, unsigned char 
    *serialString, bool serialWait) {
  
  // Local pointer to the new message
  unsigned char *serialMessage = serialString;
  unsigned int serialMessageSize = strlen(serialMessage);
  unsigned int fullMessageSize = strlen(SerialUart_TxBufferPointer_1) +
      serialMessageSize;

  // Flush the Temporary Buffer
  SerialUart_TempBufferPointer = SerialUart_FlushBuffer(
      SerialUart_TempBufferTop);

  #ifdef __SERIAL_UART_PORT_1_ENABLE_
    // Determine which Channel to Transmit the Message on
    if(serialChannel == 0x01) {

      /* Determine if the Message will Fit into the TX Buffer; Extra Buffer of
         10 Characters Added to Ensure There is Space
      */
      if(fullMessageSize >= (__SERIAL_UART_BUFFER_DEPTH_ - 10)) {
        // Message Will not Fit in the TX Buffer
        for(unsigned int i = 0; i < (fullMessageSize - 
            (__SERIAL_UART_BUFFER_DEPTH_ - 10)); i++) {
          // Transmit Characters Until it will Fit
          if(SerialUart_SendCharacter(serialChannel, true) == false)
            // Something Went Wrong When Transmitting the Character
            return(false);
        }
      }

      // Disable the Transmit Interrupt 
      __SERIAL_UART_INTERRUPT_TRANSMITENABLE_1_ = 0;

      // If the TX Buffer is not Empty
      if(strlen(SerialUart_TxBufferPointer_1) != 0)
        // Copy the Unsent TX Buffer into the Temporary Buffer
        SerialUart_TempBufferTop = strcpy(SerialUart_TempBufferTop,
            SerialUart_TxBufferPointer_1);

      // Flush the TX Buffer
      SerialUart_TxBufferPointer_1 = SerialUart_FlushBuffer(
          SerialUart_TxBufferTop_1);

      // Copy the New Message into the Temporary Buffer
      SerialUart_TempBufferTop = strcat(SerialUart_TempBufferTop, serialString);

      // Determine the length of the temporary buffer message
      serialMessageSize = strlen(SerialUart_TempBufferTop);

      // Copy the Temporary Buffer into the Tx Buffer
      SerialUart_TxBufferTop_1 = strcpy(SerialUart_TxBufferTop_1,
          SerialUart_TempBufferPointer);

  #endif // #ifdef __SERIAL_UART_PORT_1_ENABLE_

  // If the PIC has 2 Serial Ports
  #if __SERIAL_UART_CHANNELS_ == 2 && defined(__SERIAL_UART_PORT_2_ENABLE_)
    #ifdef __SERIAL_UART_PORT_1_ENABLE_
      } else if(serialChannel == 2) {
    #else
      if(serialChannel == 2) {
    #endif // #ifdef __SERIAL_UART_PORT_1_ENABLE_

      /* Determine if the Message will Fit into the TX Buffer; Extra Buffer of
         10 Characters Added to Ensure There is Space
      */
      if(fullMessageSize >= (__SERIAL_UART_BUFFER_DEPTH_ - 10)) {
        // Message Will not Fit in the TX Buffer
        for(unsigned int i = 0; i < (fullMessageSize - 
            (__SERIAL_UART_BUFFER_DEPTH_ - 10)); i++) {
          // Transmit Characters Until it will Fit
          if(SerialUart_SendCharacter(serialChannel, true) == false)
            // Something Went Wrong When Transmitting the Character
            return(false);
        }
      }

      // Disable the Transmit Interrupt 
      __SERIAL_UART_INTERRUPT_TRANSMITENABLE_2_ = 0;

      // If the TX Buffer is not Empty
      if(strlen(SerialUart_TxBufferPointer_2) != 0)
        // Copy the Unsent TX Buffer into the Temporary Buffer
        SerialUart_TempBufferTop = strcpy(SerialUart_TempBufferTop,
            SerialUart_TxBufferPointer_2);

      // Flush the TX Buffer
      SerialUart_TxBufferPointer_2 = SerialUart_FlushBuffer(
          SerialUart_TxBufferTop_2);

      // Copy the New Message into the Temporary Buffer
      SerialUart_TempBufferTop = strcat(SerialUart_TempBufferTop, serialString);

      // Determine the length of the temporary buffer message
      serialMessageSize = strlen(SerialUart_TempBufferTop);

      // Copy the Temporary Buffer into the Tx Buffer
      SerialUart_TxBufferTop_2 = strcpy(SerialUart_TxBufferTop_2,
          SerialUart_TempBufferPointer);

  #endif // __SERIAL_UART_CHANNELS_ == 2 && defined(__SERIAL_UART_PORT_2_ENABLE_)
  } else
    return(false);

  // Start Sending the Buffer
  return(SerialUart_SendCharacter(serialChannel, serialWait));
} // bool SerialUart_TransmitString(unsigned char serialChannel, unsigned char *serialString, bool serialWait)
// </editor-fold>
// <editor-fold defaultstate="collapsed" desc="bool SerialUart_TransmitConstString(unsigned char serialChannel, const unsigned char *serialString, bool serialWait)">
/*******************************************************************************
//  Method: SerialUart_TransmitConstString
//  Description:
//    To convert a const unsigned char array (const String) to an unsigned
//    char array (String) and pass it on to SerialUart_TransmitString()
//
//  Inputs:
//    unsigned char serialChannel - Serial port to check
//    const unsigned char *serialString - (const unsigned char array) to add
//        to the buffer
//    bool serialWait - If the method is to send the entire buffer before
//        returning
//
//  Outputs:
//    None
//
//  Returns:
//    True if the String was successfully added to the TX buffer
//    False if the String was not added to the TX buffer
//
//  Global Variable Usage:
//    None
//
//  Local Variable Usage:
//    unsigned int messageLength - Length of the new message
//    unsigned char *serialStringPointer - Working pointer to the working
//        position of the new message
//    static unsigned char serialMessage - Temporary holding buffer for the
//        unsigned char array (String); Size is the same as the global
//        Temporary Buffer
//    unsigned char * serialMessageTop - Working pointer to the String Top
//
//  Exceptions:
//    None
//
*******************************************************************************/
bool SerialUart_TransmitConstString(unsigned char serialChannel, const
    unsigned char *serialString, bool serialWait) {
  
  // Length of the new message
  unsigned int messageLength = strlen(serialString);
  // Working pointer to the working position of the new message
  unsigned char * serialStringPointer = (unsigned char *) serialString;
  /* Temporary holding buffer for the unsigned char array (String); Size is
     the same as the global Temporary Buffer
  */
  static unsigned char serialMessage[(2 * __SERIAL_UART_BUFFER_DEPTH_) + 1];
  // Working pointer to the String Top
  unsigned char * serialMessageTop = &serialMessage[0];
  
  // Determine if the New Message Will Fit into the Temporary Buffer
  if(messageLength >= (2 * __SERIAL_UART_BUFFER_DEPTH_))
    // New Message is Too Long to Fit Into the Temporary Buffer
    return(false);

  /* Walk the const unsigned char array (const String) and copy the values
     into the unsigned char array (String))
   */
  for(unsigned int i = 0; i <= messageLength; i++) {
    // Ensure that the last character is a NUL character
    if(i == messageLength)
      // i is pointing to the last character position
      serialMessage[i] = 0x00;
    else {
      // Still more characters to copy over
      serialMessage[i] = *serialStringPointer;
      // Increment the working pointer
      serialStringPointer++;
    }
  }
  
  /* Send new unsigned char array (String) to SerialUart_TransmitString()
     and return the result
   */
  return(SerialUart_TransmitString(serialChannel, serialMessageTop,
      serialWait));
} // bool SerialUart_TransmitConstString(unsigned char serialChannel, const unsigned char *serialString, bool serialWait)
// </editor-fold>
// <editor-fold defaultstate="collapsed" desc="bool SerialUart_TransmitCharacter(unsigned char serialChannel, unsigned char serialCharacter, bool serialWait)">
/*******************************************************************************
//  Method: SerialUart_TransmitCharacter
//  Description:
//    To add a single character to the TX buffer; If the character is too
//    long to fit into the TX Buffer, the method will transmit one character
//    to make room.  Note - The method will disable all Interrupts while
//    adding the String to the TX Buffer
//
//  Inputs:
//    unsigned char serialChannel - Serial port to check
//    unsigned char serialCharacter - Character to Add to the Buffer
//    bool serialWait - If the method is to send the entire buffer before
//        returning
//
//  Outputs:
//    None
//
//  Returns:
//    True if the Character was successfully added to the TX buffer
//    False if the Character was not added to the TX buffer
//
//  Global Variable Usage:
//    None
//
//  Local Variable Usage:
//    unsigned int serialTxRemainingMessageLength - Length of the remaining
//        message in the TX Buffer
//
//  Exceptions:
//    None
//
*******************************************************************************/
bool SerialUart_TransmitCharacter(unsigned char serialChannel, unsigned char
    serialCharacter, bool serialWait) {
  
  // Length of the remaining message in the TX Buffer
  unsigned int serialTxRemainingMessageLength;
  /* 0x00 if interrupts are not used, otherwise it will contain the channel of
     the serial UART
  */

  // Flush the Temporary Buffer
  SerialUart_TempBufferPointer = SerialUart_FlushBuffer(
      SerialUart_TempBufferTop);
  
  #ifdef __SERIAL_UART_PORT_1_ENABLE_
    // Determine which Channel to Transmit the Message on
    if(serialChannel == 0x01) {

      // Determine the Length of the Remaining Message in the TX Buffer
      serialTxRemainingMessageLength = strlen(SerialUart_TxBufferPointer_1);

      // If the TX Buffer is not Empty
      if(serialTxRemainingMessageLength != 0) {
        // Ensure there is Room to Add the Character
        if(serialTxRemainingMessageLength == __SERIAL_UART_BUFFER_DEPTH_)
          // TX Buffer is Full so Send One Character and Wait for it to Transmit
          if(SerialUart_SendCharacter(serialChannel, true) == false)
            // Unable to Send the Character
            return(false);
        // Copy the Unsent TX Buffer into the Temporary Buffer
        SerialUart_TempBufferTop = strcpy(SerialUart_TempBufferTop,
            SerialUart_TxBufferPointer_1);
      }

      // Add the character to the Temporary Buffer
      SerialUart_TempBuffer[strlen(SerialUart_TempBufferTop)] = 
          serialCharacter;

      // Flush the TX Buffer
      SerialUart_TxBufferPointer_1 = SerialUart_FlushBuffer(
          SerialUart_TxBufferTop_1);

      // Copy the Temporary Buffer into the Tx Buffer
      SerialUart_TxBufferTop_1 = strcpy(SerialUart_TxBufferTop_1, 
          SerialUart_TempBufferTop);
  #endif // #ifdef __SERIAL_UART_PORT_1_ENABLE_

  // If the PIC has 2 Serial Ports
  #if __SERIAL_UART_CHANNELS_ == 2 && defined(__SERIAL_UART_PORT_2_ENABLE_)
    #ifdef __SERIAL_UART_PORT_1_ENABLE_
      } else if(serialChannel == 2) {
    #else
      if(serialChannel == 2) {
    #endif // #ifdef __SERIAL_UART_PORT_1_ENABLE_
    
      // Disable the Transmit Interrupt 
      __SERIAL_UART_INTERRUPT_TRANSMITENABLE_2_ = 0;

      // Determine the Length of the Remaining Message in the TX Buffer
      serialTxRemainingMessageLength = strlen(SerialUart_TxBufferPointer_2);
      
      // If the TX Buffer is not Empty
      if(serialTxRemainingMessageLength != 0) {
        // Ensure there is Room to Add the Character
        if(serialTxRemainingMessageLength == __SERIAL_UART_BUFFER_DEPTH_)
          // TX Buffer is Full so Send One Character and Wait for it to Transmit
          if(SerialUart_SendCharacter(serialChannel, true) == false)
            // Unable to Send the Character
            return(false);
        // Copy the Unsent TX Buffer into the Temporary Buffer
        SerialUart_TempBufferTop = strcpy(SerialUart_TempBufferTop,
            SerialUart_TxBufferPointer_2);
      }

      // Add the character to the Temporary Buffer
      SerialUart_TempBuffer[strlen(SerialUart_TempBufferTop)] = 
          serialCharacter;

      // Flush the TX Buffer
      SerialUart_TxBufferPointer_2 = SerialUart_FlushBuffer(
          SerialUart_TxBufferTop_2);
      
      // Copy the Temporary Buffer into the Tx Buffer
      SerialUart_TxBufferTop_2 = strcpy(SerialUart_TxBufferTop_2, 
          SerialUart_TempBufferTop);

  #endif // __SERIAL_UART_CHANNELS_ == 2 && defined(__SERIAL_UART_PORT_2_ENABLE_)
  } else
    return(false);
   
  // Start Sending the Buffer
  return(SerialUart_SendCharacter(serialChannel, serialWait));
} // bool SerialUart_TransmitCharacter(unsigned char serialChannel, unsigned char serialCharacter, bool serialWait)
// </editor-fold>
// <editor-fold defaultstate="collapsed" desc="bool SerialUart_TransmitConstCharacter(unsigned char serialChannel, const unsigned char serialCharacter, bool serialWait)">
/*******************************************************************************
//  Method: SerialUart_TransmitConstCharacter
//  Description:
//    To convert a const unsigned char character to an unsigned char character
//    and pass it on to SerialUart_TransmitCharacter()
//
//  Inputs:
//    unsigned char serialChannel - Serial port to check
//    const unsigned char serialCharacter - Character to add to the buffer
//    bool serialWait - If the method is to send the entire buffer before
//        returning
//
//  Outputs:
//    None
//
//  Returns:
//    True if the String was successfully added to the TX buffer
//    False if the String was not added to the TX buffer
//
//  Global Variable Usage:
//    None
//
//  Local Variable Usage:
//    None
//
//  Exceptions:
//    None
//
*******************************************************************************/
bool SerialUart_TransmitConstCharacter(unsigned char serialChannel, const
    unsigned char serialCharacter, bool serialWait) {
  
  /* Convert the (const unsigned char) to an (unsigned char) and call 
     SerialUart_TransmitCharacter
  */
  return(SerialUart_TransmitCharacter(serialChannel,
      (unsigned char) serialCharacter, serialWait));
} // bool SerialUart_TransmitConstCharacter(unsigned char serialChannel, const unsigned char serialCharacter, bool serialWait)
// </editor-fold>
// <editor-fold defaultstate="collapsed" desc="bool SerialUart_SendCharacter(unsigned char serialChannel, bool serialWait)">
/*******************************************************************************
//  Method: SerialUart_SendCharacter
//  Description:
//    To send the next character in the specified channel's TX buffer and, if 
//    serialWait is true, empty out the remaining message in the buffer
//
//  Inputs:
//    unsigned char serialChannel - Serial port to check
//    bool serialWait - If the method is to send the entire buffer before
//        returning
//
//  Outputs:
//    None
//
//  Returns:
//    True if the data was successfully transmitted
//    False if the data was not successfully transmitted
//
//  Global Variable Usage:
//    None
//
//  Local Variable Usage:
//    None
//
//  Exceptions:
//    None
//
*******************************************************************************/
bool SerialUart_SendCharacter(unsigned char serialChannel, bool serialWait) {
  
  // Ensure the previous transmit is complete
  SerialUart_WaitForTransmitToComplete(serialChannel);
  
  #ifdef __SERIAL_UART_PORT_1_ENABLE_
    // Determine which Channel to Transmit the Message on
    if(serialChannel == 0x01) {
      // Confirm that there is data in the Buffer to send
      if(*SerialUart_TxBufferPointer_1 == 0x00) {
        // Disable the USART Transmitter
        __SERIAL_UART_TRANSMIT_ENABLE_1_ = 0;
        /* Buffer is empty (0x00); Flush the TX Buffer and Point the Working
           Pointer to the top of the TX Buffer
        */
        SerialUart_TxBufferPointer_1 =
            SerialUart_FlushBuffer(SerialUart_TxBufferTop_1);
        // Nothing more to do, so return
        return(true);
      }

      // Enable the USART Transmitter
      __SERIAL_UART_TRANSMIT_ENABLE_1_ = 1;

      // Move the character into the TX register
      __SERIAL_UART_TX_REGISTER_1_ = *SerialUart_TxBufferPointer_1;
      // Increment the working pointer
      SerialUart_TxBufferPointer_1++;

      // Check to see if the buffer is to be emptied before returning
      if(serialWait == true) {
        // Disable the interrupt to prevent extra interrupt calls
        __SERIAL_UART_INTERRUPT_TRANSMITENABLE_1_ = 0;

        do {
          // Wait for the TX register to be empty
          SerialUart_WaitForTransmitToComplete(serialChannel);

          // Check to see if that was the end of the buffer
          if(*SerialUart_TxBufferPointer_1 != 0x00) {
            // Some data still remains in the buffer
            __SERIAL_UART_TX_REGISTER_1_ = *SerialUart_TxBufferPointer_1;
            // Increment the working pointer
            SerialUart_TxBufferPointer_1++;
          }
        // Repeat until the buffer is empty
        } while(*SerialUart_TxBufferPointer_1 != 0x00);

        // Wait for the TX register to be empty
        SerialUart_WaitForTransmitToComplete(serialChannel);

        // Disable the USART Transmitter
        __SERIAL_UART_TRANSMIT_ENABLE_1_ = 0;
        /* Buffer is empty (0x00); Flush the TX Buffer and Point the Working
           Pointer to the top of the TX Buffer
        */
        SerialUart_TxBufferPointer_1 =
            SerialUart_FlushBuffer(SerialUart_TxBufferTop_1);
      } else
        // Enable the interrupt
        __SERIAL_UART_INTERRUPT_TRANSMITENABLE_1_ = 1;
  #endif // #ifdef __SERIAL_UART_PORT_1_ENABLE_

  // If the PIC has 2 Serial Ports
  #if __SERIAL_UART_CHANNELS_ == 2 && defined(__SERIAL_UART_PORT_2_ENABLE_)
    #ifdef __SERIAL_UART_PORT_1_ENABLE_
      } else if(serialChannel == 2) {
    #else
      if(serialChannel == 2) {
    #endif // #ifdef __SERIAL_UART_PORT_1_ENABLE_
    
      // Confirm that there is data in the Buffer to send
      if(*SerialUart_TxBufferPointer_2 == 0x00) {
        // Disable the USART Transmitter
        __SERIAL_UART_TRANSMIT_ENABLE_2_ = 0;
        /* Buffer is empty (0x00); Flush the TX Buffer and Point the Working
           Pointer to the top of the TX Buffer
        */
        SerialUart_TxBufferPointer_2 =
            SerialUart_FlushBuffer(SerialUart_TxBufferTop_2);
        // Nothing more to do, so return
        return(true);
      }

      // Enable the USART Transmitter
      __SERIAL_UART_TRANSMIT_ENABLE_2_ = 1;

      // Move the character into the TX register
      __SERIAL_UART_TX_REGISTER_2_ = *SerialUart_TxBufferPointer_2;
      // Increment the working pointer
      SerialUart_TxBufferPointer_2++;

      // Check to see if the buffer is to be emptied before returning
      if(serialWait == true) {
        // Disable the interrupt to prevent extra interrupt calls
        __SERIAL_UART_INTERRUPT_TRANSMITENABLE_2_ = 0;

        do {
          // Wait for the TX register to be empty
          SerialUart_WaitForTransmitToComplete(serialChannel);

          // Check to see if that was the end of the buffer
          if(*SerialUart_TxBufferPointer_2 != 0x00) {
            // Some data still remains in the buffer
            __SERIAL_UART_TX_REGISTER_2_ = *SerialUart_TxBufferPointer_2;
            // Increment the working pointer
            SerialUart_TxBufferPointer_2++;
          }
        // Repeat until the buffer is empty
        } while(*SerialUart_TxBufferPointer_2 != 0x00);

        // Wait for the TX register to be empty
        SerialUart_WaitForTransmitToComplete(serialChannel);

        // Disable the USART Transmitter
        __SERIAL_UART_TRANSMIT_ENABLE_2_ = 0;
        /* Buffer is empty (0x00); Flush the TX Buffer and Point the Working
           Pointer to the top of the TX Buffer
        */
        SerialUart_TxBufferPointer_2 =
            SerialUart_FlushBuffer(SerialUart_TxBufferTop_2);
      } else
        // Enable the interrupt
        __SERIAL_UART_INTERRUPT_TRANSMITENABLE_2_ = 1;
  #endif // __SERIAL_UART_CHANNELS_ == 2 && defined(__SERIAL_UART_PORT_2_ENABLE_)
  } else
    return(false);

  return(true);
} // bool SerialUart_SendCharacter(unsigned char serialChannel, bool serialWait)
// </editor-fold>
// <editor-fold defaultstate="collapsed" desc="bool SerialUart_AddCharacterToRxBuffer(unsigned char serialChannel, unsigned char serialInput)">
/*******************************************************************************
//  Method: SerialUart_AddCharacterToRxBuffer
//  Description:
//    To confirm that there is room in the specified channel's RX buffer
//    and to add the character to the end;  If echo is enabled, then the
//    method will also send the character to the TX buff to be echoed back
//
//  Inputs:
//    unsigned char serialChannel - Serial port to modify
//    unsigned char serialInput - Character to add to the RX Buffer
//
//  Outputs:
//    None
//
//  Returns:
//    True if the Character was successfully added to the RX buffer
//    False if the Character was not added to the RX buffer
//
//  Global Variable Usage:
//    None
//
//  Local Variable Usage:
//    unsigned char message[] - Holding container for the character
//    unsigned char *messagePointer - Working pointer to the Holding container
//
//  Exceptions:
//    None
//
*******************************************************************************/
bool SerialUart_AddCharacterToRxBuffer(unsigned char serialChannel, unsigned
    char serialInput) {
  
    // Check to see if the character is a backspace (0x08) or delete (0x7F)
  if(serialInput == 0x08 || serialInput == 0x7F)
      return(SerialUart_Backspace(serialChannel, true));

  #ifdef __SERIAL_UART_PORT_1_ENABLE_
    // Determine which Channel to Modify
    if(serialChannel == 0x01) {

      // Ensure that there is room in the RX Buffer
      if(strlen(SerialUart_RxBufferPointer_1) >= (__SERIAL_UART_BUFFER_DEPTH_ 
          - 1))
        return(false);

      // Add the character to the RX Buffer
      *SerialUart_RxBufferPointer_1 = serialInput;
      // Increment the Pointer
      SerialUart_RxBufferPointer_1++;
      // Ensure the final character of the RX Buffer is a NULL character
      *SerialUart_RxBufferPointer_1 = 0x00;

      // Check to see if echo is enabled
      if(SerialUart_EnableEcho_1 == true)
          /* Echo is enable, so return the character; Default is serialWait 
             true since this is a feedback of the character
          */
        return(SerialUart_TransmitCharacter(serialChannel, serialInput,
            false));
      else
        // Return success
        return(true);
  #endif // #ifdef __SERIAL_UART_PORT_1_ENABLE_

  // If the PIC has 2 Serial Ports
  #if __SERIAL_UART_CHANNELS_ == 2 && defined(__SERIAL_UART_PORT_2_ENABLE_)
    #ifdef __SERIAL_UART_PORT_1_ENABLE_
      } else if(serialChannel == 2) {
    #else
      if(serialChannel == 2) {
    #endif // #ifdef __SERIAL_UART_PORT_1_ENABLE_
    
      // Ensure that there is room in the RX Buffer
      if(strlen(SerialUart_RxBufferPointer_2) >= (__SERIAL_UART_BUFFER_DEPTH_ 
          - 1))
        return(false);

      // Add the character to the RX Buffer
      *SerialUart_RxBufferPointer_2 = serialInput;
      // Increment the Pointer
      SerialUart_RxBufferPointer_2++;
      // Ensure the final character of the RX Buffer is a NULL character
      *SerialUart_RxBufferPointer_2 = 0x00;

      // Check to see if echo is enabled
      if(SerialUart_EnableEcho_2 == true)
        /* Echo is enable, so return the character; Default is serialWait 
           true since this is a feedback of the character
        */
        return(SerialUart_TransmitCharacter(serialChannel, serialInput,
            false));
      else
        // Return success
        return(true);
  #endif // __SERIAL_UART_CHANNELS_ == 2 && defined(__SERIAL_UART_PORT_2_ENABLE_)
  } else
    return(false);
} // bool SerialUart_AddCharacterToRxBuffer(unsigned char serialChannel, unsigned char serialInput)
// </editor-fold>
// <editor-fold defaultstate="collapsed" desc="bool SerialUart_RxBufferRemoveLastCharacter(unsigned char serialChannel)">
/*******************************************************************************
//  Method: SerialUart_RxBufferRemoveLastCharacter
//  Description:
//    To confirm that there is a character in the RX buffer that can be
//    removed, to move back the working pointer and to set that data location
//    to NULL
//
//  Inputs:
//    unsigned char serialChannel - Serial port to modify
//
//  Outputs:
//    None
//
//  Returns:
//    True if the Character was successfully removed from the RX buffer
//    False if there was no character to remove or an unknown channel
//
//  Global Variable Usage:
//    None
//
//  Local Variable Usage:
//    None
//
//  Exceptions:
//    None
//
*******************************************************************************/
bool SerialUart_RxBufferRemoveLastCharacter(unsigned char serialChannel) {
  
  #ifdef __SERIAL_UART_PORT_1_ENABLE_
    // Determine which Channel to Modify
    if(serialChannel == 0x01) {
      /* Confirm that the pointer is not already pointing the the top of the
       RX buffer
      */
      if(SerialUart_RxBufferPointer_1 == SerialUart_RxBufferTop_1)
        return(false);

      // Move the pointer back one position
      SerialUart_RxBufferPointer_1--;
      // Clear whatever data was there
      *SerialUart_RxBufferPointer_1 = 0x00;

      return(true);
  #endif // #ifdef __SERIAL_UART_PORT_1_ENABLE_

  // If the PIC has 2 Serial Ports
  #if __SERIAL_UART_CHANNELS_ == 2 && defined(__SERIAL_UART_PORT_2_ENABLE_)
    #ifdef __SERIAL_UART_PORT_1_ENABLE_
      } else if(serialChannel == 2) {
    #else
      if(serialChannel == 2) {
    #endif // #ifdef __SERIAL_UART_PORT_1_ENABLE_
    
      /* Confirm that the pointer is not already pointing the the top of the
       RX buffer
      */
      if(SerialUart_RxBufferPointer_2 == SerialUart_RxBufferTop_2)
        return(false);

      // Move the pointer back one position
      SerialUart_RxBufferPointer_2--;
      // Clear whatever data was there
      *SerialUart_RxBufferPointer_2 = 0x00;

      return(true);
  #endif // __SERIAL_UART_CHANNELS_ == 2 && defined(__SERIAL_UART_PORT_2_ENABLE_)
  } else
    return(false);
} // bool SerialUart_RxBufferRemoveLastCharacter(unsigned char serialChannel)
// </editor-fold>
// <editor-fold defaultstate="collapsed" desc="unsigned char SerialUart_GetLastRxBufferCharacter(unsigned char serialChannel)">
/*******************************************************************************
//  Method: SerialUart_GetLastRxBufferCharacter
//  Description:
//    To confirm that the buffer has at least one character and to return
//    that character.  If the RX buffer does not have a character, then
//    0x00 is returned.
//
//  Inputs:
//    unsigned char serialChannel - Serial port to modify
//
//  Outputs:
//    None
//
//  Returns:
//    0x00 if the buffer does not have a previous character, otherwise the
//    method will return the value of the last character
//
//  Global Variable Usage:
//    None
//
//  Local Variable Usage:
//    unsigned char * messagePointer - Local working pointer to walk
//        backwards with
//
//  Exceptions:
//    None
//
*******************************************************************************/
unsigned char SerialUart_GetLastRxBufferCharacter(unsigned char serialChannel) {
  
  // Local working pointer to walk backwards with
  unsigned char * messagePointer;

  #if __SERIAL_UART_CHANNELS_ == 2 && defined(__SERIAL_UART_PORT_2_ENABLE_)
    // Determine which Channel to return
    if(serialChannel == 0x02) {
      /* Confirm that the pointer is not already pointing the the top of the
       RX buffer
      */
      if(SerialUart_RxBufferPointer_2 == SerialUart_RxBufferTop_2)
        return(0x00);

      // Point the local working pointer at the working pointer
      messagePointer = SerialUart_RxBufferPointer_2;
      // Move back one position
      messagePointer--;
      // Return the found result
      return(*messagePointer);
    }
  #endif // __SERIAL_UART_CHANNELS_ == 2 && defined(__SERIAL_UART_PORT_2_ENABLE_)

  #ifdef __SERIAL_UART_PORT_1_ENABLE_
    // Default to Channel 1
    /* Confirm that the pointer is not already pointing the the top of the
     RX buffer
    */
    if(SerialUart_RxBufferPointer_1 == SerialUart_RxBufferTop_1)
      return(0x00);

    // Point the local working pointer at the working pointer
    messagePointer = SerialUart_RxBufferPointer_1;
    // Move back one position
    messagePointer--;
  #endif // #ifdef __SERIAL_UART_PORT_1_ENABLE_

  // Return the found result
  return(*messagePointer);
} // unsigned char SerialUart_GetLastRxBufferCharacter(unsigned char serialChannel)
// </editor-fold>
// <editor-fold defaultstate="collapsed" desc="bool SerialUart_ResetRxBuffer(unsigned char serialChannel)">
/*******************************************************************************
//  Method: SerialUart_ResetRxBuffer
//  Description:
//    To flush the specified serial UART RX buffer and return the working
//    pointer to the top
//
//  Inputs:
//    unsigned char serialChannel - Serial port to modify
//
//  Outputs:
//    None
//
//  Returns:
//    True if the RX Buffer was successfully flushed
//    False if an unknown serial channel is specified
//
//  Global Variable Usage:
//    None
//
//  Local Variable Usage:
//    None
//
//  Exceptions:
//    None
//
*******************************************************************************/
bool SerialUart_ResetRxBuffer(unsigned char serialChannel) {
  
  #ifdef __SERIAL_UART_PORT_1_ENABLE_
    // Determine which Channel to Clear
    if(serialChannel == 0x01) {
      SerialUart_RxBufferPointer_1 = 
          SerialUart_FlushBuffer(SerialUart_RxBufferTop_1);
      return(true);
  #endif // #ifdef __SERIAL_UART_PORT_1_ENABLE_

  // If the PIC has 2 Serial Ports
  #if __SERIAL_UART_CHANNELS_ == 2 && defined(__SERIAL_UART_PORT_2_ENABLE_)
    #ifdef __SERIAL_UART_PORT_1_ENABLE_
      } else if(serialChannel == 2) {
    #else
      if(serialChannel == 2) {
    #endif // #ifdef __SERIAL_UART_PORT_1_ENABLE_
    
      SerialUart_RxBufferPointer_2 = 
          SerialUart_FlushBuffer(SerialUart_RxBufferTop_2);
      return(true);
  #endif // __SERIAL_UART_CHANNELS_ == 2 && defined(__SERIAL_UART_PORT_2_ENABLE_)
  } else
    return(false);
} // bool SerialUart_ResetRxBuffer(unsigned char serialChannel)
// </editor-fold>
// <editor-fold defaultstate="collapsed" desc="bool SerialUart_Backspace(unsigned char serialChannel, bool serialWait)">
/*******************************************************************************
//  Method: SerialUart_Backspace
//  Description:
//    To remove the last character from the specified RX buffer and to send 
//    the backspace command String to the host terminal
//
//  Inputs:
//    unsigned char serialChannel - Serial port to modify
//
//  Outputs:
//    None
//
//  Returns:
//    True if the command was successful
//    False if an error occurred
//
//  Global Variable Usage:
//    None
//
//  Local Variable Usage:
//    unsigned char serialMessage[] - Holding container for the command
//    unsigned char *serialMessageTop - Pointer to the holding container
//
//  Exceptions:
//    None
//
*******************************************************************************/
bool SerialUart_Backspace(unsigned char serialChannel, bool serialWait) {
  
  // Holding container for the command
  unsigned char serialMessage[] = __SERIAL_UART_MESSAGE_BACKSPACE_;
  // Pointer to the holding container
  unsigned char *serialMessageTop = &serialMessage[0];
  
  // Send the command to the TX Buffer
  if(SerialUart_TransmitString(serialChannel, serialMessageTop,
      serialWait) == false)
    return(false);
  
  // Remove the character from the RX buffer
  return(SerialUart_RxBufferRemoveLastCharacter(serialChannel));  
} // bool SerialUart_Backspace(unsigned char serialChannel, bool serialWait)
// </editor-fold>
// <editor-fold defaultstate="collapsed" desc="bool SerialUart_ClearScreen(unsigned char serialChannel, bool serialWait)">
/*******************************************************************************
//  Method: SerialUart_ClearScreen
//  Description:
//    To clear the specified VT100 compliant terminal of all data
//
//  Inputs:
//    unsigned char serialChannel - Serial port to modify
//
//  Outputs:
//    None
//
//  Returns:
//    True if the command was successful
//    False if an error occurred
//
//  Global Variable Usage:
//    None
//
//  Local Variable Usage:
//    unsigned char serialMessage[] - Holding container for the command
//    unsigned char *serialMessageTop - Pointer to the holding container
//
//  Exceptions:
//    None
//
*******************************************************************************/
bool SerialUart_ClearScreen(unsigned char serialChannel, bool serialWait) {
  
  // Holding container for the command
  unsigned char serialMessage[] = __SERIAL_UART_MESSAGE_CLEARSCREEN_;
  // Pointer to the holding container
  unsigned char *serialMessageTop = &serialMessage[0];
  
  // Send the command
  return(SerialUart_TransmitString(serialChannel, serialMessageTop,
      serialWait));
} // bool SerialUart_ClearScreen(unsigned char serialChannel, bool serialWait)
// </editor-fold>
// <editor-fold defaultstate="collapsed" desc="bool SerialUart_ResizeScreen(unsigned char serialChannel, unsigned int vertical, unsigned int horizontal, bool serialWait)">
/*******************************************************************************
//  Method: SerialUart_ResizeScreen
//  Description:
//    To resize the specified VT100 terminal window to the specified row and
//    column settings
//
//  Inputs:
//    unsigned char serialChannel - Serial port to modify
//    unsigned int vertical - Number of Rows for the screen
//    unsigned int horizontal - Number of Columns for the screen
//    bool serialWait - If the method is to send the entire buffer before
//        returning
//
//  Outputs:
//    None
//
//  Returns:
//    True if the command was successful
//    False if an error occurred
//
//  Global Variable Usage:
//    None
//
//  Local Variable Usage:
//    unsigned char serialMessage[] - Holding container for the command
//    unsigned char *serialMessageTop - Pointer to the holding container
//    unsigned char messageStart[] - Holding container for the Resize
//        Message Start
//    unsigned char messageMiddle[] - Holding container for the Resize 
//        Message Middle
//    unsigned char messageEnd[] - Holding container for the Resize 
//        Message Ending
//    unsigned char messageVertical[] - Holding container for the 
//        vertical String Value
//    unsigned char messageHorizontal[] - Holding container for the 
//        horizontal String Value
//    unsigned char * messagePointer - Working pointer for the message arrays
//
//  Exceptions:
//    None
//
*******************************************************************************/
bool SerialUart_ResizeScreen(unsigned char serialChannel, unsigned int
    vertical, unsigned int horizontal, bool serialWait) {
  
  // Holding container for the command; Default array size is 30 characters
  unsigned char serialMessage[] =
      {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
  // Pointer to the holding container
  unsigned char *serialMessageTop = &serialMessage[0];
  
  // Holding container for the Resize Message Start
  unsigned char messageStart[] = __SERIAL_UART_MESSAGE_RESIZE_START_;
  // Holding container for the Resize Message Middle
  unsigned char messageMiddle[] = __SERIAL_UART_MESSAGE_RESIZE_MIDDLE_;
  // Holding container for the Resize Message Ending
  unsigned char messageEnd[] = __SERIAL_UART_MESSAGE_RESIZE_END_;
  // Holding container for the vertical String Value
  unsigned char messageVertical[] = {0x00, 0x00, 0x00, 0x00};
  // Holding container for the horizontal String Value
  unsigned char messageHorizontal[] = {0x00, 0x00, 0x00, 0x00};
  // Working pointer for the message arrays
  unsigned char * messagePointer;
  
  /* Confirm that the vertical size is more than the minimum and that it will
     fit in the array
  */
  if(vertical < __SERIAL_UART_RESIZE_MINIMIUM_VERTICAL_ ||
      vertical >= 9999)
    return(false);
  else {
    /* Vertical is an acceptable value, so convert it to a string and push
       it into the messageVertical array
    */
    messagePointer = &messageVertical[0];
    messagePointer = itoa(messagePointer, vertical, 10);
  }

  /* Confirm that the horizontal size is more than the minimum and that it will
     fit in the array
  */
  if(horizontal < __SERIAL_UART_RESIZE_MINIMIUM_HORIZONTAL_ ||
      horizontal >= 9999)
    return(false);
  else {
    /* Horizontal is an acceptable value, so convert it to a string and push
       it into the messageHorizontal array
    */
    messagePointer = &messageHorizontal[0];
    messagePointer = itoa(messagePointer, horizontal, 10);
  }
  
  // Point to the __SERIAL_UART_MESSAGE_RESIZE_START_ message
  messagePointer = &messageStart[0];
  // Add message to the serial message
  serialMessageTop = strcpy(serialMessageTop, messagePointer);
  // Point to the vertical array value
  messagePointer = &messageVertical[0];
  // Add message to the serial message
  serialMessageTop = strcat(serialMessageTop, messagePointer);
  // Point to the __SERIAL_UART_MESSAGE_RESIZE_MIDDLE_ message
  messagePointer = &messageMiddle[0];
  // Add message to the serial message
  serialMessageTop = strcat(serialMessageTop, messagePointer);
  // Point to the horizontal array value
  messagePointer = &messageHorizontal[0];
  // Add message to the serial message
  serialMessageTop = strcat(serialMessageTop, messagePointer);
  // Point to the __SERIAL_UART_MESSAGE_RESIZE_END_ message
  messagePointer = &messageEnd[0];
  // Add message to the serial message
  serialMessageTop = strcat(serialMessageTop, messagePointer);
  
  return(SerialUart_TransmitString(serialChannel, serialMessageTop,
      serialWait));
} // bool SerialUart_ResizeScreen(unsigned char serialChannel, unsigned int vertical, unsigned int horizontal, bool serialWait)
// </editor-fold>
// <editor-fold defaultstate="collapsed" desc="bool SerialUart_Beep(unsigned char serialChannel)">
/*******************************************************************************
//  Method: SerialUart_Beep
//  Description:
//    To sound a beep on the specified VT100 compliant terminal
//
//  Inputs:
//    unsigned char serialChannel - Serial port to modify
//
//  Outputs:
//    None
//
//  Returns:
//    True if the command was successful
//    False if an error occurred
//
//  Global Variable Usage:
//    None
//
//  Local Variable Usage:
//    unsigned char serialMessage[] - Holding container for the command
//    unsigned char *serialMessageTop - Pointer to the holding container
//
//  Exceptions:
//    None
//
*******************************************************************************/
bool SerialUart_Beep(unsigned char serialChannel) {
  
  // Holding container for the command
  unsigned char serialMessage[] = __SERIAL_UART_MESSAGE_BEEP_;
  // Pointer to the holding container
  unsigned char *serialMessageTop = &serialMessage[0];

  // Send the command
  return(SerialUart_TransmitString(serialChannel, serialMessageTop,
      true));
} // bool SerialUart_Beep(unsigned char serialChannel)
// </editor-fold>
// <editor-fold defaultstate="collapsed" desc="unsigned long SerialUart_SetBaudRate(unsigned char serialChannel, unsigned long systemFrequency, unsigned long baudRateTarget)">
/*******************************************************************************
//  Method: SerialUart_SetBaudRate
//  Description:
//    To set the baud rate of a serial port to a desired speed
//
//  Inputs:
//    unsigned char serialChannel - Serial port to modify
//    unsigned long systemFrequency - System FOSC in Hz; 1MHz would be
//        1000000
//    unsigned long baudRateTarget - Desired serial UART baud rate in bits
//        per second; 115.2kbps would be 115200
//
//  Outputs:
//    None
//
//  Returns:
//    Actual calculated baud rate with the lowest error.  If it is not
//    possible to achieve the desired baud rate given the system frequency,
//    then 0xFFFFFFFF will be returned in place of the calculated baud rate.
//
//  Global Variable Usage:
//    None
//
//  Local Variable Usage:
//    double idealNValue[__SERIAL_UART_BAUDRATE_EQUATION_MAX_] - Place holder
//        array to store the calculated ideal SPBRG value
//    double nValue[__SERIAL_UART_BAUDRATE_EQUATION_MAX_] - Place holder
//        array for the closes whole number to the ideal value
//    double actualBaudRate[__SERIAL_UART_BAUDRATE_EQUATION_MAX_] - Place 
//        holder array containing the calculated baud rate using the nValue
//        as an input
//    double error[__SERIAL_UART_BAUDRATE_EQUATION_MAX_] - Place holder 
//        array to store the percentage error between the actual baud rate
//        and the desired baud rate
//    unsigned char smallestError - Of all of the possible settings, which
//        equation has the lowest error
//    unsigned char settingSync - Temporary place holder for the equation's 
//        SYNC value
//    unsigned char settingBrg16 - Temporary place holder for the equation's 
//        BRG16 value
//    unsigned char settingBrgh - Temporary place holder for the equation's 
//        BRGH value
//    unsigned long finalBaudRate - Temporary place holder for the selected 
//        actual baud rate value
//
//  Exceptions:
//    None
//
*******************************************************************************/
unsigned long SerialUart_SetBaudRate(unsigned char serialChannel, unsigned  
    long systemFrequency, unsigned long baudRateTarget) {
  
  // Place holder array to store the calculated ideal SPBRG value
  double idealNValue[__SERIAL_UART_BAUDRATE_EQUATION_MAX_];
  // Place holder array for the closes whole number to the ideal value
  double nValue[__SERIAL_UART_BAUDRATE_EQUATION_MAX_];
  /* Place holder array containing the calculated baud rate using the
     nValue as an input
  */
  double actualBaudRate[__SERIAL_UART_BAUDRATE_EQUATION_MAX_];
  /* Place holder array to store the percentage error between the actual baud
     rate and the desired baud rate
  */
  double error[__SERIAL_UART_BAUDRATE_EQUATION_MAX_];
  // Of all of the possible settings, which equation has the lowest error
  unsigned char smallestError;
  // Temporary place holder for the equation's SYNC value
  unsigned char settingSync;
  // Temporary place holder for the equation's BRG16 value
  unsigned char settingBrg16;
  // Temporary place holder for the equation's BRGH value
  unsigned char settingBrgh;
  // Temporary place holder for the selected actual baud rate value
  unsigned long finalBaudRate;
  
  // Confirm that the target baud rate is a commonly used one
  if(SerialUart_ConfirmTargetBaudRate(baudRateTarget) == false)
    return(0xFFFFFFFF);
  
  // Calculate the ideal SPBRG value for the target baud rate
  idealNValue[0] = (baudRateTarget * 
      __SERIAL_UART_BAUDRATE_EQUATION_0_N_);
  idealNValue[0] = (systemFrequency / idealNValue[0]) - 1;
  /* Round the ideal value to the closest whole number and add it to the
     nValue array
  */
  nValue[0] = (unsigned int) (idealNValue[0] + 0.5);

  // Confirm that the nValue fits in the SPBRG register
  if(nValue[0] >= __SERIAL_UART_BAUDRATE_EQUATION_0_MAXNVALUE_) {
    // nValue doesn't fit, set actualBaudRate and error to NULL values
    actualBaudRate[0] = 0xFFFFFFFF;
    error[0] = 0;
  } else {
    // nValue fits so calculate the actual baud rate
    actualBaudRate[0] = systemFrequency / ((nValue[0] + 1) * 
        __SERIAL_UART_BAUDRATE_EQUATION_0_N_);
    /* Calculate the error between the actual baud rate and the desired
       baud rate
    */
    error[0] = (actualBaudRate[0] / baudRateTarget);
    error[0] = fabs((1 - error[0]) * 100);
  }

  #ifdef __SERIAL_UART_BAUDRATE_EQUATION_1_N_
    // Calculate the ideal SPBRG value for the target baud rate
    idealNValue[1] = (baudRateTarget * 
        __SERIAL_UART_BAUDRATE_EQUATION_1_N_);
    idealNValue[1] = (systemFrequency / idealNValue[1]) - 1;
    /* Round the ideal value to the closest whole number and add it to the
       nValue array
    */
    nValue[1] = (unsigned int) (idealNValue[1] + 0.5);

    // Confirm that the nValue fits in the SPBRG register
    if(nValue[1] >= __SERIAL_UART_BAUDRATE_EQUATION_1_MAXNVALUE_) {
      // nValue doesn't fit, set actualBaudRate and error to NULL values
      actualBaudRate[1] = 0xFFFFFFFF;
      error[1] = 0;
    } else {
      // nValue fits so calculate the actual baud rate
      actualBaudRate[1] = systemFrequency / ((nValue[1] + 1) * 
        __SERIAL_UART_BAUDRATE_EQUATION_1_N_);
      /* Calculate the error between the actual baud rate and the desired
       baud rate
      */
      error[1] = (actualBaudRate[1] / baudRateTarget);
      error[1] = fabs((1 - error[1]) * 100);
    }
  #else
    error[1] = 0;
  #endif // #ifdef __SERIAL_UART_BAUDRATE_EQUATION_1_N_

  #ifdef __SERIAL_UART_BAUDRATE_EQUATION_2_N_
    // Calculate the ideal SPBRG value for the target baud rate
    idealNValue[2] = (baudRateTarget * 
        __SERIAL_UART_BAUDRATE_EQUATION_2_N_);
    idealNValue[2] = (systemFrequency / idealNValue[2]) - 1;
    /* Round the ideal value to the cloest whole number and add it to the
       nValue array
    */
    nValue[2] = (unsigned int) (idealNValue[2] + 0.5);

    // Confirm that the nValue fits in the SPBRG register
    if(nValue[2] >= __SERIAL_UART_BAUDRATE_EQUATION_2_MAXNVALUE_) {
      // nValue doesn't fit, set actualBaudRate and error to NULL values
      actualBaudRate[2] = 0xFFFFFFFF;
      error[2] = 0;
    } else {
      // nValue fits so calculate the actual baud rate
      actualBaudRate[2] = systemFrequency / ((nValue[2] + 1) * 
        __SERIAL_UART_BAUDRATE_EQUATION_2_N_);
      /* Calculate the error between the actual baud rate and the desired
       baud rate
      */
      error[2] = (actualBaudRate[2] / baudRateTarget);
      error[2] = fabs((1 - error[2]) * 100);
    }
  #else
    error[2] = 0;
  #endif // #ifdef __SERIAL_UART_BAUDRATE_EQUATION_2_N_

  #ifdef __SERIAL_UART_BAUDRATE_EQUATION_3_N_
    // Calculate the ideal SPBRG value for the target baud rate
    idealNValue[3] = (baudRateTarget * 
        __SERIAL_UART_BAUDRATE_EQUATION_3_N_);
    idealNValue[3] = (systemFrequency / idealNValue[3]) - 1;
    /* Round the ideal value to the cloest whole number and add it to the
       nValue array
    */
    nValue[3] = (unsigned int) (idealNValue[3] + 0.5);

    // Confirm that the nValue fits in the SPBRG register
    if(nValue[3] >= __SERIAL_UART_BAUDRATE_EQUATION_3_MAXNVALUE_) {
      // nValue doesn't fit, set actualBaudRate and error to NULL values
      actualBaudRate[3] = 0xFFFFFFFF;
      error[3] = 0;
    } else {
      // nValue fits so calculate the actual baud rate
      actualBaudRate[3] = systemFrequency / ((nValue[3] + 1) * 
        __SERIAL_UART_BAUDRATE_EQUATION_3_N_);
      /* Calculate the error between the actual baud rate and the desired
       baud rate
      */
      error[3] = (actualBaudRate[3] / baudRateTarget);
      error[3] = fabs((1 - error[3]) * 100);
    }
  #else
    error[3] = 0;
  #endif // #ifdef __SERIAL_UART_BAUDRATE_EQUATION_3_N_
  
  // Confirm that at least on nValue is a valid value
  if(error[0] == 0 && error[1] == 0 && error[2] == 0 && error[3] == 0)
    return(0xFFFFFFFF);
    
  // Find the setting with the lowest error
  for(unsigned char i = 0; i < __SERIAL_UART_BAUDRATE_EQUATION_MAX_; i++) {
    if(i == 0)
      smallestError = 0;
    else if(error[i] != 0 && error[i] < error[smallestError])
      smallestError = i;
  }
    
  // Ensure that the error is less than the maximum allowed error percentage
  if(error[smallestError] >= __SERIAL_UART_BAUDRATE_MAXALLOWEDERROR_)
    return(0xFFFFFFFF);
    
  // Load the register settings based on the lowest error setting
  switch(smallestError) {
    case 0x00:
      // Equation 0 has the lowest error
      settingSync = __SERIAL_UART_BAUDRATE_EQUATION_0_SYNC_;
      settingBrg16 = __SERIAL_UART_BAUDRATE_EQUATION_0_BRG16_;
      settingBrgh = __SERIAL_UART_BAUDRATE_EQUATION_0_BRGH_;
      finalBaudRate = (unsigned long) actualBaudRate[0];
      break;
    #ifdef __SERIAL_UART_BAUDRATE_EQUATION_1_N_
      case 0x01:
        // Equation 1 has the lowest error
        settingSync = __SERIAL_UART_BAUDRATE_EQUATION_1_SYNC_;
        settingBrg16 = __SERIAL_UART_BAUDRATE_EQUATION_1_BRG16_;
        settingBrgh = __SERIAL_UART_BAUDRATE_EQUATION_1_BRGH_;
        finalBaudRate = (unsigned long) actualBaudRate[1];
        break;
    #endif
    #ifdef __SERIAL_UART_BAUDRATE_EQUATION_2_N_
      case 0x02:
        // Equation 2 has the lowest error
        settingSync = __SERIAL_UART_BAUDRATE_EQUATION_2_SYNC_;
        settingBrg16 = __SERIAL_UART_BAUDRATE_EQUATION_2_BRG16_;
        settingBrgh = __SERIAL_UART_BAUDRATE_EQUATION_2_BRGH_;
        finalBaudRate = (unsigned long) actualBaudRate[2];
        break;
    #endif
    #ifdef __SERIAL_UART_BAUDRATE_EQUATION_3_N_
      case 0x03:
        // Equation 3 has the lowest error
        settingSync = __SERIAL_UART_BAUDRATE_EQUATION_3_SYNC_;
        settingBrg16 = __SERIAL_UART_BAUDRATE_EQUATION_3_BRG16_;
        settingBrgh = __SERIAL_UART_BAUDRATE_EQUATION_3_BRGH_;
        finalBaudRate = (unsigned long) actualBaudRate[3];
        break;
    #endif
    default:
      // Unable to determine which channel has the lowest error
      return(0xFFFFFFFF);
  }
  
  #ifdef __SERIAL_UART_PORT_1_ENABLE_
    // Determine which Channel to the baud rate is for
    if(serialChannel == 0x01) {
      // Set the baud rate registers for Serial UART 1
      __SERIAL_UART_BAUDRATE_1_SYNC_ = settingSync;
      __SERIAL_UART_BAUDRATE_1_BRG16_ = settingBrg16;
      __SERIAL_UART_BAUDRATE_1_BRGH_ = settingBrgh;
      __SERIAL_UART_BAUDRATE_1_SPBRG_ = (unsigned int) nValue[smallestError];
      return(finalBaudRate);
  #endif // #ifdef __SERIAL_UART_PORT_1_ENABLE_

  #if __SERIAL_UART_CHANNELS_ == 2 && defined(__SERIAL_UART_PORT_2_ENABLE_)
    #ifdef __SERIAL_UART_PORT_1_ENABLE_
      } else if(serialChannel == 0x02) {
    #else
      if(serialChannel == 0x02) {
    #endif // #ifdef __SERIAL_UART_PORT_1_ENABLE_

      // Set the baud rate registers for Serial UART 2
      __SERIAL_UART_BAUDRATE_2_SYNC_ = settingSync;
      __SERIAL_UART_BAUDRATE_2_BRG16_ = settingBrg16;
      __SERIAL_UART_BAUDRATE_2_BRGH_ = settingBrgh;
      __SERIAL_UART_BAUDRATE_2_SPBRG_ = (unsigned int) nValue[smallestError];
      return(finalBaudRate);
  #endif // __SERIAL_UART_CHANNELS_ == 2 && defined(__SERIAL_UART_PORT_2_ENABLE_)
  } else
    // Unable to determine which channel to modify
    return(0xFFFFFFFF);  
} // unsigned long SerialUart_SetBaudRate(unsigned char serialChannel, unsigned long systemFrequency, unsigned long baudRateTarget)
// </editor-fold>
// <editor-fold defaultstate="collapsed" desc="bool SerialUart_ConfirmTargetBaudRate(unsigned long baudRateTarget)">
/*******************************************************************************
//  Method: SerialUart_ConfirmTargetBaudRate
//  Description:
//    To confirm that the target baud rate is a commonly used baud rate
//
//  Inputs:
//    unsigned long baudRateTarget - Desired serial UART baud rate in bits
//        per second; 115.2kbps would be 115200
//
//  Outputs:
//    None
//
//  Returns:
//    True if the baud rate is a commonly used baud rate
//    False if the baud rate is not a commonly used baud rate
//
//  Global Variable Usage:
//    None
//
//  Local Variable Usage:
//    unsigned long acceptableBaudRates[] - Array of Commonly Used Baud Rates
//
//  Exceptions:
//    None
//
*******************************************************************************/
bool SerialUart_ConfirmTargetBaudRate(unsigned long baudRateTarget) {
  
  // Array of Commonly Used Baud Rates
  unsigned long acceptableBaudRates[] = __SERIAL_UART_BAUDRATE_SPEEDS_;
  
  // Walk the baud rate array and return true if the baud rate was found
  for(unsigned char i = 0; i < __SERIAL_UART_BAUDRATE_NUMBEROFSPEEDS_; i++) {
    if(baudRateTarget == acceptableBaudRates[i])
      return(true);
  }
  
  // Baud Rate was not in the array so return false
  return(false);
} // bool SerialUart_ConfirmTargetBaudRate(unsigned long baudRateTarget)
// </editor-fold>
// <editor-fold defaultstate="collapsed" desc="bool SerialUart_EnablePort(unsigned char serialChannel, bool enableInterrupts)">
/*******************************************************************************
//  Method: SerialUart_EnablePort
//  Description:
//    To set all bits to enable the specified Serial UART port for asynchronous
//    operation
//
//  Inputs:
//    unsigned char serialChannel - Serial port to modify
//    bool enableInterrupts - If the Interrupts are to be enabled
//
//  Outputs:
//    None
//
//  Returns:
//    True if the port was correctly setup
//    False if the port channel was not recognized
//
//  Global Variable Usage:
//    None
//
//  Local Variable Usage:
//    None
//
//  Exceptions:
//    None
//
*******************************************************************************/
bool SerialUart_EnablePort(unsigned char serialChannel, bool enableInterrupts) {
  
  #ifdef __SERIAL_UART_PORT_1_ENABLE_
    if(serialChannel == 1) {
      // Enable Serial UART Port 1
      __SERIAL_UART_1_SPEN_ = 1;
      // Set Serial UART Port1 to be 8-bit Only
      __SERIAL_UART_1_TX9_ = 0;
      // TX is HIGH when idle
      __SERIAL_UART_TRANSMIT_1_SCKP_ = 0;
      // Enable the Receiver
      __SERIAL_UART_RECEIVE_ENABLE_1_ = 1;

      if(enableInterrupts == true) {
        // Enable the RX Interrupt
        __SERIAL_UART_INTERRUPT_RECEIVEENABLE_1_ = 1;
      }

      return(true);
  #endif // #ifdef __SERIAL_UART_PORT_1_ENABLE_

  // If the PIC has 2 Serial Ports
  #if __SERIAL_UART_CHANNELS_ == 2 && defined(__SERIAL_UART_PORT_2_ENABLE_)
    #ifdef __SERIAL_UART_PORT_1_ENABLE_
      } else if(serialChannel == 2) {
    #else
      if(serialChannel == 2) {
    #endif // #ifdef __SERIAL_UART_PORT_1_ENABLE_

      // Enable Serial UART Port 2
      __SERIAL_UART_2_SPEN_ = 1;
      // Set Serial UART Port1 to be 8-bit Only
      __SERIAL_UART_2_TX9_ = 0;
      // TX is HIGH when idle
      __SERIAL_UART_TRANSMIT_2_SCKP_ = 0;
      // Enable the Receiver
      __SERIAL_UART_RECEIVE_ENABLE_2_ = 1;

      if(enableInterrupts == true) {
        // Enable the RX Interrupt
        __SERIAL_UART_INTERRUPT_RECEIVEENABLE_2_ = 1;
      }

      return(true);
  #endif // #if __SERIAL_UART_CHANNELS_ == 2 && defined(__SERIAL_UART_PORT_2_ENABLE_)
  } else
    return(false);
} // bool SerialUart_EnablePort(unsigned char serialChannel, bool enableInterrupts)
// </editor-fold>
// <editor-fold defaultstate="collapsed" desc="bool SerialUart_RxContainsString(unsigned char serialChannel, unsigned char * searchString)">
/*******************************************************************************
//  Method: SerialUart_RxContainsString
//  Description:
//    To search the specified RX buffer for the specified character array.  
//    If the array is in the RX buffer, the method will return true; otherwise
//    the method returns false.
//
//  Inputs:
//    unsigned char serialChannel - Serial port to search
//    unsigned char searchString - Character array to look for
//
//  Outputs:
//    None
//
//  Returns:
//    True if search string was in the buffer
//    False if search string was not in the buffer
//
//  Global Variable Usage:
//    None
//
//  Local Variable Usage:
//    unsigned char * searchStringLocation - Pointer to the first character
//        of the search string in the RX buffer if found; NULL if the search
//        string is not found
//
//  Exceptions:
//    None
//
*******************************************************************************/
bool SerialUart_RxContainsString(unsigned char serialChannel, unsigned char *
    searchString) {

  /* Pointer to the first character of the search string in the RX buffer
     if found; NULL if the search string is not found
  */
  unsigned char * searchStringLocation = NULL;

  #ifdef __SERIAL_UART_PORT_1_ENABLE_
    // Determine the Serial Channel
    if(serialChannel == 1) {
      // Locate the String in the RX buffer
      searchStringLocation = strstr(SerialUart_RxBufferTop_1, searchString);
  #endif // #ifdef __SERIAL_UART_PORT_1_ENABLE_

  // If the PIC has 2 Serial Ports
  #if __SERIAL_UART_CHANNELS_ == 2 && defined(__SERIAL_UART_PORT_2_ENABLE_)
    #ifdef __SERIAL_UART_PORT_1_ENABLE_
      } else if(serialChannel == 2) {
    #else
      if(serialChannel == 2) {
    #endif // #ifdef __SERIAL_UART_PORT_1_ENABLE_
        // Locate the String in the RX buffer
        searchStringLocation = strstr(SerialUart_RxBufferTop_2, searchString);
  #endif // #if __SERIAL_UART_CHANNELS_ == 2 && defined(__SERIAL_UART_PORT_2_ENABLE_)

  } else
    return(false);

  // Confirm search string exists
  if(searchStringLocation == NULL)
    // Return false because the string was not in the RX buffer
    return(false);
  else
    // Rx buffer contains the string so return true
    return(true);
} // bool SerialUart_RxContainsString(unsigned char serialChannel, unsigned char * searchString)
// </editor-fold>
// <editor-fold defaultstate="collapsed" desc="unsigned char * SerialUart_RxBufferBeforeString(unsigned char serialChannel, unsigned char * searchString)">
/*******************************************************************************
//  Method: SerialUart_RxBufferBeforeString
//  Description:
//    To search the specified RX buffer for the specified character array.  
//    If the array is in the RX buffer, the method will move all preceeding
//    data in the RX buffer to the Temp Buffer and move all remaining data
//    to the front of the RX buffer.  The method will then return a pointer
//    to the top of the Temp Buffer.  If the array is not in the RX buffer,
//    the method returns NULL.
//
//  Inputs:
//    unsigned char serialChannel - Serial port to search
//    unsigned char searchString - Character array to look for
//
//  Outputs:
//    None
//
//  Returns:
//    Pointer to the top of the Temp buffer if search string was in the buffer
//    NULL if search string was not in the buffer
//
//  Global Variable Usage:
//    None
//
//  Local Variable Usage:
//    unsigned char * searchStringLocation - Pointer to the first character
//        of the search string in the RX buffer if found; NULL if the search
//        string is not found
//    unsigned char * stringRxTop - Pointer to the top of the specified RX
//        buffer
//    unsigned char * stringRxLocation - Working pointer to move through the
//        RX buffer
//    unsigned int returnBufferSize - Incremental counter to prevent a buffer
//        run-away condition
//    unsigned char i - Counting variable for For Loop
//
//  Exceptions:
//    None
//
*******************************************************************************/
unsigned char * SerialUart_RxBufferBeforeString(unsigned char serialChannel, 
    unsigned char * searchString) {

  /* Pointer to the first character of the search string in the RX buffer
     if found; NULL if the search string is not found
  */
  unsigned char * searchStringLocation;
  // Pointer to the top of the specified RX buffer
  unsigned char * stringRxTop;
  // Working pointer to move through the RX buffer
  unsigned char * stringRxLocation;
  // Incremental counter to prevent a buffer run-away condition
  unsigned int returnBufferSize = 0;
  
  #ifdef __SERIAL_UART_PORT_1_ENABLE_
    if(serialChannel == 1) {
      // Copy the location of the top of the RX Buffer
      stringRxTop = SerialUart_RxBufferTop_1;
      // Locate the String in the RX buffer
      searchStringLocation = strstr(SerialUart_RxBufferTop_1, searchString);
  #endif // #ifdef __SERIAL_UART_PORT_1_ENABLE_

  // If the PIC has 2 Serial Ports
  #if __SERIAL_UART_CHANNELS_ == 2 && defined(__SERIAL_UART_PORT_2_ENABLE_)
    #ifdef __SERIAL_UART_PORT_1_ENABLE_
      } else if(serialChannel == 2) {
    #else
      if(serialChannel == 2) {
    #endif // #ifdef __SERIAL_UART_PORT_1_ENABLE_
        // Copy the location of the top of the RX Buffer
        stringRxTop = SerialUart_RxBufferTop_2;
        // Locate the String in the RX buffer
        searchStringLocation = strstr(SerialUart_RxBufferTop_2, searchString);
  #endif // #if __SERIAL_UART_CHANNELS_ == 2 && defined(__SERIAL_UART_PORT_2_ENABLE_)

  } else
    return(false);

  // Return false if the string was not in the RX Buffer
  if(searchStringLocation == NULL)
    return(NULL);

  // Flush the Temp Buffer
  SerialUart_TempBufferPointer = 
      SerialUart_FlushBuffer(SerialUart_TempBufferTop);

  // Point the working pointer to the top of the RX buffer
  stringRxLocation = stringRxTop;

  // Walk the RX buffer until we get to the search string location
  while(stringRxLocation != searchStringLocation) {
    // Make sure we are still in the RX Buffer Array
    if(returnBufferSize == __SERIAL_UART_BUFFER_DEPTH_)
      return(NULL);

    // Copy the RX character into the temporary buffer
    *SerialUart_TempBufferPointer = *stringRxLocation;
    // Clear the location in the RX buffer
    *stringRxLocation = 0x00;
    // Move the Temp Buffer Pointer
    SerialUart_TempBufferPointer++;
    // Move the RX Buffer pointer
    stringRxLocation++;
    // Increment the RX message size
    returnBufferSize++;
  }

  // Copy the search string into the temporary buffer
  for(unsigned char i = 0; i < strlen(searchString); i++) {
    // Copy the RX character into the temporary buffer
    *SerialUart_TempBufferPointer = *searchStringLocation;
    // Clear the location in the RX buffer
    *searchStringLocation = 0x00;
    // Move the Temp Buffer Pointer
    SerialUart_TempBufferPointer++;
    // Move the RX Buffer pointer
    searchStringLocation++;
  }

  // Point the RX Location to the top of the RX Buffer
  stringRxLocation = stringRxTop;

  // Copy any remaining data to the front of the RX Buffer
  while(*searchStringLocation != 0x00) {
    // Move the RX character to the front of the buffer
    *stringRxLocation = *searchStringLocation;
    // Clear the old location in the RX buffer
    *searchStringLocation = 0x00;
    // Move the remaining RX Buffer pointer
    searchStringLocation++;
    // Move the RX Buffer pointer
    stringRxLocation++;
  }

  // Return the top of the temporary buffer
  return(SerialUart_TempBufferTop);
} // unsigned char * SerialUart_RxBufferBeforeString(unsigned char serialChannel, unsigned char * searchString)
// </editor-fold>
  