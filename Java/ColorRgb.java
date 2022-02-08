/*******************************************************************************
//  Class:        ColorRgb
//  Package:      CommonFunctions
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

package CommonFunctions;

// <editor-fold defaultstate="collapsed" desc="File Imports">
// </editor-fold>

/**
 * RGB Color Container Class
 * @author Chad Graham
 * @version 0.0
 */
public class ColorRgb {

  // <editor-fold defaultstate="collapsed" desc="Public Class Variables">
  /**
   * Red Color Variable
   */
  public final int Red;
  /**
   * Green Color Variable
   */
  public final int Green;
  /**
   * Blue Color Variable
   */
  public final int Blue;
  // </editor-fold>

  // <editor-fold defaultstate="collapsed" desc="Private Class Variables">
  // </editor-fold>
  
  // <editor-fold defaultstate="collapsed" desc="private ColorRgb()">
  /**
   * **Do Not Use** Default Constructor for RGB Container Class
   */
  private ColorRgb() {
    // Set Red Color to 0
    this.Red = 0;
    // Set Green Color to 0
    this.Green = 0;
    // Set Blue Color to 0
    this.Blue = 0;
  } // public ColorRgb()
  // </editor-fold>
  // <editor-fold defaultstate="collapsed" desc="public ColorRgb(int red, int green, int blue)">
  /**
   * Constructor for RGB Container Class
   *
   * @param red Red Color Value; Valid Values 0 - 255
   *
   * @param green Green Color Value; Valid Values 0 - 255
   *
   * @param blue Blue Color Value; Valid Values 0 - 255
   */
  public ColorRgb(int red, int green, int blue) {
    // Copy input red to red color
    if(red < 0)
      this.Red = 0;
    else if(red > 255)
      this.Red = 255;
    else
      this.Red = red;

    // Copy input green to green color
    if(green < 0)
      this.Green = 0;
    else if(green > 255)
      this.Green = 255;
    else
      this.Green = green;

    // Copy input blue to blue color
    if(blue < 0)
      this.Blue = 0;
    else if(blue > 255)
      this.Blue = 255;
    else
      this.Blue = blue;
  } // public ColorRgb(int red, int green, int blue)
  // </editor-fold>
}
