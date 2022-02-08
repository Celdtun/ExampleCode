/*******************************************************************************
//  Class:        RandomColor
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
import java.util.Random;
// </editor-fold>

/**
 * Random Color Generator
 * @author Chad Graham
 * @version 0.0
 */
public class RandomColor {

  // <editor-fold defaultstate="collapsed" desc="Public Class Variables">
  // </editor-fold>

  // <editor-fold defaultstate="collapsed" desc="Private Class Variables">
  /**
   * Random Number Generator
   */
  private final Random RAND = new Random();
  /**
   * Minimum Value for Random Intensities that don't Specify a Specific Range
   */
  private int minimumValue = 0;
  /**
   * Maximum Value for Random Intensities that don't Specify a Specific Range
   */
  private int maximumValue = 255;
  // </editor-fold>

  // <editor-fold defaultstate="collapsed" desc="public RandomColor()">
  /**
   * Default Constructor for RandomColor; Simply Initializes <br>
   * &emsp &nbsp the Random Number Generator
   */
  public RandomColor() {
  } // public RandomColor()
  // </editor-fold>
  // <editor-fold defaultstate="collapsed" desc="public ColorRgb GetRgb()">
  /**
   * Generate and Return a Random RGB Color; Each Intensity is in <br>
   * &emsp &nbsp the class range
   * <p>
   * To check class range, use GetMinimumValue() and GetMaximumValue()
   *
   * @return Random RGB Color
   */
  public ColorRgb GetRgb() {
    
    int red = GetRandomIntensity();
    int blue = GetRandomIntensity();
    int green = GetRandomIntensity();
    ColorRgb rgbColor = new ColorRgb(red, blue, green);
    
    return(rgbColor);
  } // public ColorRgb GetRgb()
  // </editor-fold>
  // <editor-fold defaultstate="collapsed" desc="public ColorRgb GetRgb(int min, int max)">
  /**
   * Generate and Return a Random RGB Color; Each Intensity is in <br>
   * &emsp &nbsp the specified range
   * 
   * @param min Minimum Acceptable Range (Inclusive)
   * 
   * @param max Maximum Acceptable Range (Inclusive)
   *
   * @return Random RGB Color
   */
  public ColorRgb GetRgb(int min, int max) {
    
    int red = GetRandomIntensity(min, max);
    int blue = GetRandomIntensity(min, max);
    int green = GetRandomIntensity(min, max);
    ColorRgb rgbColor = new ColorRgb(red, blue, green);
    
    return(rgbColor);
  } // public ColorRgb GetRgb(int min, int max)
  // </editor-fold>
  // <editor-fold defaultstate="collapsed" desc="public ColorRgb GetRgbw()">
  /**
   * Generate and Return a Random RGBW Color; Each Intensity is in <br>
   * &emsp &nbsp the class range
   * <p>
   * To check class range, use GetMinimumValue() and GetMaximumValue()
   *
   * @return Random RGBW Color
   */
  public ColorRgbw GetRgbw() {
    
    int red = GetRandomIntensity();
    int blue = GetRandomIntensity();
    int green = GetRandomIntensity();
    int white = GetRandomIntensity();
    ColorRgbw rgbwColor = new ColorRgbw(red, blue, green, white);
    
    return(rgbwColor);
  } // public ColorRgbw GetRgbw()
  // </editor-fold>
  // <editor-fold defaultstate="collapsed" desc="public ColorRgb GetRgbw(int min, int max)">
  /**
   * Generate and Return a Random RGBW Color; Each Intensity is in <br>
   * &emsp &nbsp the specified range
   * 
   * @param min Minimum Acceptable Range (Inclusive)
   * 
   * @param max Maximum Acceptable Range (Inclusive)
   *
   * @return Random RGBW Color
   */
  public ColorRgbw GetRgbw(int min, int max) {
    
    int red = GetRandomIntensity(min, max);
    int blue = GetRandomIntensity(min, max);
    int green = GetRandomIntensity(min, max);
    int white = GetRandomIntensity(min, max);
    ColorRgbw rgbwColor = new ColorRgbw(red, blue, green, white);
    
    return(rgbwColor);
  } // public ColorRgbw GetRgbw(int min, int max)
  // </editor-fold>
  // <editor-fold defaultstate="collapsed" desc="public int GetRandomIntensity()">
  /**
   * Generate and Return a Random Intensity on the class range
   * <p>
   * To check class range, use GetMinimumValue() and GetMaximumValue()
   *
   * @return Random Intensity
   */
  public int GetRandomIntensity() {
    return(GetRandomIntensity(minimumValue, maximumValue));
  } // public int GetRandomIntensity()
  // </editor-fold>
  // <editor-fold defaultstate="collapsed" desc="public int GetRandomIntensity(int min, int max)">
  /**
   * Generate and Return a Random Intensity on a Scale of min - max
   * 
   * @param min Minimum Acceptable Range (Inclusive)
   * 
   * @param max Maximum Acceptable Range (Inclusive)
   *
   * @return Random Intensity
   */
  public int GetRandomIntensity(int min, int max) {
    /**
     * Difference between Max and min values
     */
    int diff = max - min;
    return((RAND.nextInt(diff) + min));
  } // public int GetRandomIntensity(int min, int max)
  // </editor-fold>
  // <editor-fold defaultstate="collapsed" desc="public void SetMinimumValue(int value)">
  /**
   * Set the new minimum inclusive value
   *
   * @param value New minimum value
   */
  public void SetMinimumValue(int value) {
    this.minimumValue = value;
  } // public void SetMinimumValue(int value)
  // </editor-fold>
  // <editor-fold defaultstate="collapsed" desc="public int GetMinimumValue()">
  /**
   * Return the set class inclusive minimum value
   *
   * @return Set class minimum value
   */
  public int GetMinimumValue() {
    return(this.minimumValue);
  } // public int GetMinimumValue()
  // </editor-fold>
  // <editor-fold defaultstate="collapsed" desc="public void SetMaximumValue(int value)">
  /**
   * Set the new maximum inclusive value
   *
   * @param value New maximum value
   */
  public void SetMaximumValue(int value) {
    this.maximumValue = value;
  } // public void SetMaximumValue(int value)
  // </editor-fold>
  // <editor-fold defaultstate="collapsed" desc="public int GetMaximumValue()">
  /**
   * Return the set class inclusive maximum value
   *
   * @return Set class minimum value
   */
  public int GetMaximumValue() {
    return(this.maximumValue);
  } // public int GetMaximumValue()
  // </editor-fold>
}
