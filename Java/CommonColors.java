/*******************************************************************************
//  Class:        ColorRgb
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
 * Common Colors in RGB Format
 * @author Chad Graham
 * @version 0.0
 */
public final class CommonColors {

  // <editor-fold defaultstate="collapsed" desc="Public Class Variables">
  /**
   * RGB Values for ALICEBLUE
   */
  public static final ColorRgb ALICEBLUE = 
      new ColorRgb(240, 248, 255);
  /**
   * RGB Values for ANTIQUEWHITE
   */
  public static final ColorRgb ANTIQUEWHITE = 
      new ColorRgb(250, 235, 215);
  /**
   * RGB Values for AQUA
   */
  public static final ColorRgb AQUA = 
      new ColorRgb(0, 255, 255);
  /**
   * RGB Values for AQUAMARINE
   */
  public static final ColorRgb AQUAMARINE = 
      new ColorRgb(127, 255, 212);
  /**
   * RGB Values for AZURE
   */
  public static final ColorRgb AZURE = 
      new ColorRgb(240, 255, 255);
  /**
   * RGB Values for BEIGE
   */
  public static final ColorRgb BEIGE = 
      new ColorRgb(245, 245, 220);
  /**
   * RGB Values for BISQUE
   */
  public static final ColorRgb BISQUE = 
      new ColorRgb(255, 228, 196);
  /**
   * RGB Values for BLACK
   */
  public static final ColorRgb BLACK = 
      new ColorRgb(0, 0, 0);
  /**
   * RGB Values for BLANCHEDALMOND
   */
  public static final ColorRgb BLANCHEDALMOND = 
      new ColorRgb(255, 235, 205);
  /**
   * RGB Values for BLUE
   */
  public static final ColorRgb BLUE = 
      new ColorRgb(0, 0, 255);
  /**
   * RGB Values for BLUEVIOLET
   */
  public static final ColorRgb BLUEVIOLET = 
      new ColorRgb(138, 43, 226);
  /**
   * RGB Values for BROWN
   */
  public static final ColorRgb BROWN = 
      new ColorRgb(165, 42, 42);
  /**
   * RGB Values for BURLYWOOD
   */
  public static final ColorRgb BURLYWOOD = 
      new ColorRgb(222, 184, 135);
  /**
   * RGB Values for CADETBLUE
   */
  public static final ColorRgb CADETBLUE = 
      new ColorRgb(95, 158, 160);
  /**
   * RGB Values for CHARTREUSE
   */
  public static final ColorRgb CHARTREUSE = 
      new ColorRgb(127, 255, 0);
  /**
   * RGB Values for CHOCOLATE
   */
  public static final ColorRgb CHOCOLATE = 
      new ColorRgb(210, 105, 30);
  /**
   * RGB Values for CORAL
   */
  public static final ColorRgb CORAL = 
      new ColorRgb(255, 127, 80);
  /**
   * RGB Values for CORNFLOWERBLUE
   */
  public static final ColorRgb CORNFLOWERBLUE = 
      new ColorRgb(100, 149, 237);
  /**
   * RGB Values for CORNSILK
   */
  public static final ColorRgb CORNSILK = 
      new ColorRgb(255, 248, 220);
  /**
   * RGB Values for CRIMSON
   */
  public static final ColorRgb CRIMSON = 
      new ColorRgb(220, 20, 60);
  /**
   * RGB Values for CYAN
   */
  public static final ColorRgb CYAN = 
      new ColorRgb(0, 255, 255);
  /**
   * RGB Values for DARKBLUE
   */
  public static final ColorRgb DARKBLUE = 
      new ColorRgb(0, 0, 139);
  /**
   * RGB Values for DARKCYAN
   */
  public static final ColorRgb DARKCYAN = 
      new ColorRgb(0, 139, 139);
  /**
   * RGB Values for DARKGOLDENROD
   */
  public static final ColorRgb DARKGOLDENROD = 
      new ColorRgb(184, 134, 11);
  /**
   * RGB Values for DARKGRAY
   */
  public static final ColorRgb DARKGRAY = 
      new ColorRgb(169, 169, 169);
  /**
   * RGB Values for DARKGREEN
   */
  public static final ColorRgb DARKGREEN = 
      new ColorRgb(0, 100, 0);
  /**
   * RGB Values for DARKKHAKI
   */
  public static final ColorRgb DARKKHAKI = 
      new ColorRgb(189, 183, 107);
  /**
   * RGB Values for DARKMAGENTA
   */
  public static final ColorRgb DARKMAGENTA = 
      new ColorRgb(139, 0, 139);
  /**
   * RGB Values for DARKOLIVEGREEN
   */
  public static final ColorRgb DARKOLIVEGREEN = 
      new ColorRgb(85, 107, 47);
  /**
   * RGB Values for DARKORANGE
   */
  public static final ColorRgb DARKORANGE = 
      new ColorRgb(255, 140, 0);
  /**
   * RGB Values for DARKORCHID
   */
  public static final ColorRgb DARKORCHID = 
      new ColorRgb(153, 50, 204);
  /**
   * RGB Values for DARKRED
   */
  public static final ColorRgb DARKRED = 
      new ColorRgb(139, 0, 0);
  /**
   * RGB Values for DARKSALMON
   */
  public static final ColorRgb DARKSALMON = 
      new ColorRgb(233, 150, 122);
  /**
   * RGB Values for DARKSEAGREEN
   */
  public static final ColorRgb DARKSEAGREEN = 
      new ColorRgb(143, 188, 143);
  /**
   * RGB Values for DARKSLATEBLUE
   */
  public static final ColorRgb DARKSLATEBLUE = 
      new ColorRgb(72, 61, 139);
  /**
   * RGB Values for DARKSLATEGRAY
   */
  public static final ColorRgb DARKSLATEGRAY = 
      new ColorRgb(47, 79, 79);
  /**
   * RGB Values for DARKTURQUOISE
   */
  public static final ColorRgb DARKTURQUOISE = 
      new ColorRgb(0, 206, 209);
  /**
   * RGB Values for DARKVIOLET
   */
  public static final ColorRgb DARKVIOLET = 
      new ColorRgb(148, 0, 211);
  /**
   * RGB Values for DEEPPINK
   */
  public static final ColorRgb DEEPPINK = 
      new ColorRgb(255, 20, 147);
  /**
   * RGB Values for DEEPSKYBLUE
   */
  public static final ColorRgb DEEPSKYBLUE = 
      new ColorRgb(0, 191, 255);
  /**
   * RGB Values for DIMGRAY
   */
  public static final ColorRgb DIMGRAY = 
      new ColorRgb(105, 105, 105);
  /**
   * RGB Values for DODGERBLUE
   */
  public static final ColorRgb DODGERBLUE = 
      new ColorRgb(30, 144, 255);
  /**
   * RGB Values for FIREBRICK
   */
  public static final ColorRgb FIREBRICK = 
      new ColorRgb(178, 34, 34);
  /**
   * RGB Values for FLORALWHITE
   */
  public static final ColorRgb FLORALWHITE = 
      new ColorRgb(255, 250, 240);
  /**
   * RGB Values for FORESTGREEN
   */
  public static final ColorRgb FORESTGREEN = 
      new ColorRgb(34, 139, 34);
  /**
   * RGB Values for GAINSBORO
   */
  public static final ColorRgb GAINSBORO = 
      new ColorRgb(220, 220, 220);
  /**
   * RGB Values for GHOSTWHITE
   */
  public static final ColorRgb GHOSTWHITE = 
      new ColorRgb(248, 248, 255);
  /**
   * RGB Values for GOLD
   */
  public static final ColorRgb GOLD = 
      new ColorRgb(255, 215, 0);
  /**
   * RGB Values for GOLDENROD
   */
  public static final ColorRgb GOLDENROD = 
      new ColorRgb(218, 165, 32);
  /**
   * RGB Values for GRAY
   */
  public static final ColorRgb GRAY = 
      new ColorRgb(128, 128, 128);
  /**
   * RGB Values for GREEN
   */
  public static final ColorRgb GREEN = 
      new ColorRgb(0, 128, 0);
  /**
   * RGB Values for GREENYELLOW
   */
  public static final ColorRgb GREENYELLOW = 
      new ColorRgb(173, 255, 47);
  /**
   * RGB Values for HONEYDEW
   */
  public static final ColorRgb HONEYDEW = 
      new ColorRgb(240, 255, 240);
  /**
   * RGB Values for HOTPINK
   */
  public static final ColorRgb HOTPINK = 
      new ColorRgb(255, 105, 180);
  /**
   * RGB Values for INDIANRED
   */
  public static final ColorRgb INDIANRED = 
      new ColorRgb(205, 92, 92);
  /**
   * RGB Values for INDIGO
   */
  public static final ColorRgb INDIGO = 
      new ColorRgb(75, 0, 130);
  /**
   * RGB Values for IVORY
   */
  public static final ColorRgb IVORY = 
      new ColorRgb(255, 255, 240);
  /**
   * RGB Values for KHAKI
   */
  public static final ColorRgb KHAKI = 
      new ColorRgb(240, 230, 140);
  /**
   * RGB Values for LAVENDER
   */
  public static final ColorRgb LAVENDER = 
      new ColorRgb(230, 230, 250);
  /**
   * RGB Values for LAVENDERBLUSH
   */
  public static final ColorRgb LAVENDERBLUSH = 
      new ColorRgb(255, 240, 245);
  /**
   * RGB Values for LAWNGREEN
   */
  public static final ColorRgb LAWNGREEN = 
      new ColorRgb(124, 252, 0);
  /**
   * RGB Values for LEMONCHIFFON
   */
  public static final ColorRgb LEMONCHIFFON = 
      new ColorRgb(255, 250, 205);
  /**
   * RGB Values for LIGHTBLUE
   */
  public static final ColorRgb LIGHTBLUE = 
      new ColorRgb(173, 216, 230);
  /**
   * RGB Values for LIGHTCORAL
   */
  public static final ColorRgb LIGHTCORAL = 
      new ColorRgb(240, 128, 128);
  /**
   * RGB Values for LIGHTCYAN
   */
  public static final ColorRgb LIGHTCYAN = 
      new ColorRgb(224, 255, 255);
  /**
   * RGB Values for LIGHTGOLDENRODYELLOW
   */
  public static final ColorRgb LIGHTGOLDENRODYELLOW = 
      new ColorRgb(250, 250, 210);
  /**
   * RGB Values for LIGHTGRAY
   */
  public static final ColorRgb LIGHTGRAY = 
      new ColorRgb(211, 211, 211);
  /**
   * RGB Values for LIGHTGREEN
   */
  public static final ColorRgb LIGHTGREEN = 
      new ColorRgb(144, 238, 144);
  /**
   * RGB Values for LIGHTPINK
   */
  public static final ColorRgb LIGHTPINK = 
      new ColorRgb(255, 182, 193);
  /**
   * RGB Values for LIGHTSALMON
   */
  public static final ColorRgb LIGHTSALMON = 
      new ColorRgb(255, 160, 122);
  /**
   * RGB Values for LIGHTSEAGREEN
   */
  public static final ColorRgb LIGHTSEAGREEN = 
      new ColorRgb(32, 178, 170);
  /**
   * RGB Values for LIGHTSKYBLUE
   */
  public static final ColorRgb LIGHTSKYBLUE = 
      new ColorRgb(135, 206, 250);
  /**
   * RGB Values for LIGHTSLATEGRAY
   */
  public static final ColorRgb LIGHTSLATEGRAY = 
      new ColorRgb(119, 136, 153);
  /**
   * RGB Values for LIGHTSTEELBLUE
   */
  public static final ColorRgb LIGHTSTEELBLUE = 
      new ColorRgb(176, 196, 222);
  /**
   * RGB Values for LIGHTYELLOW
   */
  public static final ColorRgb LIGHTYELLOW = 
      new ColorRgb(255, 255, 224);
  /**
   * RGB Values for LIME
   */
  public static final ColorRgb LIME = 
      new ColorRgb(0, 255, 0);
  /**
   * RGB Values for LIMEGREEN
   */
  public static final ColorRgb LIMEGREEN = 
      new ColorRgb(50, 205, 50);
  /**
   * RGB Values for LINEN
   */
  public static final ColorRgb LINEN = 
      new ColorRgb(250, 240, 230);
  /**
   * RGB Values for MAGENTA
   */
  public static final ColorRgb MAGENTA = 
      new ColorRgb(255, 0, 255);
  /**
   * RGB Values for MAROON
   */
  public static final ColorRgb MAROON = 
      new ColorRgb(128, 0, 0);
  /**
   * RGB Values for MEDIUMAQUAMARINE
   */
  public static final ColorRgb MEDIUMAQUAMARINE = 
      new ColorRgb(102, 205, 170);
  /**
   * RGB Values for MEDIUMBLUE
   */
  public static final ColorRgb MEDIUMBLUE = 
      new ColorRgb(0, 0, 205);
  /**
   * RGB Values for MEDIUMORCHID
   */
  public static final ColorRgb MEDIUMORCHID = 
      new ColorRgb(186, 85, 211);
  /**
   * RGB Values for MEDIUMPURPLE
   */
  public static final ColorRgb MEDIUMPURPLE = 
      new ColorRgb(147, 112, 219);
  /**
   * RGB Values for MEDIUMSEAGREEN
   */
  public static final ColorRgb MEDIUMSEAGREEN = 
      new ColorRgb(60, 179, 113);
  /**
   * RGB Values for MEDIUMSLATEBLUE
   */
  public static final ColorRgb MEDIUMSLATEBLUE = 
      new ColorRgb(123, 104, 238);
  /**
   * RGB Values for MEDIUMSPRINGGREEN
   */
  public static final ColorRgb MEDIUMSPRINGGREEN = 
      new ColorRgb(0, 250, 154);
  /**
   * RGB Values for MEDIUMTURQUOISE
   */
  public static final ColorRgb MEDIUMTURQUOISE = 
      new ColorRgb(72, 209, 204);
  /**
   * RGB Values for MEDIUMVIOLETRED
   */
  public static final ColorRgb MEDIUMVIOLETRED = 
      new ColorRgb(199, 21, 133);
  /**
   * RGB Values for MIDNIGHTBLUE
   */
  public static final ColorRgb MIDNIGHTBLUE = 
      new ColorRgb(25, 25, 112);
  /**
   * RGB Values for MINTCREAM
   */
  public static final ColorRgb MINTCREAM = 
      new ColorRgb(245, 255, 250);
  /**
   * RGB Values for MISTYROSE
   */
  public static final ColorRgb MISTYROSE = 
      new ColorRgb(255, 228, 225);
  /**
   * RGB Values for MOCCASIN
   */
  public static final ColorRgb MOCCASIN = 
      new ColorRgb(255, 228, 181);
  /**
   * RGB Values for NAVAJOWHITE
   */
  public static final ColorRgb NAVAJOWHITE = 
      new ColorRgb(255, 222, 173);
  /**
   * RGB Values for NAVY
   */
  public static final ColorRgb NAVY = 
      new ColorRgb(0, 0, 128);
  /**
   * RGB Values for OLDLACE
   */
  public static final ColorRgb OLDLACE = 
      new ColorRgb(253, 245, 230);
  /**
   * RGB Values for OLIVE
   */
  public static final ColorRgb OLIVE = 
      new ColorRgb(128, 128, 0);
  /**
   * RGB Values for OLIVEDRAB
   */
  public static final ColorRgb OLIVEDRAB = 
      new ColorRgb(107, 142, 35);
  /**
   * RGB Values for ORANGE
   */
  public static final ColorRgb ORANGE = 
      new ColorRgb(255, 165, 0);
  /**
   * RGB Values for ORANGERED
   */
  public static final ColorRgb ORANGERED = 
      new ColorRgb(255, 69, 0);
  /**
   * RGB Values for ORCHID
   */
  public static final ColorRgb ORCHID = 
      new ColorRgb(218, 112, 214);
  /**
   * RGB Values for PALEGOLDENROD
   */
  public static final ColorRgb PALEGOLDENROD = 
      new ColorRgb(238, 232, 170);
  /**
   * RGB Values for PALEGREEN
   */
  public static final ColorRgb PALEGREEN = 
      new ColorRgb(152, 251, 152);
  /**
   * RGB Values for PALETURQUOISE
   */
  public static final ColorRgb PALETURQUOISE = 
      new ColorRgb(175, 238, 238);
  /**
   * RGB Values for PALEVIOLETRED
   */
  public static final ColorRgb PALEVIOLETRED = 
      new ColorRgb(219, 112, 147);
  /**
   * RGB Values for PAPAYAWHIP
   */
  public static final ColorRgb PAPAYAWHIP = 
      new ColorRgb(255, 239, 213);
  /**
   * RGB Values for PEACHPUFF
   */
  public static final ColorRgb PEACHPUFF = 
      new ColorRgb(255, 218, 185);
  /**
   * RGB Values for PERU
   */
  public static final ColorRgb PERU = 
      new ColorRgb(205, 133, 63);
  /**
   * RGB Values for PINK
   */
  public static final ColorRgb PINK = 
      new ColorRgb(255, 192, 203);
  /**
   * RGB Values for PLUM
   */
  public static final ColorRgb PLUM = 
      new ColorRgb(221, 160, 221);
  /**
   * RGB Values for POWDERBLUE
   */
  public static final ColorRgb POWDERBLUE = 
      new ColorRgb(176, 224, 230);
  /**
   * RGB Values for PURPLE
   */
  public static final ColorRgb PURPLE = 
      new ColorRgb(128, 0, 128);
  /**
   * RGB Values for RED
   */
  public static final ColorRgb RED = 
      new ColorRgb(255, 0, 0);
  /**
   * RGB Values for ROSYBROWN
   */
  public static final ColorRgb ROSYBROWN = 
      new ColorRgb(188, 143, 143);
  /**
   * RGB Values for ROYALBLUE
   */
  public static final ColorRgb ROYALBLUE = 
      new ColorRgb(65, 105, 225);
  /**
   * RGB Values for SADDLEBROWN
   */
  public static final ColorRgb SADDLEBROWN = 
      new ColorRgb(139, 69, 19);
  /**
   * RGB Values for SALMON
   */
  public static final ColorRgb SALMON = 
      new ColorRgb(250, 128, 114);
  /**
   * RGB Values for SANDYBROWN
   */
  public static final ColorRgb SANDYBROWN = 
      new ColorRgb(244, 164, 96);
  /**
   * RGB Values for SEAGREEN
   */
  public static final ColorRgb SEAGREEN = 
      new ColorRgb(46, 139, 87);
  /**
   * RGB Values for SEASHELL
   */
  public static final ColorRgb SEASHELL = 
      new ColorRgb(255, 245, 238);
  /**
   * RGB Values for SIENNA
   */
  public static final ColorRgb SIENNA = 
      new ColorRgb(160, 82, 45);
  /**
   * RGB Values for SILVER
   */
  public static final ColorRgb SILVER = 
      new ColorRgb(192, 192, 192);
  /**
   * RGB Values for SKYBLUE
   */
  public static final ColorRgb SKYBLUE = 
      new ColorRgb(135, 206, 235);
  /**
   * RGB Values for SLATEBLUE
   */
  public static final ColorRgb SLATEBLUE = 
      new ColorRgb(106, 90, 205);
  /**
   * RGB Values for SLATEGRAY
   */
  public static final ColorRgb SLATEGRAY = 
      new ColorRgb(112, 128, 144);
  /**
   * RGB Values for SNOW
   */
  public static final ColorRgb SNOW = 
      new ColorRgb(255, 250, 250);
  /**
   * RGB Values for SPRINGGREEN
   */
  public static final ColorRgb SPRINGGREEN = 
      new ColorRgb(0, 255, 127);
  /**
   * RGB Values for STEELBLUE
   */
  public static final ColorRgb STEELBLUE = 
      new ColorRgb(70, 130, 180);
  /**
   * RGB Values for TAN
   */
  public static final ColorRgb TAN = 
      new ColorRgb(210, 180, 140);
  /**
   * RGB Values for TEAL
   */
  public static final ColorRgb TEAL = 
      new ColorRgb(0, 128, 128);
  /**
   * RGB Values for THISTLE
   */
  public static final ColorRgb THISTLE = 
      new ColorRgb(216, 191, 216);
  /**
   * RGB Values for TOMATO
   */
  public static final ColorRgb TOMATO = 
      new ColorRgb(255, 99, 71);
  /**
   * RGB Values for TURQUOISE
   */
  public static final ColorRgb TURQUOISE = 
      new ColorRgb(64, 224, 208);
  /**
   * RGB Values for VIOLET
   */
  public static final ColorRgb VIOLET = 
      new ColorRgb(238, 130, 238);
  /**
   * RGB Values for WHEAT
   */
  public static final ColorRgb WHEAT = 
      new ColorRgb(245, 222, 179);
  /**
   * RGB Values for WHITE
   */
  public static final ColorRgb WHITE = 
      new ColorRgb(255, 255, 255);
  /**
   * RGB Values for WHITESMOKE
   */
  public static final ColorRgb WHITESMOKE = 
      new ColorRgb(245, 245, 245);
  /**
   * RGB Values for YELLOW
   */
  public static final ColorRgb YELLOW = 
      new ColorRgb(255, 255, 0);
  /**
   * RGB Values for YELLOWGREEN
   */
  public static final ColorRgb YELLOWGREEN = 
      new ColorRgb(154, 205, 50);
  // </editor-fold>

  // <editor-fold defaultstate="collapsed" desc="Private Class Variables">
  // </editor-fold>

  // <editor-fold defaultstate="collapsed" desc="private CommonColors()">
  /**
   * **Do Not Use** Default Constructor for Common Color Class
   */
  private CommonColors() {
    // None
  } // public CommonColors()
  // </editor-fold>
}
