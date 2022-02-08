/*******************************************************************************
//  Class:        CommonFunctions
//  Package:      CommonFunctions
//
//  Author:       Chad Graham <graham.chad1@gmail.com>
//  Date:         May 10, 2018
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
 * Java Class to contain useful functions that can be accessed <br>
 * &emsp &nbsp from various classes
 * @author Chad Graham
 * @version 0.0
 */
public class CommonFunctions {

  // <editor-fold defaultstate="collapsed" desc="Public Class Variables">
  // </editor-fold>

  // <editor-fold defaultstate="collapsed" desc="Private Class Variables">
  /**
   * Lookup hex array containing characters to display on console
   */
  private final static char[] hexArray = "0123456789ABCDEF".toCharArray();
  // </editor-fold>

  // <editor-fold defaultstate="collapsed" desc="public CommonFunctions()">
  /**
   * Default Constructor for CommonFunctions
   */
  private CommonFunctions() {

  } // public CommonFunctions()
  // </editor-fold>
  // <editor-fold defaultstate="collapsed" desc="public static String bytesToHex(byte[] bytes)">
  /**
   * Returns a String containing the ASCII characters <br>
   * &emsp &nbsp of the provided byte array
   *
   * @param bytes Array of bytes to convert to ASCII string
   *
   * @return String with ASCII data
   */
  public static String bytesToHex(byte[] bytes) {
    /**
     * Character Array for returned String
     */
    char[] hexChars = new char[bytes.length * 2];
    // Walk through each byte of the input array
    for ( int j = 0; j < bytes.length; j++ ) {
      // Isolate only the 8 LSB
      int v = bytes[j] & 0xFF;
      // Determine the ASCII value of the 4 LSB
      hexChars[j * 2] = hexArray[v >>> 4];
      // Determine the ASCII value of the 4 MSB
      hexChars[j * 2 + 1] = hexArray[v & 0x0F];
    }
    // Return the array in String form
    return new String(hexChars);
  } // public static String bytesToHex(byte[] bytes)
  // </editor-fold>
}
