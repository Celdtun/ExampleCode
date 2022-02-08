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
//    Initial Code Release; Supports PIC16F15367
//
*******************************************************************************/

#ifndef __SerialUart_included_
#define __SerialUart_included_

// Common Definitions for the Serial UART
#include "SerialUartDefinitions.h"

// Include Math Library Functions
#include <math.h>
// Include NULL Macro
#include <stddef.h>
// Include Standard Library Functions
#include <stdlib.h>
// Include String Functions
#include <string.h>

#if !defined(__SERIAL_UART_PORT_1_ENABLE_) && \
    !defined(__SERIAL_UART_PORT_2_ENABLE_)
  #error __SERIAL_UART_PORT_1_ENABLE_ or __SERIAL_UART_PORT_2_ENABLE_ \
      Must be Defined; Add __SERIAL_UART_PORT_1_ENABLE_ to Enable Serial \
      UART Port 1 or __SERIAL_UART_PORT_2_ENABLE_ to Enable Serial UART \
      Port 2 in Compiler Build Options
#endif // #if !defined(__SERIAL_UART_PORT_1_ENABLE_) && !defined(__SERIAL_UART_PORT_2_ENABLE_)

#if defined(__SERIAL_UART_PORT_2_ENABLE_) && __SERIAL_UART_CHANNELS_ != 2
  #error PIC Microcontroller Does Not Support 2 Serial UART Ports; \
      Remove __SERIAL_UART_PORT_2_ENABLE_ from the Compiler Build Options
#endif // #if defined(__SERIAL_UART_PORT_2_ENABLE_) && __SERIAL_UART_CHANNELS_ != 2

#if !defined( __SERIAL_UART_BUFFER_DEPTH_)
  #error __SERIAL_UART_BUFFER_DEPTH_ Not Defined; Define as \
      "__SERIAL_UART_BUFFER_DEPTH_=##" in Compiler Build Options
#endif // #if !defined( __SERIAL_UART_BUFFER_DEPTH_)

#if __SERIAL_UART_BUFFER_DEPTH_ < 24
  #error __SERIAL_UART_BUFFER_DEPTH_ Must be at Least 24 Characters Deep
#endif // #if __SERIAL_UART_BUFFER_DEPTH_ < 24

/**
To set all pointers to their respective buffers, flush each buffer 
to ensure it is empty, initialize the temporary buffer if it isn't already
and to set the baud rate of the specified channel
 
@param  (unsigned char) serialChannel: <br>
        &emsp &nbsp Serial port to modify

@param  (unsigned long) systemFrequency: <br>
        &emsp &nbsp System FOSC in Hz; 1MHz would be 1000000

@param  (unsigned long) baudRateTarget: <br>
        &emsp &nbsp Desired serial UART baud rate in bits per second; <br>
        &emsp &emsp &nbsp 115.2kbps would be 115200

@return (unsigned long): <br>
        &emsp &nbsp Actual calculated baud rate with the lowest <br>
        &emsp &emsp &nbsp error <br>
        &emsp &nbsp If it is not possible to achieve the desired baud rate <br>
        &emsp &emsp &nbsp given the system frequency, then 0xFFFFFFFF will <br>
        &emsp &emsp &nbsp be returned in place of the calculated baud rate

@Exceptions None
*/
unsigned long SerialUart_InitilizePort(unsigned char serialChannel, 
    unsigned long systemFrequency, unsigned long baudRateTarget);
/**
To set all pointers to their respective buffers and flush each buffer 
to ensure it is empty
 
@param  (unsigned char) outputChannel: <br>
        &emsp &nbsp Analog output channel to set

@param  (unsigned char *) bufferTop: <br>
        &emsp &nbsp Pointer to the top of the buffer to be flushed

@return (unsigned char *) bufferTop: <br>
        &emsp &nbsp Pointer to flushed buffer

@Exceptions None
*/
unsigned char * SerialUart_FlushBuffer(unsigned char *bufferTop);
/**
To return the boolean value of the specified serial port's echo value
 
@param  (unsigned char) serialChannel: <br>
        &emsp &nbsp Serial port to check

@return (bool): <br>
        &emsp &nbsp The SerialUart_EnableEcho_x value for the specified port

@Exceptions None
*/
bool SerialUart_GetEcho(unsigned char serialChannel);
/**
To set the boolean value of the specified serial port's echo value
 
@param  (unsigned char) serialChannel: <br>
        &emsp &nbsp Serial port to check

@param  (bool) enableEcho: <br>
        &emsp &nbsp New echo value

@return None

@Exceptions None
*/
void SerialUart_SetEcho(unsigned char serialChannel, bool enableEcho);
/**
To wait for the current byte to be transmitted on the specified channel
 
@param  (unsigned char) outputChannel: <br>
        &emsp &nbsp Analog output channel to set

@return None

@Exceptions None
*/
void SerialUart_WaitForTransmitToComplete(unsigned char serialChannel);
/**
To add an unsigned char array (String) to the specified TX Buffer; If
the String is too long to fit into the Temporary Buffer, the method 
will return false.  If the remaining message length in the TX Buffer 
plus the message length is too big to fit into the Temporary Buffer, 
disable all Interrupts while adding the String to the TX Buffer 
 
@param  (unsigned char) serialChannel: <br>
        &emsp &nbsp Serial port to check

@param  (unsigned char *) serialString: <br>
        &emsp &nbsp (unsigned char array) to add to the buffer

@param  (bool) serialWait: <br>
        &emsp &nbsp If the method is to send the entire buffer before returning

@return (bool): <br>
        &emsp &nbsp true if the String was successfully added to the TX buffer
        &emsp &nbsp false if the String was not added to the TX buffer

@Exceptions None
*/
bool SerialUart_TransmitString(unsigned char serialChannel, unsigned char
    *serialString, bool serialWait);
/**
To convert a const unsigned char array (const String) to an unsigned 
char array (String) and pass it on to SerialUart_TransmitString()
 
@param  (unsigned char) serialChannel: <br>
        &emsp &nbsp Serial port to check

@param  (const unsigned char *) serialString: <br>
        &emsp &nbsp (const unsigned char array) to add to the buffer

@param  (bool) serialWait: <br>
        &emsp &nbsp If the method is to send the entire buffer before returning

@return (bool): <br>
        &emsp &nbsp true if the String was successfully added to the TX buffer
        &emsp &nbsp false if the String was not added to the TX buffer

@Exceptions None
*/
bool SerialUart_TransmitConstString(unsigned char serialChannel, const
    unsigned char *serialString, bool serialWait);
/**
To add a single character to the TX buffer; If the character is too 
long to fit into the TX Buffer, the method will transmit one character 
to make room.  Note - The method will disable all Interrupts while 
adding the String to the TX Buffer
 
@param  (unsigned char) serialChannel: <br>
        &emsp &nbsp Serial port to check

@param  (unsigned char) serialCharacter: <br>
        &emsp &nbsp Character to Add to the Buffer

@param  (bool) serialWait: <br>
        &emsp &nbsp If the method is to send the entire buffer before returning

@return (bool): <br>
        &emsp &nbsp true if the String was successfully added to the TX buffer
        &emsp &nbsp false if the String was not added to the TX buffer

@Exceptions None
*/
bool SerialUart_TransmitCharacter(unsigned char serialChannel, unsigned char
    serialCharacter, bool serialWait);
/**
To convert a const unsigned char character to an unsigned char character 
and pass it on to SerialUart_TransmitCharacter()
 
@param  (unsigned char) serialChannel: <br>
        &emsp &nbsp Serial port to check

@param  (unsigned char) serialCharacter: <br>
        &emsp &nbsp Character to Add to the Buffer

@param  (bool) serialWait: <br>
        &emsp &nbsp If the method is to send the entire buffer before returning

@return (bool): <br>
        &emsp &nbsp true if the String was successfully added to the TX buffer
        &emsp &nbsp false if the String was not added to the TX buffer

@Exceptions None
*/
bool SerialUart_TransmitConstCharacter(unsigned char serialChannel, const
    unsigned char serialCharacter, bool serialWait);
/**
To send the next character in the specified channel's TX buffer and, if 
serialWait is true, empty out the remaining message in the buffer
 
@param  (unsigned char) serialChannel: <br>
        &emsp &nbsp Serial port to check

@param  (bool) serialWait: <br>
        &emsp &nbsp If the method is to send the entire buffer before returning

@return (bool): <br>
        &emsp &nbsp true if the data was successfully transmitted
        &emsp &nbsp false if the data was not successfully transmitted

@Exceptions None
*/
bool SerialUart_SendCharacter(unsigned char serialChannel, bool serialWait);
/**
To confirm that there is room in the specified channel's RX buffer 
and to add the character to the end;  If echo is enabled, then the 
method will also send the character to the TX buff to be echoed back
 
@param  (unsigned char) serialChannel: <br>
        &emsp &nbsp Serial port to check

@param  (unsigned char) serialInput: <br>
        &emsp &nbsp Character to add to the RX Buffer

@return (bool): <br>
        &emsp &nbsp true if the Character was successfully added to the <br>
        &emsp &emsp &nbsp RX buffer
        &emsp &nbsp false if the Character was not added to the RX buffer

@Exceptions None
*/
bool SerialUart_AddCharacterToRxBuffer(unsigned char serialChannel, unsigned
    char serialInput);
/**
To confirm that there is a character in the RX buffer that can be 
removed, to move back the working pointer and to set that data location 
to NULL
 
@param  (unsigned char) serialChannel: <br>
        &emsp &nbsp Serial port to modify

@return (bool): <br>
        &emsp &nbsp true if the Character was successfully removed from the <br>
        &emsp &emsp &nbsp RX buffer
        &emsp &nbsp false if there was no character to remove or an unknown <br>
        &emsp &emsp &nbsp channel

@Exceptions None
*/
bool SerialUart_RxBufferRemoveLastCharacter(unsigned char serialChannel);
/**
To confirm that the buffer has at least one character and to return 
that character.  If the RX buffer does not have a character, then 
0x00 is returned.
 
@param  (unsigned char) serialChannel: <br>
        &emsp &nbsp Serial port to modify

@return (unsigned char): <br>
        &emsp &nbsp 0x00 if the buffer does not have a previous <br>
        &emsp &emsp &nbsp character, otherwise the method will return <br>
        &emsp &emsp &nbsp the value of the last character

@Exceptions None
*/
unsigned char SerialUart_GetLastRxBufferCharacter(unsigned char serialChannel);
/**
To flush the specified serial UART RX buffer and return the working 
pointer to the top
 
@param  (unsigned char) serialChannel: <br>
        &emsp &nbsp SSerial port to modify

@return (bool): <br>
        &emsp &nbsp true if the RX Buffer was successfully flushed
        &emsp &nbsp false if an unknown serial channel is specified

@Exceptions None
*/
bool SerialUart_ResetRxBuffer(unsigned char serialChannel);
/**
To remove the last character from the specified RX buffer and to send the 
backspace command String to the host terminal
 
@param  (unsigned char) serialChannel: <br>
        &emsp &nbsp Serial port to modify

@param  (bool) serialWait: <br>
        &emsp &nbsp If the method is to send the entire buffer before returning

@return (bool): <br>
        &emsp &nbsp true if the command was successful
        &emsp &nbsp false if an error occurred

@Exceptions None
*/
bool SerialUart_Backspace(unsigned char serialChannel, bool serialWait);
/**
To clear the specified VT100 compliant terminal of all data
 
@param  (unsigned char) serialChannel: <br>
        &emsp &nbsp Serial port to modify

@param  (bool) serialWait: <br>
        &emsp &nbsp If the method is to send the entire buffer before returning

@return (bool): <br>
        &emsp &nbsp true if the command was successful
        &emsp &nbsp false if an error occurred

@Exceptions None
*/
bool SerialUart_ClearScreen(unsigned char serialChannel, bool serialWait);
/**
To resize the specified VT100 terminal window to the specified row and 
column settings
 
@param  (unsigned char) serialChannel: <br>
        &emsp &nbsp Serial port to modify

@param  (unsigned int) vertical: <br>
        &emsp &nbsp Number of Rows for the screen

@param  (unsigned int) horizontal: <br>
        &emsp &nbsp Number of Columns for the screen

@param  (bool) serialWait: <br>
        &emsp &nbsp If the method is to send the entire buffer before returning

@return (bool): <br>
        &emsp &nbsp true if the command was successful
        &emsp &nbsp false if an error occurred

@Exceptions None
*/
bool SerialUart_ResizeScreen(unsigned char serialChannel, unsigned int
    vertical, unsigned int horizontal, bool serialWait);
/**
To sound a beep on the specified VT100 compliant terminal
 
@param  (unsigned char) serialChannel: <br>
        &emsp &nbsp Serial port to modify

@return (bool): <br>
        &emsp &nbsp true if the command was successful
        &emsp &nbsp false if an error occurred

@Exceptions None
*/
bool SerialUart_Beep(unsigned char serialChannel);
/**
To set the baud rate of a serial port to a desired speed
 
@param  (unsigned char) serialChannel: <br>
        &emsp &nbsp Serial port to modify

@param  (unsigned long) systemFrequency: <br>
        &emsp &nbsp System FOSC in Hz; 1MHz would be 1000000

@param  (unsigned long) baudRateTarget: <br>
        &emsp &nbsp Desired serial UART baud rate in bits per second; <br>
        &emsp &emsp &nbsp 115.2kbps would be 115200

@return (unsigned long): <br>
        &emsp &nbsp Actual calculated baud rate with the lowest <br>
        &emsp &emsp &nbsp error <br>
        &emsp &nbsp If it is not possible to achieve the desired baud rate <br>
        &emsp &emsp &nbsp given the system frequency, then 0xFFFFFFFF will <br>
        &emsp &emsp &nbsp be returned in place of the calculated baud rate

@Exceptions None
*/
unsigned long SerialUart_SetBaudRate(unsigned char serialChannel, unsigned  
    long systemFrequency, unsigned long baudRateTarget);
/**
To confirm that the target baud rate is a commonly used baud rate
 
@param  (unsigned long) baudRateTarget: <br>
        &emsp &nbsp Desired serial UART baud rate in bits per second; <br>
        &emsp &emsp &nbsp 115.2kbps would be 115200

@return (bool): <br>
        &emsp &nbsp true if the baud rate is a commonly used baud rate
        &emsp &nbsp false if the baud rate is not a commonly used baud rate

@Exceptions None
*/
bool SerialUart_ConfirmTargetBaudRate(unsigned long baudRateTarget);
/**
To set all bits to enable the specified Serial UART port for asynchronous
operation
 
@param  (unsigned char) serialChannel: <br>
        &emsp &nbsp Serial port to modify

@param  (bool) enableInterrupts: <br>
        &emsp &nbsp If the Interrupts are to be enabled

@return (bool): <br>
        &emsp &nbsp true if the port was correctly setup
        &emsp &nbsp false if the port channel was not recognized

@Exceptions None
*/
bool SerialUart_EnablePort(unsigned char serialChannel, bool enableInterrupts);
/**
To search the specified RX buffer for the specified character array.  If the
array is in the RX buffer, the method will return true; otherwise the method
returns false.
 
@param  (unsigned char) serialChannel: <br>
        &emsp &nbsp Serial port to modify

@param  (unsigned char) searchString: <br>
        &emsp &nbsp Character array to look for

@return (bool): <br>
        &emsp &nbsp true if search string was in the buffer
        &emsp &nbsp false if search string was not in the buffer

@Exceptions None
*/
bool SerialUart_RxContainsString(unsigned char serialChannel, unsigned char *
    searchString);
/**
To search the specified RX buffer for the specified character array.  If the 
array is in the RX buffer, the method will move all preceeding data in the RX
buffer to the Temp Buffer and move all remaining data to the front of the RX
buffer.  The method will then return a pointer to the top of the Temp
Buffer.  If the array is not in the RX buffer, the method returns NULL.
 
@param  (unsigned char) serialChannel: <br>
        &emsp &nbsp Serial port to modify

@param  (unsigned char) searchString: <br>
        &emsp &nbsp Character array to look for

@return (bool): <br>
        &emsp &nbsp Pointer to the top of the Temp buffer if search <br>
        &emsp &emsp &nbsp string was in the buffer
        &emsp &nbsp NULL if search string was not in the buffer

@Exceptions None
*/
unsigned char * SerialUart_RxBufferBeforeString(unsigned char serialChannel, 
    unsigned char * searchString);

#endif // #ifndef __SerialUart_included_
