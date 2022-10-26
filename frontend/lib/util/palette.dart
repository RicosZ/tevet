import 'package:flutter/material.dart';

class Palette {
  static var inverseOnSurface = createMaterialColor(Color(0xffEFF1F1));
  static var secondary = createMaterialColor(Color(0xff4A6366));
  static var outline = createMaterialColor(Color(0xff6F797A));
  static var onPrimaryContainer = createMaterialColor(Color(0xff001F23));
  static var onPrimary = createMaterialColor(Color(0xffFFFFFF));
  static var serfaceVariant = createMaterialColor(Color(0xffDAE4E6));
  static var primary60 = createMaterialColor(Color(0xff00A0AD));
  static var primary50 = createMaterialColor(Color(0xff00848F));
  static var bgNew = createMaterialColor(Color(0xffFAFAFA));
  static var primary = createMaterialColor(Color(0xff006972));
  static var neutral95 = createMaterialColor(Color(0xffEFF1F1));
  static var onSurfaceVariant = createMaterialColor(Color(0xff3F484A));
  static var error = createMaterialColor(Color(0xffBA1A1A));
  static var secondaryContainer = createMaterialColor(Color(0xffCCE7EB));
  static var neutralVariant80 = createMaterialColor(Color(0xffBEC8CA));
  static var onTertiaryContainer = createMaterialColor(Color(0xff0C1B37));

  // static var surface2 = createMaterialColor(Color(0xffBA1A1A));
  static var tertiary = createMaterialColor(Color(0xff515E7D));
  static var tertiary95 = createMaterialColor(Color(0xffEDF0FF));
  // static var surface2 = createMaterialColor(Color(0xffBA1A1A));
  // static var onPrimaryContainer = createMaterialColor(Color(0xffBA1A1A));
  static var primary80 = createMaterialColor(Color(0xff4CD8E8));
  static var onSurface = createMaterialColor(Color(0xff191C1D));
  static var neutralVariant95 = createMaterialColor(Color(0xffE9F3F4));
  static var secondary60 = createMaterialColor(Color(0xff7C9599));
  static var errorContainer = createMaterialColor(Color(0xffFFDAD6));
  // static var Tin1 = createMaterialColor(Color(0xffBA1A1A));
  static var neutral60 = createMaterialColor(Color(0xff8E9191));
  static var tertiary60 = createMaterialColor(Color(0xff8390B2));

  //icon
  static var customColor1 = createMaterialColor(Color(0xff9C4145));
  static var customColor1Container = createMaterialColor(Color(0xffFFDAD9));
  static var customColor3 = createMaterialColor(Color(0xff5F6300));
  static var customColor3Container = createMaterialColor(Color(0xffE4E972));
  static var customColor4 = createMaterialColor(Color(0xff296B29));
  static var customColor4Container = createMaterialColor(Color(0xffACF4A2));
  static var customColor8 = createMaterialColor(Color(0xff85468C));
  static var customColor8Container = createMaterialColor(Color(0xffFFD6FD));
  static var neutral50 = createMaterialColor(Color(0xff747878));
  static var neutral90 = createMaterialColor(Color(0xffE0E3E3));
  static var tertiaryContainer = createMaterialColor(Color(0xffD8E2FF));
  // static var .... = createMaterialColor(Color(0xffBA1A1A));
  static var textForgetpassword = createMaterialColor(Color(0xff0055AA));
  static var logoVetCounslt  = createMaterialColor(Color(0xff231F20));



}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  ;
  return MaterialColor(color.value, swatch);
}


