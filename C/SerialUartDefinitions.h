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
//    Currently Supports the Following Microprocessors:
//      PIC16F15376
//
/*******************************************************************************
//
//  Class:        SerialUartDefinitions
//
//  Derived From: N/A
//
//  Description:
//    A common file that supports the Serial UART by defining a set of common
//    names and their microprocessor specific names
//
/*******************************************************************************
//
//  Revision History:
//
//  Rev 0:
//    Initial Code Release; Supports PIC16F15367
//
*******************************************************************************/

/*******************************************************************************
//
//  Serial UART Definition Requirements:
//    SerialUartDefinitions.h Requires the Following Definitions:
//      __UnknownProcessor_ - Place holder to confirm that the system
//          recognizes the PIC
//
//    SerialUart.c Requires the Following Definitions:
//      __SERIAL_UART_BAUDRATE_SPEEDS_ - Array of acceptable (common) baud
//          rates
//      __SERIAL_UART_BAUDRATE_NUMBEROFSPEEDS_ - Number of values in the 
//          __SERIAL_UART_BAUDRATE_SPEEDS_ array
//      __SERIAL_UART_BAUDRATE_MAXALLOWEDERROR_ - Maximum percentage of 
//          error the system will allow as a valid baud rate 5 == > 5% 
//          error or baudRateTarget +/- 5%
//      __SERIAL_UART_MESSAGE_CLEARSCREEN_ - Message to Clear the Screen
//      __SERIAL_UART_MESSAGE_RESIZE_START_ - Resize Message Start
//      __SERIAL_UART_MESSAGE_RESIZE_MIDDLE_ - Resize Message Middle
//      __SERIAL_UART_MESSAGE_RESIZE_END_ - Resize Message End
//      __SERIAL_UART_RESIZE_MINIMIUM_VERTICAL_ - Minimum Vertical Size
//      __SERIAL_UART_RESIZE_MINIMIUM_HORIZONTAL_ - Minimum Horizontal Size
//      __SERIAL_UART_MESSAGE_BACKSPACE_ - Message to Send to a Terminal
//          to Backspace a Character
//      __SERIAL_UART_MESSAGE_BEEP_ - Message to Send to a Terminal to 
//          Produce a BEEP
//      __SERIAL_UART_BAUDRATE_EQUATION_MAX_ - Number of Baud Rate equations
//          currently supported
//      __SERIAL_UART_CHANNELS_ - Total Number UART Channels
//      __SERIAL_UART_INTERRUPT_GLOBAL_ENABLE_ - PIC Global Interrupt Bit
//      __SERIAL_UART_INTERRUPT_PERIPHERAL_ENABLE_ - PIC Peripheral 
//          Interrupt Bit
//      __SERIAL_UART_INTERRUPT_TRANSMITENABLE_1_ - Serial Port 1 Interrupt 
//          Enable Bit
//      __SERIAL_UART_INTERRUPT_TRANSMITFLAG_1_ - Serial Port 1 Transmit 
//          Interrupt Flag Bit
//      __SERIAL_UART_INTERRUPT_RECEIVEENABLE_1_ - Serial Port 1 Interrupt 
//          Enable Bit
//      __SERIAL_UART_INTERRUPT_RECEIVEFLAG_1_ - Serial Port 1 Receive 
//          Interrupt Flag Bit
//      __SERIAL_UART_TRANSMIT_ENABLE_1_ - Serial Port 1 Transmit Enable Bit
//      __SERIAL_UART_TRANSMIT_SHIFT_REGISTER_1_ - Serial Port 1 Transmit 
//          Shift Register
//      __SERIAL_UART_TX_REGISTER_1_ - Serial Port 1 Transmit Data Register
//      __SERIAL_UART_BAUDRATE_1_SYNC_ - Serial Port 1 Baud Rate Sync Bit
//      __SERIAL_UART_BAUDRATE_1_BRG16_ - Serial Port 1 Baud Rate BRG16 Bit
//      __SERIAL_UART_BAUDRATE_1_BRGH_ - Serial Port 1 Baud Rate BRGH Bit
//      __SERIAL_UART_1_SPEN_ - Serial Port 1 SPEN Enable Bit
//      __SERIAL_UART_1_TX9_ - Serial Port 1 TX9 9-bit Data Control Bit
//      __SERIAL_UART_TRANSMIT_1_SCKP_ - Serial Port 1 Transmit Polarity Bit
//      __SERIAL_UART_BAUDRATE_1_SPBRG_ - Serial Port 1 Baud Rate SPBRG
//          Register
//      __SERIAL_UART_RX_REGISTER_1_ - Serial Port 1 Receive Register
//      __SERIAL_UART_RECEIVE_ENABLE_1_ - Serial Port 1 Receive Enable Bit
//      __SERIAL_UART_INTERRUPT_TRANSMITENABLE_2_ - Serial Port 2 Interrupt 
//          Enable Bit
//      __SERIAL_UART_INTERRUPT_TRANSMITFLAG_2_ - Serial Port 2 Transmit 
//          Interrupt Flag Bit
//      __SERIAL_UART_INTERRUPT_RECEIVEENABLE_2_ - Serial Port 2 Interrupt 
//          Enable Bit
//      __SERIAL_UART_INTERRUPT_RECEIVEFLAG_2_ - Serial Port 2 Receive 
//          Interrupt Flag Bit
//      __SERIAL_UART_TRANSMIT_ENABLE_2_ - Serial Port 2 Transmit 
//          Enable Bit
//      __SERIAL_UART_TRANSMIT_SHIFT_REGISTER_2_ - Serial Port 2 Transmit 
//          Shift Register
//      __SERIAL_UART_TX_REGISTER_2_ - Serial Port 2 Transmit Data Register
//      __SERIAL_UART_BAUDRATE_2_SYNC_ - Serial Port 2 Baud Rate Sync Bit
//      __SERIAL_UART_BAUDRATE_2_BRG16_ - Serial Port 2 Baud Rate BRG16 Bit
//      __SERIAL_UART_BAUDRATE_2_BRGH_ - Serial Port 2 Baud Rate BRGH Bit
//      __SERIAL_UART_2_SPEN_ - Serial Port 2 SPEN Enable Bit
//      __SERIAL_UART_2_TX9_ - Serial Port 2 TX9 9-bit Data Control Bit
//      __SERIAL_UART_TRANSMIT_2_SCKP_ - Serial Port 2 Transmit Polarity Bit
//      __SERIAL_UART_BAUDRATE_2_SPBRG_ - Serial Port 2 Baud Rate SPBRG
//          Register
//      __SERIAL_UART_RX_REGISTER_2_ - Serial Port 2 Receive Register
//      __SERIAL_UART_RECEIVE_ENABLE_2_ - Serial Port 2 Receive Enable Bit
//
//    Baud Rate Calculator Requires the Following Definitions per Equation:
//      __SERIAL_UART_BAUDRATE_EQUATION_x_N_ - N Value
//      __SERIAL_UART_BAUDRATE_EQUATION_x_SYNC_ - SYNC Value
//      __SERIAL_UART_BAUDRATE_EQUATION_x_BRG16_ - BRG16 Value
//      __SERIAL_UART_BAUDRATE_EQUATION_x_BRGH_ - BRGH Value
//      __SERIAL_UART_BAUDRATE_EQUATION_x_MAXNVALUE_ - Maximum N Value
//
*******************************************************************************/

/*******************************************************************************
//
//  Adding New PIC to the Definitions:
//    1 ) Setup new #ifdef with new PIC value
//    2 ) Undefine __UnknownProcessor_
//    3 ) Set __SERIAL_UART_CHANNELS_ to the number of valid serial UART ports
//        on the device
//    4 ) Set __SERIAL_UART_EQUATIONS_ to the number of baud rate equations
//        supported by the device
//    5 ) Set __SERIAL_UART_INTERRUPT_GLOBAL_ENABLE_ to be the Global 
//          Interrupt Bit
//    6 ) Set __SERIAL_UART_INTERRUPT_PERIPHERAL_ENABLE_ to be the 
//          Peripheral Interrupt Bit if the Device Has one; Otherwise do 
//          not Define
//    7 ) Set __SERIAL_UART_INTERRUPT_TRANSMITENABLE_1_ to be the serial UART 
//          port 1 Transmit Interrupt Enable Bit
//    8 ) Set __SERIAL_UART_INTERRUPT_TRANSMITFLAG_1_ to be the serial UART 
//          port 1 Transmit Interrupt Flag Bit
//    9 ) Set __SERIAL_UART_INTERRUPT_RECEIVEENABLE_1_ to be the serial UART 
//          port 1 Receive Interrupt Enable Bit
//    10) Set __SERIAL_UART_INTERRUPT_RECEIVEFLAG_1_ to be the serial UART port 
//          1 Receive Interrupt Flag Bit
//    11) Set __SERIAL_UART_TRANSMIT_ENABLE_1_ to be the serial UART port 
//          1 Transmit Enable Bit
//    12) Set __SERIAL_UART_TRANSMIT_SHIFT_REGISTER_1_ to be the serial 
//          UART port 1 Transmit Shift Register Status Bit
//    13) Set __SERIAL_UART_TX_REGISTER_1_ to be the serial UART port 1 
//          Transmit Data Register
//    14) Set __SERIAL_UART_BAUDRATE_1_SYNC_ to be the serial UART port 
//          1 SYNC Bit
//    15) Set __SERIAL_UART_BAUDRATE_1_BRG16_ to be the serial UART port 
//          1 BRG16 Bit
//    16) Set __SERIAL_UART_BAUDRATE_1_BRGH_ to be the serial UART port 
//          1 BRGH Bit
//    17) Set __SERIAL_UART_1_SPEN_ to be the serial UART port 
//          1 SPEN Enable Bit
//    18) Set __SERIAL_UART_1_TX9_ to be the serial UART port 
//          1 TX9 9-bit Data Control Bit
//    19) Set __SERIAL_UART_TRANSMIT_1_SCKP_ to be the serial UART port 
//          1 Transmit Polarity Bit
//    20) Set __SERIAL_UART_BAUDRATE_1_SPBRG_ to be the serial UART port 1 
//          SPBRG Baud Rate Register
//    21) Set __SERIAL_UART_RX_REGISTER_1_ to be the serial UART port 1 
//          Receive Register
//    22) Set __SERIAL_UART_RECEIVE_ENABLE_1_ to be the serial UART port 1 
//          Receive Enable Bit
//    23) Set __SERIAL_UART_INTERRUPT_TRANSMITENABLE_2_ to be the serial UART 
//          port 2 Transmit Interrupt Enable Bit
//    24) Set __SERIAL_UART_INTERRUPT_TRANSMITFLAG_2_ to be the serial UART 
//          port 2 Transmit Interrupt Flag Bit
//    25) Set __SERIAL_UART_INTERRUPT_RECEIVEENABLE_2_ to be the serial UART 
//          port 2 Receive Interrupt Enable Bit
//    26) Set __SERIAL_UART_INTERRUPT_RECEIVEFLAG_2_ to be the serial UART port 
//          2 Receive Interrupt Flag Bit
//    27) Set __SERIAL_UART_TRANSMIT_ENABLE_2_ to be the serial UART port 
//          2 Transmit Enable Bit
//    28) Set __SERIAL_UART_TRANSMIT_SHIFT_REGISTER_2_ to be the serial 
//          UART port 2 Transmit Shift Register Status Bit
//    29) Set __SERIAL_UART_TX_REGISTER_2_ to be the serial UART port 2 
//          Transmit Data Register
//    30) Set __SERIAL_UART_BAUDRATE_2_SYNC_ to be the serial UART port 
//          2 SYNC Bit
//    31) Set __SERIAL_UART_BAUDRATE_2_BRG16_ to be the serial UART port 
//          2 BRG16 Bit
//    32) Set __SERIAL_UART_BAUDRATE_2_BRGH_ to be the serial UART port 
//          2 BRGH Bit
//    33) Set __SERIAL_UART_2_SPEN_ to be the serial UART port 
//          2 SPEN Enable Bit
//    34) Set __SERIAL_UART_2_TX9_ to be the serial UART port 
//          2 TX9 9-bit Data Control Bit
//    35) Set __SERIAL_UART_TRANSMIT_2_SCKP_ to be the serial UART port 
//          2 Transmit Polarity Bit
//    36) Set __SERIAL_UART_BAUDRATE_2_SPBRG_ to be the serial UART port 2 
//          SPBRG Baud Rate Register
//    37) Set __SERIAL_UART_RX_REGISTER_2_ to be the serial UART port 2 
//          Receive Register
//    38) Set __SERIAL_UART_RECEIVE_ENABLE_2_ to be the serial UART port 2 
//          Receive Enable Bit
//    39) Setup the Baud Rate Equations
//
*******************************************************************************/

#ifndef __SerialUartDefinitions_included_
#define __SerialUartDefinitions_included_

// Processor Register Definitions
#include <xc.h>
// Standard Boolean Library
#include <stdbool.h>
// Standard String Library
#include <string.h>

// Place holder to confirm that the system recognizes the PIC
#define __UnknownProcessor_
// Max number of channels DacOutput.c Currently Supports
#define __MAX_SERIAL_UART_CHANNELS_ 8

// Array of acceptable (common) baud rates
#define __SERIAL_UART_BAUDRATE_SPEEDS_ {600, 1200, 2400, 4800, 9600, \
14400, 19200, 38400, 57600, 115200, 230400, 460800, 921600, 1000000}
// Number of values in the __SERIAL_UART_BAUDRATE_SPEEDS_ array
#define __SERIAL_UART_BAUDRATE_NUMBEROFSPEEDS_ 14
// Maximum percentage of error the system will allow as a valid baud rate
//   5 == > 5% error or baudRateTarget +/- 5%
#define __SERIAL_UART_BAUDRATE_MAXALLOWEDERROR_ 5

// Message to Clear the Screen
//   Escape Sequence esc[2J -> Clear Screen
//   Escape Sequence esc[f -> Cursor to Top Left
#define __SERIAL_UART_MESSAGE_CLEARSCREEN_ {0x1B, 0x5B, 0x32, 0x4A, 0x1B, \
0x5B, 0x66, 0x00}

// Message to Resize the Screen
//   Message format: "\e[8;VERTICAL;HORIZONTALt"
//     VERTICAL == Number of Rows
//     HORIZONTAL == Number of Columns
//   To Use: RESIZE_START + VERTICAL + RESIZE_MIDDLE + HORIZONTAL + RESIZE_END
//     Example:
//       Vertical 20 (0x32, 0x30) x Horizontal 100 (0x31, 0x30, 0x30)
//       unsigned char messageResize[] = 
//           {__SERIAL_UART_MESSAGE_RESIZE_START_, 0x32, 0x30,
//           __SERIAL_UART_MESSAGE_RESIZE_MIDDLE_, 0x31, 0x30, 0x30, 
//           __SERIAL_UART_MESSAGE_RESIZE_END_};
//       Final Array: 0x1B, 0x5B, 0x38, 0x3B, 0x32, 0x30, 0x3B, 0x31, 
//          0x30, 0x30, 0x74, 0x00
//       Final ASCII Message: \e[8;20;100t
// Resize Message Start
#define __SERIAL_UART_MESSAGE_RESIZE_START_ {0x1B, 0x5B, 0x38, 0x3B, 0x00}
// Resize Message Middle
#define __SERIAL_UART_MESSAGE_RESIZE_MIDDLE_ {0x3B, 0x00}
// Resize Message End
#define __SERIAL_UART_MESSAGE_RESIZE_END_ {0x74, 0x00}
// Minimum Vertical Size - 5 Rows
#define __SERIAL_UART_RESIZE_MINIMIUM_VERTICAL_ 5
// Minimum Horizontal Size - 20 Columns
#define __SERIAL_UART_RESIZE_MINIMIUM_HORIZONTAL_ 20

// Message to Send to a Terminal to Backspace a Character
#define __SERIAL_UART_MESSAGE_BACKSPACE_ {0x08, 0x20, 0x08, 0x00}
// Message to Send to a Terminal to Produce a BEEP
#define __SERIAL_UART_MESSAGE_BEEP_ {0x07, 0x08, 0x00}

// Number of Baud Rate equations currently supported
//   All Equations are based on: BaudRate = FOSC / (N * (SPBRG + 1))
//   Current Supported Bits are: SYNC, BRG16 and BRGH
//   All N values are either 8-bit (256) or 16-bit (65536) limited
#define __SERIAL_UART_BAUDRATE_EQUATION_MAX_ 4

// PIC16F15376 Support <editor-fold desc="PIC16F15376 Support">
#ifdef _16F15376

  #undef __UnknownProcessor_

  // Total Number UART Channels
  #define __SERIAL_UART_CHANNELS_   2
  // Total Number Baud Rate Equations
  #define __SERIAL_UART_EQUATIONS_   3

  // PIC Global Interrupt Bit
  #define __SERIAL_UART_INTERRUPT_GLOBAL_ENABLE_ INTCONbits.GIE
  // PIC Peripheral Interrupt Bit
  #define __SERIAL_UART_INTERRUPT_PERIPHERAL_ENABLE_ INTCONbits.PEIE

  // Serial Port 1 Transmit Interrupt Enable Bit
  #define __SERIAL_UART_INTERRUPT_TRANSMITENABLE_1_ PIE3bits.TX1IE
  // Serial Port 1 Transmit Interrupt Flag Bit
  #define __SERIAL_UART_INTERRUPT_TRANSMITFLAG_1_ PIR3bits.TX1IF
  // Serial Port 1 Receive Interrupt Enable Bit
  #define __SERIAL_UART_INTERRUPT_RECEIVEENABLE_1_ PIE3bits.RC1IE
  // Serial Port 1 Receive Interrupt Flag Bit
  #define __SERIAL_UART_INTERRUPT_RECEIVEFLAG_1_ PIR3bits.RC1IF
  // Serial Port 1 Transmit Enable Bit
  #define __SERIAL_UART_TRANSMIT_ENABLE_1_ TX1STAbits.TXEN
  // Serial Port 1 Transmit Shift Register
  #define __SERIAL_UART_TRANSMIT_SHIFT_REGISTER_1_ TX1STAbits.TRMT
  // Serial Port 1 Transmit Data Register
  #define __SERIAL_UART_TX_REGISTER_1_ TX1REG
  // Serial Port 1 Baud Rate Sync Bit
  #define __SERIAL_UART_BAUDRATE_1_SYNC_ TX1STAbits.SYNC
  // Serial Port 1 Baud Rate BRG16 Bit
  #define __SERIAL_UART_BAUDRATE_1_BRG16_ BAUD1CONbits.BRG16
  // Serial Port 1 Baud Rate BRGH Bit
  #define __SERIAL_UART_BAUDRATE_1_BRGH_ TX1STAbits.BRGH
  // Serial Port 1 SPEN Enable Bit
  #define __SERIAL_UART_1_SPEN_ RC1STAbits.SPEN
  // Serial Port 1 TX9 9-bit Data Control Bit
  #define __SERIAL_UART_1_TX9_ TX1STAbits.TX9
  // Serial Port 1 Transmit Polarity Bit
  #define __SERIAL_UART_TRANSMIT_1_SCKP_ BAUD1CONbits.SCKP
  // Serial Port 1 Baud Rate SPBRG Register
  #define __SERIAL_UART_BAUDRATE_1_SPBRG_ SP1BRG
  // Serial Port 1 Receive Register
  #define __SERIAL_UART_RX_REGISTER_1_ RC1REG
  // Serial Port 1 Receive Enable Bit
  #define __SERIAL_UART_RECEIVE_ENABLE_1_ RC1STAbits.CREN

  // Serial Port 2 Interrupt Enable Bit
  #define __SERIAL_UART_INTERRUPT_TRANSMITENABLE_2_ PIE3bits.TX2IE
  // Serial Port 2 Transmit Interrupt Flag Bit
  #define __SERIAL_UART_INTERRUPT_TRANSMITFLAG_2_ PIR3bits.TX2IF
  // Serial Port 2 Interrupt Enable Bit
  #define __SERIAL_UART_INTERRUPT_RECEIVEENABLE_2_ PIE3bits.RC2IE
  // Serial Port 2 Receive Interrupt Flag Bit
  #define __SERIAL_UART_INTERRUPT_RECEIVEFLAG_2_ PIR3bits.RC2IF
  // Serial Port 2 Transmit Enable Bit
  #define __SERIAL_UART_TRANSMIT_ENABLE_2_ TX2STAbits.TXEN
  // Serial Port 2 Transmit Shift Register
  #define __SERIAL_UART_TRANSMIT_SHIFT_REGISTER_2_ TX2STAbits.TRMT
  // Serial Port 2 Transmit Data Register
  #define __SERIAL_UART_TX_REGISTER_2_ TX2REG
  // Serial Port 2 Baud Rate Sync Bit
  #define __SERIAL_UART_BAUDRATE_2_SYNC_ TX2STAbits.SYNC
  // Serial Port 2 Baud Rate BRG16 Bit
  #define __SERIAL_UART_BAUDRATE_2_BRG16_ BAUD2CONbits.BRG16
  // Serial Port 2 Baud Rate BRGH Bit
  #define __SERIAL_UART_BAUDRATE_2_BRGH_ TX2STAbits.BRGH
  // Serial Port 2 SPEN Enable Bit
  #define __SERIAL_UART_2_SPEN_ RC2STAbits.SPEN
  // Serial Port 2 TX9 9-bit Data Control Bit
  #define __SERIAL_UART_2_TX9_ TX2STAbits.TX9
  // Serial Port 2 Transmit Polarity Bit
  #define __SERIAL_UART_TRANSMIT_2_SCKP_ BAUD2CONbits.SCKP
  // Serial Port 2 Baud Rate SPBRG Register
  #define __SERIAL_UART_BAUDRATE_2_SPBRG_ SP2BRG
  // Serial Port 2 Receive Register
  #define __SERIAL_UART_RX_REGISTER_2_ RC2REG
  // Serial Port 1 Receive Enable Bit
  #define __SERIAL_UART_RECEIVE_ENABLE_2_ RC2STAbits.CREN

  // Equation 0 Settings
  //   N Value
  #define __SERIAL_UART_BAUDRATE_EQUATION_0_N_ 64
  //   SYNC Value
  #define __SERIAL_UART_BAUDRATE_EQUATION_0_SYNC_ 0
  //   BRG16 Value
  #define __SERIAL_UART_BAUDRATE_EQUATION_0_BRG16_ 0
  //   BRGH Value
  #define __SERIAL_UART_BAUDRATE_EQUATION_0_BRGH_ 0
  //   Maximum N Value
  #define __SERIAL_UART_BAUDRATE_EQUATION_0_MAXNVALUE_ 256

  // Equation 2 Settings
  //   N Value
  #define __SERIAL_UART_BAUDRATE_EQUATION_1_N_ 16
  //   SYNC Value
  #define __SERIAL_UART_BAUDRATE_EQUATION_1_SYNC_ 0
  //   BRG16 Value
  #define __SERIAL_UART_BAUDRATE_EQUATION_1_BRG16_ 1
  //   BRGH Value
  #define __SERIAL_UART_BAUDRATE_EQUATION_1_BRGH_ 0
  //   Maximum N value
  #define __SERIAL_UART_BAUDRATE_EQUATION_1_MAXNVALUE_ 65536

  // Equation 3 Settings
  //   N Value
  #define __SERIAL_UART_BAUDRATE_EQUATION_2_N_ 4
  //   SYNC Value
  #define __SERIAL_UART_BAUDRATE_EQUATION_2_SYNC_ 0
  //   BRG16 Value
  #define __SERIAL_UART_BAUDRATE_EQUATION_2_BRG16_ 1
  //   BRGH Value
  #define __SERIAL_UART_BAUDRATE_EQUATION_2_BRGH_ 1
  //   Maximum N value
  #define __SERIAL_UART_BAUDRATE_EQUATION_2_MAXNVALUE_ 65536

  // No Equation #4

#endif // #ifdef _16F15376
// PIC16F15376 Support </editor-fold>

#ifdef __UnknownProcessor_
  #error Unrecognized PIC Microprocessor
#endif // #ifdef __UnknownProcessor_

#ifndef __SERIAL_UART_CHANNELS_
  #error __SERIAL_UART_CHANNELS_ Must be Defined
#endif // #ifndef __SERIAL_UART_CHANNELS_

#if __SERIAL_UART_CHANNELS_ > __MAX_SERIAL_UART_CHANNELS_
  #error __SERIAL_UART_CHANNELS_ Must be Less Than __MAX_SERIAL_UART_CHANNELS_
#endif // #if __SERIAL_UART_CHANNELS_ > __MAX_SERIAL_UART_CHANNELS_

#ifndef __SERIAL_UART_INTERRUPT_GLOBAL_ENABLE_
  #error __SERIAL_UART_INTERRUPT_GLOBAL_ENABLE_ Must be Defined
#endif // #ifndef __SERIAL_UART_INTERRUPT_GLOBAL_ENABLE_

#ifndef __SERIAL_UART_INTERRUPT_PERIPHERAL_ENABLE_
  #error __SERIAL_UART_INTERRUPT_PERIPHERAL_ENABLE_ Must be Defined
#endif // #ifndef __SERIAL_UART_INTERRUPT_PERIPHERAL_ENABLE_

#ifndef __SERIAL_UART_INTERRUPT_TRANSMITENABLE_1_
  #error __SERIAL_UART_INTERRUPT_TRANSMITENABLE_1_ Must be Defined
#endif // #ifndef __SERIAL_UART_INTERRUPT_TRANSMITENABLE_1_

#ifndef __SERIAL_UART_INTERRUPT_TRANSMITFLAG_1_
  #error __SERIAL_UART_INTERRUPT_TRANSMITFLAG_1_ Must be Defined
#endif // #ifndef __SERIAL_UART_INTERRUPT_TRANSMITFLAG_1_

#ifndef __SERIAL_UART_INTERRUPT_RECEIVEENABLE_1_
  #error __SERIAL_UART_INTERRUPT_RECEIVEENABLE_1_ Must be Defined
#endif // #ifndef __SERIAL_UART_INTERRUPT_RECEIVEENABLE_1_

#ifndef __SERIAL_UART_INTERRUPT_RECEIVEFLAG_1_
  #error __SERIAL_UART_INTERRUPT_RECEIVEFLAG_1_ Must be Defined
#endif // #ifndef __SERIAL_UART_INTERRUPT_RECEIVEFLAG_1_

#ifndef __SERIAL_UART_TRANSMIT_ENABLE_1_
  #error __SERIAL_UART_TRANSMIT_ENABLE_1_ Must be Defined
#endif // #ifndef __SERIAL_UART_TRANSMIT_ENABLE_1_

#ifndef __SERIAL_UART_TRANSMIT_SHIFT_REGISTER_1_
  #error __SERIAL_UART_TRANSMIT_SHIFT_REGISTER_1_ Must be Defined
#endif // #ifndef __SERIAL_UART_TRANSMIT_SHIFT_REGISTER_1_

#ifndef __SERIAL_UART_TX_REGISTER_1_
  #error __SERIAL_UART_TX_REGISTER_1_ Must be Defined
#endif // #ifndef __SERIAL_UART_TX_REGISTER_1_

#ifndef __SERIAL_UART_BAUDRATE_1_SYNC_
  #error __SERIAL_UART_BAUDRATE_1_SYNC_ Must be Defined
#endif // #ifndef __SERIAL_UART_BAUDRATE_1_SYNC_

#ifndef __SERIAL_UART_BAUDRATE_1_BRG16_
  #error __SERIAL_UART_BAUDRATE_1_BRG16_ Must be Defined
#endif // #ifndef __SERIAL_UART_BAUDRATE_1_BRG16_

#ifndef __SERIAL_UART_BAUDRATE_1_BRGH_
  #error __SERIAL_UART_BAUDRATE_1_BRGH_ Must be Defined
#endif // #ifndef __SERIAL_UART_BAUDRATE_1_BRGH_

#ifndef __SERIAL_UART_1_SPEN_
  #error __SERIAL_UART_1_SPEN_ Must be Defined
#endif // #ifndef __SERIAL_UART_1_SPEN_

#ifndef __SERIAL_UART_1_TX9_
  #error __SERIAL_UART_1_TX9_ Must be Defined
#endif // #ifndef __SERIAL_UART_1_TX9_

#ifndef __SERIAL_UART_TRANSMIT_1_SCKP_
  #error __SERIAL_UART_TRANSMIT_1_SCKP_ Must be Defined
#endif // #ifndef __SERIAL_UART_TRANSMIT_1_SCKP_

#ifndef __SERIAL_UART_BAUDRATE_1_SPBRG_
  #error __SERIAL_UART_BAUDRATE_1_SPBRG_ Must be Defined
#endif // #ifndef __SERIAL_UART_BAUDRATE_1_SPBRG_

#ifndef __SERIAL_UART_RX_REGISTER_1_
  #error __SERIAL_UART_RX_REGISTER_1_ Must be Defined
#endif // #ifndef __SERIAL_UART_RX_REGISTER_1_

#ifndef __SERIAL_UART_RECEIVE_ENABLE_1_
  #error __SERIAL_UART_RECEIVE_ENABLE_1_ Must be Defined
#endif // #ifndef __SERIAL_UART_RECEIVE_ENABLE_1_

#if __SERIAL_UART_CHANNELS_ == 2
  #ifndef __SERIAL_UART_INTERRUPT_TRANSMITENABLE_2_
    #error __SERIAL_UART_INTERRUPT_TRANSMITENABLE_2_ Must be Defined
  #endif // #ifndef __SERIAL_UART_INTERRUPT_TRANSMITENABLE_2_

  #ifndef __SERIAL_UART_INTERRUPT_TRANSMITFLAG_2_
    #error __SERIAL_UART_INTERRUPT_TRANSMITFLAG_2_ Must be Defined
  #endif // #ifndef __SERIAL_UART_INTERRUPT_TRANSMITFLAG_2_

  #ifndef __SERIAL_UART_INTERRUPT_RECEIVEENABLE_2_
    #error __SERIAL_UART_INTERRUPT_RECEIVEENABLE_2_ Must be Defined
  #endif // #ifndef __SERIAL_UART_INTERRUPT_RECEIVEENABLE_2_

  #ifndef __SERIAL_UART_INTERRUPT_RECEIVEFLAG_2_
    #error __SERIAL_UART_INTERRUPT_RECEIVEFLAG_2_ Must be Defined
  #endif // #ifndef __SERIAL_UART_INTERRUPT_RECEIVEFLAG_2_

  #ifndef __SERIAL_UART_TRANSMIT_ENABLE_2_
    #error __SERIAL_UART_TRANSMIT_ENABLE_2_ Must be Defined
  #endif // #ifndef __SERIAL_UART_TRANSMIT_ENABLE_2_

  #ifndef __SERIAL_UART_TRANSMIT_SHIFT_REGISTER_2_
    #error __SERIAL_UART_TRANSMIT_SHIFT_REGISTER_2_ Must be Defined
  #endif // #ifndef __SERIAL_UART_TRANSMIT_SHIFT_REGISTER_2_

  #ifndef __SERIAL_UART_TX_REGISTER_2_
    #error __SERIAL_UART_TX_REGISTER_2_ Must be Defined
  #endif // #ifndef __SERIAL_UART_TX_REGISTER_2_

  #ifndef __SERIAL_UART_BAUDRATE_2_SYNC_
    #error __SERIAL_UART_BAUDRATE_2_SYNC_ Must be Defined
  #endif // #ifndef __SERIAL_UART_BAUDRATE_2_SYNC_

  #ifndef __SERIAL_UART_BAUDRATE_2_BRG16_
    #error __SERIAL_UART_BAUDRATE_2_BRG16_ Must be Defined
  #endif // #ifndef __SERIAL_UART_BAUDRATE_2_BRG16_

  #ifndef __SERIAL_UART_BAUDRATE_2_BRGH_
    #error __SERIAL_UART_BAUDRATE_2_BRGH_ Must be Defined
  #endif // #ifndef __SERIAL_UART_BAUDRATE_2_BRGH_

  #ifndef __SERIAL_UART_2_SPEN_
    #error __SERIAL_UART_2_SPEN_ Must be Defined
  #endif // #ifndef __SERIAL_UART_2_SPEN_

  #ifndef __SERIAL_UART_2_TX9_
    #error __SERIAL_UART_2_TX9_ Must be Defined
  #endif // #ifndef __SERIAL_UART_2_TX9_

  #ifndef __SERIAL_UART_TRANSMIT_2_SCKP_
    #error __SERIAL_UART_TRANSMIT_2_SCKP_ Must be Defined
  #endif // #ifndef __SERIAL_UART_TRANSMIT_2_SCKP_

  #ifndef __SERIAL_UART_BAUDRATE_2_SPBRG_
    #error __SERIAL_UART_BAUDRATE_2_SPBRG_ Must be Defined
  #endif // #ifndef __SERIAL_UART_BAUDRATE_2_SPBRG_

  #ifndef __SERIAL_UART_RX_REGISTER_2_
    #error __SERIAL_UART_RX_REGISTER_2_ Must be Defined
  #endif // #ifndef __SERIAL_UART_RX_REGISTER_2_

  #ifndef __SERIAL_UART_RECEIVE_ENABLE_2_
    #error __SERIAL_UART_RECEIVE_ENABLE_2_ Must be Defined
  #endif // #ifndef __SERIAL_UART_RECEIVE_ENABLE_2_
#endif // #if __SERIAL_UART_CHANNELS_ == 2

#ifndef __SERIAL_UART_EQUATIONS_
  #error __SERIAL_UART_EQUATIONS_ Must be Defined
#endif // #ifndef __SERIAL_UART_EQUATIONS_

#if __SERIAL_UART_EQUATIONS_ > __SERIAL_UART_BAUDRATE_EQUATION_MAX_
  #error __SERIAL_UART_EQUATIONS_ Must be Less Than \
__SERIAL_UART_BAUDRATE_EQUATION_MAX_
#endif // #if __SERIAL_UART_EQUATIONS_ > __SERIAL_UART_BAUDRATE_EQUATION_MAX_

#ifndef __SERIAL_UART_BAUDRATE_EQUATION_0_N_
  #error __SERIAL_UART_BAUDRATE_EQUATION_0_N_ Must be Defined
#endif // #ifndef __SERIAL_UART_BAUDRATE_EQUATION_0_N_

#ifndef __SERIAL_UART_BAUDRATE_EQUATION_0_SYNC_
  #error __SERIAL_UART_BAUDRATE_EQUATION_0_SYNC_ Must be Defined
#endif // #ifndef __SERIAL_UART_BAUDRATE_EQUATION_0_SYNC_

#ifndef __SERIAL_UART_BAUDRATE_EQUATION_0_BRG16_
  #error __SERIAL_UART_BAUDRATE_EQUATION_0_BRG16_ Must be Defined
#endif // #ifndef __SERIAL_UART_BAUDRATE_EQUATION_0_BRG16_

#ifndef __SERIAL_UART_BAUDRATE_EQUATION_0_BRGH_
  #error __SERIAL_UART_BAUDRATE_EQUATION_0_BRGH_ Must be Defined
#endif // #ifndef __SERIAL_UART_BAUDRATE_EQUATION_0_BRGH_

#ifndef __SERIAL_UART_BAUDRATE_EQUATION_0_MAXNVALUE_
  #error __SERIAL_UART_BAUDRATE_EQUATION_0_MAXNVALUE_ Must be Defined
#endif // #ifndef __SERIAL_UART_BAUDRATE_EQUATION_0_MAXNVALUE_

#ifdef __SERIAL_UART_BAUDRATE_EQUATION_1_N_
  #ifndef __SERIAL_UART_BAUDRATE_EQUATION_1_SYNC_
    #error __SERIAL_UART_BAUDRATE_EQUATION_1_SYNC_ Must be Defined
  #endif // #ifndef __SERIAL_UART_BAUDRATE_EQUATION_1_SYNC_

  #ifndef __SERIAL_UART_BAUDRATE_EQUATION_1_BRG16_
    #error __SERIAL_UART_BAUDRATE_EQUATION_1_BRG16_ Must be Defined
  #endif // #ifndef __SERIAL_UART_BAUDRATE_EQUATION_1_BRG16_

  #ifndef __SERIAL_UART_BAUDRATE_EQUATION_1_BRGH_
    #error __SERIAL_UART_BAUDRATE_EQUATION_1_BRGH_ Must be Defined
  #endif // #ifndef __SERIAL_UART_BAUDRATE_EQUATION_1_BRGH_

  #ifndef __SERIAL_UART_BAUDRATE_EQUATION_1_MAXNVALUE_
    #error __SERIAL_UART_BAUDRATE_EQUATION_1_MAXNVALUE_ Must be Defined
  #endif // #ifndef __SERIAL_UART_BAUDRATE_EQUATION_1_MAXNVALUE_
#endif // #ifdef __SERIAL_UART_BAUDRATE_EQUATION_1_N_

#ifdef __SERIAL_UART_BAUDRATE_EQUATION_2_N_
  #ifndef __SERIAL_UART_BAUDRATE_EQUATION_2_SYNC_
    #error __SERIAL_UART_BAUDRATE_EQUATION_2_SYNC_ Must be Defined
  #endif // #ifndef __SERIAL_UART_BAUDRATE_EQUATION_2_SYNC_

  #ifndef __SERIAL_UART_BAUDRATE_EQUATION_2_BRG16_
    #error __SERIAL_UART_BAUDRATE_EQUATION_2_BRG16_ Must be Defined
  #endif // #ifndef __SERIAL_UART_BAUDRATE_EQUATION_2_BRG16_

  #ifndef __SERIAL_UART_BAUDRATE_EQUATION_2_BRGH_
    #error __SERIAL_UART_BAUDRATE_EQUATION_2_BRGH_ Must be Defined
  #endif // #ifndef __SERIAL_UART_BAUDRATE_EQUATION_2_BRGH_

  #ifndef __SERIAL_UART_BAUDRATE_EQUATION_2_MAXNVALUE_
    #error __SERIAL_UART_BAUDRATE_EQUATION_2_MAXNVALUE_ Must be Defined
  #endif // #ifndef __SERIAL_UART_BAUDRATE_EQUATION_2_MAXNVALUE_
#endif // #ifdef __SERIAL_UART_BAUDRATE_EQUATION_2_N_

#ifdef __SERIAL_UART_BAUDRATE_EQUATION_3_N_
  #ifndef __SERIAL_UART_BAUDRATE_EQUATION_3_SYNC_
    #error __SERIAL_UART_BAUDRATE_EQUATION_3_SYNC_ Must be Defined
  #endif // #ifndef __SERIAL_UART_BAUDRATE_EQUATION_3_SYNC_

  #ifndef __SERIAL_UART_BAUDRATE_EQUATION_3_BRG16_
    #error __SERIAL_UART_BAUDRATE_EQUATION_3_BRG16_ Must be Defined
  #endif // #ifndef __SERIAL_UART_BAUDRATE_EQUATION_3_BRG16_

  #ifndef __SERIAL_UART_BAUDRATE_EQUATION_3_BRGH_
    #error __SERIAL_UART_BAUDRATE_EQUATION_3_BRGH_ Must be Defined
  #endif // #ifndef __SERIAL_UART_BAUDRATE_EQUATION_3_BRGH_

  #ifndef __SERIAL_UART_BAUDRATE_EQUATION_3_MAXNVALUE_
    #error __SERIAL_UART_BAUDRATE_EQUATION_3_MAXNVALUE_ Must be Defined
  #endif // #ifndef __SERIAL_UART_BAUDRATE_EQUATION_3_MAXNVALUE_
#endif // #ifdef __SERIAL_UART_BAUDRATE_EQUATION_3_N_

#endif // __SerialUartDefinitions_included_
