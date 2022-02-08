/*******************************************************************************
//  Class:        Sk6812rgbwLed
//  Package:      Sk6812rgbwLED
//
//  Author:       Chad Graham <graham.chad1@gmail.com>
//  Date:         May 1, 2018
//
//  IDE Tool:     Netbeans 8.2
//  Java Version: Java JDK 1.8
//  Language:     Java
//
//  Hardware Platform:
//    Raspberry Pi 3 Model B V1.2
//
/*******************************************************************************
//
//  Revision History:
//
//  Rev 0.0:
//    Initial Code Release
//
*******************************************************************************/

package Sk6812rgbwLED;

// <editor-fold defaultstate="collapsed" desc="File Imports">
import CommonFunctions.ColorRgbw;
import static java.lang.Boolean.*;
// </editor-fold>

/**
 * Container class for RGB brightness values
 * @author Chad Graham
 * @version 0.0
 */
public class Sk6812rgbwLed {

  // <editor-fold defaultstate="collapsed" desc="Public Class Variables">
  // </editor-fold>

  // <editor-fold defaultstate="collapsed" desc="Private Class Variables">
  /**
   * RGBW Container for the LED's Colors; 0 - 255 Max
   */
  private ColorRgbw color;
  /**
   * General Enable for the LEDs; FALSE will Output only '0's for SPI Bus
   */
  private boolean enable;
  /**
   * SPI Baud Rate
   * <p>
   * Bit Period == 1.25us <br>
   * &emsp &nbsp 1:4 Ratio Speed is 3.2MHz (0.3125us) <br>
   * &emsp &nbsp &nbsp 32bits Data == 128 clocks == 16Bytes Data Stream  <br>
   * &emsp &nbsp 1:8 Ratio Speed is 6.4MHz (0.1563us)  <br>
   * &emsp &nbsp &nbsp 64bits Data == 256 clocks == 32Bytes Data Stream
   */
  private final int SK6812RGBW_SPISPEED = 3300000;
  /**
   * Number of Command Bytes for a Given Baud Rate
   */
  private final int DATASTREAM_SIZE = 16;
  /**
   * SPI Low Bit Value for a Given Baud Rate
   * <p>
   * Low == 0.3125us @ '1', 0.9375us @ '0' <br>
   * &emsp &nbsp Low @ 3.2MHz == 0b 1000 <br>
   * &emsp &nbsp Low @ 6.4MHz == 0b 1100 0000
   */
  private final byte LOW = (byte) 0x08;
  /**
   * SPI High Bit Value for a Given Baud Rate
   * <p>
   * High == 0.6205us @ '1', 0.6250us @ '0' <br>
   * &emsp &nbsp High @ 3.2MHz == 0b 1100 <br>
   * &emsp &nbsp High @ 6.4MHz == 0b 1111 0000
   */
  private final byte HIGH = (byte) 0x0C;
  /**
   * Array Containing the Appropriate Number of Bytes to Reset the SPI Bus
   * <p>
   * Reset == 80us Continuous LOW <br>
   * &emsp &nbsp Reset @ 3.2MHz == 256 Ticks (32 Bytes) <br>
   * &emsp &nbsp Reset @ 6.4MHz == 512 Ticks (64 Bytes)
   */
  private final byte[] RESET = {
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  };
  /**
   * Number of bytes in Reset Message
   */
  private final int RESETMESSAGE_SIZE = 32;
  // </editor-fold>

  // <editor-fold defaultstate="collapsed" desc="public Sk6812rgbwLed()">
  /**
   * Default Constructor for the SK6812RGBW LEDs
   * <p>
   * Default Values: <br>
   * &emsp &nbsp color == Black <br>
   * &emsp &nbsp white == 0 <br>
   * &emsp &nbsp enable == FALSE
   */
  public Sk6812rgbwLed() {
    
    this.color = new ColorRgbw(0, 0, 0, 0);
    this.enable = FALSE;

  } // public Sk6812rgbwLed()
  // </editor-fold>
  // <editor-fold defaultstate="collapsed" desc="public Sk6812rgbwLed(boolean enable, ColorRgbw rgbwColor)">
  /**
   * Common Constructor for SK6812RGBW 
   *
   * @param enable General Enable for the LEDs; FALSE will <br>
   * &emsp &nbsp Output only '0's for SPI Bus
   *
   * @param RgbColor Initial RGBW for the LED's Colors; <br>
   * &emsp &nbsp  0 - 255 Max
   */
  public Sk6812rgbwLed(boolean enable, ColorRgbw rgbwColor) {
    
    this.enable = enable;
    this.color = new ColorRgbw(rgbwColor.Red, rgbwColor.Green, rgbwColor.Blue,
        rgbwColor.White);
  } // public Sk6812rgbwLed(boolean enable, ColorRgbw rgbwColor)
  // </editor-fold>
  // <editor-fold defaultstate="collapsed" desc="public Sk6812rgbwLed(boolean enable, int red, int green, int blue, int white)">
  /**
   * Common Constructor for SK6812RGBW 
   *
   * @param enable General Enable for the LEDs; FALSE will <br>
   * &emsp &nbsp Output only '0's for SPI Bus
   *
   * @param red Brightness of the Red LED; 0 - 255 Max
   *
   * @param green Brightness of the Red LED; 0 - 255 Max
   *
   * @param blue Brightness of the Blue LED; 0 - 255 Max
   *
   * @param white Brightness of the White LED; 0 - 255 Max
   */
  public Sk6812rgbwLed(boolean enable, int red, int green, int blue, 
      int white) {
    
    this.enable = enable;
    this.color = new ColorRgbw(red, green, blue, white);
  } // public Sk6812rgbwLed(boolean enable, int red, int green, int blue, int white)
  // </editor-fold>
  // <editor-fold defaultstate="collapsed" desc="public void Sk6812rgbwLed_SetEnable(boolean enable)">
  /**
   * To set the LED Enable to the input value
   *
   * @param enable General Enable for the LEDs; FALSE will <br>
   * &emsp &nbsp Output only '0's for SPI Bus
   */
  public void Sk6812rgbwLed_SetEnable(boolean enable) {
    this.enable = enable;
  } // public void Sk6812rgbwLed_SetEnable(boolean enable)
  // </editor-fold>
  // <editor-fold defaultstate="collapsed" desc="public boolean Sk6812rgbwLed_GetEnable()">
  /**
   * To return the LED Enable value
   *
   * @return Value of the LED Enable Setting
   */
  public boolean Sk6812rgbwLed_GetEnable() {
    return(this.enable);
  } // public boolean Sk6812rgbwLed_GetEnable()
  // </editor-fold>
  // <editor-fold defaultstate="collapsed" desc="public void Sk6812rgbwLed_SetColor(ColorRgbw color)">
  /**
   * To set the LED RGB color
   *
   * @param color New RGB value for the LED's Colors; <br>
   * &emsp &nbsp  0 - 255 Max
   */
  public void Sk6812rgbwLed_SetColor(ColorRgbw color) {
    this.color = color;
  } // public void Sk6812rgbwLed_SetColor(ColorRgbw color)
  // </editor-fold>
  // <editor-fold defaultstate="collapsed" desc="public ColorRgbw Sk6812rgbwLed_GetColor()">
  /**
   * To return the RGB values of the LED
   *
   * @return RGB Color Values
   */
  public ColorRgbw Sk6812rgbwLed_GetColor() {
    return(this.color);
  } // public ColorRgbw Sk6812rgbwLed_GetColor()
  // </editor-fold>
  // <editor-fold defaultstate="collapsed" desc="public void Sk6812rgbwLed_SetRed(int red)">
  /**
   * To set the Red LED Color Value
   *
   * @param red Brightness of the Red LED; 0 - 255 Max
   */
  public void Sk6812rgbwLed_SetRed(int red) {
    this.color = new ColorRgbw(red, this.color.Green, this.color.Blue,
        this.color.White);
  } // public void Sk6812rgbwLed_SetRed(int red)
  // </editor-fold>
  // <editor-fold defaultstate="collapsed" desc="public int Sk6812rgbwLed_GetRed()">
  /**
   * To return the Red LED value
   *
   * @return Value of the Red LED
   */
  public int Sk6812rgbwLed_GetRed() {
    return(this.color.Red);
  } // public int Sk6812rgbwLed_GetRed()
  // </editor-fold>
  // <editor-fold defaultstate="collapsed" desc="public void Sk6812rgbwLed_SetGreen(int green)">
  /**
   * To set the Green LED Color Value
   *
   * @param green Brightness of the Green LED; 0 - 255 Max
   */
  public void Sk6812rgbwLed_SetGreen(int green) {
    this.color = new ColorRgbw(this.color.Red, green, this.color.Blue,
        this.color.White);
  } // public void Sk6812rgbwLed_SetGreen(int green)
  // </editor-fold>
  // <editor-fold defaultstate="collapsed" desc="public int Sk6812rgbwLed_GetGreen()">
  /**
   * To return the Green LED value
   *
   * @return Value of the Green LED
   */
  public int Sk6812rgbwLed_GetGreen() {
    return(this.color.Green);
  } // public int Sk6812rgbwLed_GetGreen()
  // </editor-fold>
  // <editor-fold defaultstate="collapsed" desc="public void Sk6812rgbwLed_SetBlue(int blue)">
  /**
   * To set the Blue LED Color Value
   *
   * @param blue Brightness of the Blue LED; 0 - 255 Max
   */
  public void Sk6812rgbwLed_SetBlue(int blue) {
    this.color = new ColorRgbw(this.color.Red, this.color.Green, blue,
        this.color.White);
  } // public void Sk6812rgbwLed_SetBlue(int blue)
  // </editor-fold>
  // <editor-fold defaultstate="collapsed" desc="public int Sk6812rgbwLed_GetBlue()">
  /**
   * To return the Blue LED value
   *
   * @return Value of the Blue LED
   */
  public int Sk6812rgbwLed_GetBlue() {
    return(this.color.Blue);
  } // public int Sk6812rgbwLed_GetBlue()
  // </editor-fold>
  // <editor-fold defaultstate="collapsed" desc="public void Sk6812rgbwLed_SetWhite(int white)">
  /**
   * To set the White LED Color Value
   *
   * @param white Brightness of the White LED; 0 - 255 Max
   */
  public void Sk6812rgbwLed_SetWhite(int white) {
    this.color = new ColorRgbw(this.color.Red, this.color.Green, 
        this.color.Blue, white);
  } // public void Sk6812rgbwLed_SetWhite(int white)
  // </editor-fold>
  // <editor-fold defaultstate="collapsed" desc="public int Sk6812rgbwLed_GetWhite()">
  /**
   * To return the White LED value
   *
   * @return Value of the White LED
   */
  public int Sk6812rgbwLed_GetWhite() {
    return(this.color.White);
  } // public int Sk6812rgbwLed_GetWhite()
  // </editor-fold>
  // <editor-fold defaultstate="collapsed" desc="public int Sk6812rgbwLed_GetSpiSpeed()">
  /**
   * To return the required baud rate to support the data stream messages
   *
   * @return Baud Rate Speed in bits per second
   */
  public int Sk6812rgbwLed_GetSpiSpeed() {
    return(this.SK6812RGBW_SPISPEED);
  } // public int Sk6812rgbwLed_GetSpiSpeed()
  // </editor-fold>
  // <editor-fold defaultstate="collapsed" desc="public int Sk6812rgbwLed_GetDataStreamSize()">
  /**
   * To return the number of bytes in a complete data stream
   *
   * @return Data stream size
   */
  public int Sk6812rgbwLed_GetDataStreamSize() {
    return(this.DATASTREAM_SIZE);
  } // public int Sk6812rgbwLed_GetDataStreamSize()
  // </editor-fold>
  // <editor-fold defaultstate="collapsed" desc="public byte[] Sk6812rgbwLed_GetDataString() throws IllegalStateException">
  /**
   * To the return LED data, in a data array, that can be <br>
   * &emsp &nbsp sent to the SPI bus at the desired baud rate
   *
   * @return LED data array for the SPI Bus
   * 
   * @throws IllegalStateException if DATASTREAM_SIZE is not supported
   */
  public byte[] Sk6812rgbwLed_GetDataString() throws IllegalStateException {
    /**
     * Data stream array of bytes
     */
    byte data[] = new byte[DATASTREAM_SIZE];
    /**
     * LED Data in a boolean array
     */
    boolean colordata[];
    
    // Determine if the DATASTREAM_SIZE is Supported
    if(DATASTREAM_SIZE == 16) {
      // DATASTREAM_SIZE is 16
      // Check that the LED is Enabled
      if(this.enable == FALSE) {
        // Return all '0' bits; 0b 1000 1000
        for(int i = 0; i < DATASTREAM_SIZE; i++) {
          // Load Array with all '0's
          data[i] = (byte) 0x88;
        }
      } else {
        // LED is Enabled so load color data
        // Get LED data in a boolean Array
        colordata = Sk6812rgbwLed_GetColorData();

        // Walk data array loading the correct message
        for(int i = 0; i < DATASTREAM_SIZE; i++) {
          // Clear the data array position
          data[i] = 0x00;

          // Check boolean for True or False
          if(colordata[(i * 2)] == TRUE)
            // Boolean was True so load '1' message
            data[i] = HIGH;
          else
            // Boolean was False so load '0' message
            data[i] = LOW;

          // Shift message to 4 MSB
          data[i] = (byte) (data[i] << 4);

          // Check next boolean value
          if(colordata[(i * 2) + 1] == TRUE)
            // Boolean was True so load '1' message
            data[i] = (byte) (data[i] | HIGH);
          else
            // Boolean was False so load '0' message
            data[i] = (byte) (data[i] | LOW);
        }
      }
    } else if(DATASTREAM_SIZE == 32) {
      // DATASTREAM_SIZE is 16
      // Check that the LED is Enabled
      if(this.enable == FALSE) {
        // Return all '0' bits; 0b 1100 0000
        for(int i = 0; i < DATASTREAM_SIZE; i++) {
          // Load Array with all '0's
          data[i] = (byte) 0xC0;
        }
      } else {
        // LED is Enabled so load color data
        // Get LED data in a boolean Array
        colordata = Sk6812rgbwLed_GetColorData();

        // Walk data array loading the correct message
        for(int i = 0; i < DATASTREAM_SIZE; i++) {
          // Check boolean value
          if(colordata[i] == TRUE)
            // Boolean was True so load '1' message
            data[i] = HIGH;
          else
            // Boolean was False so load '0' message
            data[i] = LOW;
        }
      }
    } else
      // Unknown DATASTREAM_SIZE, return IllegalStateException
      throw new IllegalStateException("Unsupported Data Stream Size");
    // Return data array
    return(data);
  } // public byte[] Sk6812rgbwLed_GetDataString() throws IllegalStateException
  // </editor-fold>
  // <editor-fold defaultstate="collapsed" desc="public int Sk6812rgbwLed_GetResetMessageSize()">
  /**
   * To return the number of bytes in the reset message
   *
   * @return Data stream size
   */
  public int Sk6812rgbwLed_GetResetMessageSize() {
    return(this.RESETMESSAGE_SIZE);
  } // public int Sk6812rgbwLed_GetResetMessageSize()
  // </editor-fold>
  // <editor-fold defaultstate="collapsed" desc="public byte[] Sk6812rgbwLed_GetResetMessage()">
  /**
   * To return the reset message array for the set SPI speed
   *
   * @return Message to Reset the Chain
   */
  public byte[] Sk6812rgbwLed_GetResetMessage() {
    return(this.RESET);
  } // public byte[] Sk6812rgbwLed_GetResetMessage()
  // </editor-fold>
  // <editor-fold defaultstate="collapsed" desc="private boolean[] Sk6812rgbwLed_GetColorData()">
  /**
   * To return the LED data in a boolean array
   * <p>
   * To return the LED data in an array of booleans where <br>
   * &emsp &nbsp a '1' is considered True and '0' is False
   *
   * @return LED data in a boolean array
   */
  private boolean[] Sk6812rgbwLed_GetColorData() {
    /**
     * Boolean array to hold the LED data; RGBW each have 8 bits
     */
    boolean colordata[] = new boolean[32];
    /**
     * Byte container to hold the current color being loaded
     */
    int colorbyte = 0;
    
    // Check each color
    for(int i = 0; i < 4; i++) {
      // Load color value
      switch(i) {
        case 0:
          // Green
          colorbyte = this.color.Green;
          break;
        case 1:
          // Red
          colorbyte = this.color.Red;
          break;
        case 2:
          // Blue
          colorbyte = this.color.Blue;
          break;
        case 3:
          // White
          colorbyte = this.color.White;
          break;
      }
      
      // Isolate Bit 7
      if((colorbyte & 0b10000000) > 0)
        // Bit is '1'
        colordata[(i * 8)] = TRUE;
      else
        // Bit is '0'
        colordata[(i * 8)] = FALSE;
      
      // Isolate Bit 6
      if((colorbyte & 0b01000000) > 0)
        // Bit is '1'
        colordata[(i * 8) + 1] = TRUE;
      else
        // Bit is '0'
        colordata[(i * 8) + 1] = FALSE;
      
      // Isolate Bit 5
      if((colorbyte & 0b00100000) > 0)
        // Bit is '1'
        colordata[(i * 8) + 2] = TRUE;
      else
        // Bit is '0'
        colordata[(i * 8) + 2] = FALSE;
      
      // Isolate Bit 4
      if((colorbyte & 0b00010000) > 0)
        // Bit is '1'
        colordata[(i * 8) + 3] = TRUE;
      else
        // Bit is '0'
        colordata[(i * 8) + 3] = FALSE;
      
      // Isolate Bit 3
      if((colorbyte & 0b00001000) > 0)
        // Bit is '1'
        colordata[(i * 8) + 4] = TRUE;
      else
        // Bit is '0'
        colordata[(i * 8) + 4] = FALSE;
      
      // Isolate Bit 2
      if((colorbyte & 0b00000100) > 0)
        // Bit is '1'
        colordata[(i * 8) + 5] = TRUE;
      else
        // Bit is '0'
        colordata[(i * 8) + 5] = FALSE;
      
      // Isolate Bit 1
      if((colorbyte & 0b00000010) > 0)
        // Bit is '1'
        colordata[(i * 8) + 6] = TRUE;
      else
        // Bit is '0'
        colordata[(i * 8) + 6] = FALSE;
      
      // Isolate Bit 0
      if((colorbyte & 0b00000001) > 0)
        // Bit is '1'
        colordata[(i * 8) + 7] = TRUE;
      else
        // Bit is '0'
        colordata[(i * 8) + 7] = FALSE;
    }
    // Return boolean array
    return(colordata);
  } // private boolean[] Sk6812rgbwLed_GetColorData()
  // </editor-fold>
}
