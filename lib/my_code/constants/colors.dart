import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFFE5716E);

  // static const Color backgroundDark = Color(0xFF33373D);
  static const Color backgroundLight = Color(0xFFFFFFFF);
  // static const Color primary = Color(0xFF497BFE);
  // static const Color secondary = Color(0xFF5E89F8);
  // static const Color transparent = Colors.transparent;
  // static const Color premium = Colors.deepOrange;

  // static Color accentDark = const Color(0xFF2A2E32);
  static Color accentLight = const Color(0xFFFFFFFF);

  // static Color bottomSheetDark = const Color(0xFF32353B).withOpacity(0.5);
  static Color bottomSheetLight = const Color(0xFFFFFFFF).withOpacity(0.5);

  static const Color accentNew = Color(0xFF33373D);

  // static Color textHintDark = const Color(0xFFC7C7CC);
  static Color textHintLight = const Color.fromARGB(255, 125, 125, 125);

  // static const Color textDark = Color(0xFF101216);
  static const Color textLight = Color(0xFFFFFFFF);

  // static Color tertiaryDark = const Color(0xFF3c4046);
  static Color tertiaryLight = const Color(0xFFdfe3eb);

  // static Color tertiaryContainerDark = const Color(0xFF646464).withOpacity(0.5);
  static Color tertiaryContainerLight = const Color(0xFFFFFFFF);

  static Color surfaceLight = const Color.fromRGBO(75, 86, 106, 1);
  // static Color surfaceDark = const Color(0xFFFFFFFF);

  static const Color error = Color.fromRGBO(229, 115, 115, 0.5);

  // static const LinearGradient buttonGradient = LinearGradient(
  //   colors: [
  //     secondary,
  //     primary,
  //   ],
  //   begin: Alignment.topCenter,
  //   end: Alignment.bottomCenter,
  // );

  // static Color disableDark = const Color(0xFF595959);
  static Color disableLight = const Color(0xFF969696);

  // static Color primaryContainerDark = const Color(0xFF575A5D);
  static Color primaryContainerLight = const Color(0xFFD3D8E3);
  // static Color secondaryContainerDark = const Color(0xFF373739);
  static Color secondaryContainerLight = const Color(0xFFD3D8E3);

  // Add more color constants as needed

  // Example of a custom color scheme
  static MaterialColor primarySwatch = getColorFromHex(primaryColor.value);
  static MaterialColor accentSwatch = getColorFromHex(primaryColor.value);

  static MaterialColor getColorFromHex(int hexValue) {
    Map<int, Color> colorMap = {
      50: Color(hexValue),
      100: Color(hexValue),
      200: Color(hexValue),
      300: Color(hexValue),
      400: Color(hexValue),
      500: Color(hexValue),
      600: Color(hexValue),
      700: Color(hexValue),
      800: Color(hexValue),
      900: Color(hexValue),
    };
    return MaterialColor(hexValue, colorMap);
  }
}
