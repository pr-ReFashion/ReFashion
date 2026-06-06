import 'package:flutter/material.dart';

class ColorHelper {
  static const Color primary = Color(0xFF503DFF);
  static const Color secondPrimary = Color(0xFF0065FF);
  static const Color secondary = Color(0XFF19125B);
  static const Color black = Color(0XFF000000);
  static const Color white = Color(0XFFFFFFFF);
  static const Color whiteOpacity = Color(0XFFCCCCCC);
  static const Color hintColor = Color(0XFF8D8C8C);
  static const Color inputDecorationFill = Color(0XFFF7F7F7);
  static const Color error = Color(0XFFFB2F2F);
  static const Color inputDecorationBorder = Color(0XFFE4E4E4);
  static const Color shimmerColor = Color(0xffEDEDED);
  static const Color transparent = Colors.transparent;
  static const Color headingColor = Color(0xFF020014);
  static const Color subHeadingColor = Color(0xFF4E4D5B);
  static const Color lightGrey = Color(0xFFE6E6E8);
  static const Color buttonColor = Color(0xFF4385F5);
  static const Color dividerColor = Color(0xFFEEEEEE);
  static const Color iconColor = Color(0xFF4D4D4D);
  static const Color greyScale = Color(0xFF616161);
  static const Color softGrey = Color(0xFFECECEC);
  static const Color borderColor = Color(0xFFEBEBEB);
  static const Color primaryLightColor = Color(0xFFEDECFF);
  static const Color offWhite = Color(0xFFF8F9FB);
  static const Color success = Color(0xFF16BC5D);
  static const Color successLight = Color(0xFFEEFEEF);
  static const Color deepPurple = Color(0xFF8A2099);
  static const Color vividPurple = Color(0xFFC026D3);
  static const Color peach = Color(0xFFFFE2B4);
  static const Color teal = Color(0xFF0D9488);
  static const Color coolGray = Color(0xFFA1ABB9);
  static const Color royalBlue = Color(0xFF2563EB);
  static const Color amberGold = Color(0xFFF1B741);
  // Gradient colors
  static const Color gradientStart = Color(0xFFEDEBFF);
  static const Color gradientEnd = Color(0xFFF7F7F8);

  // Common gradient for backgrounds
  static const LinearGradient backgroundGradient = LinearGradient(
    stops: [-0.1826, 0.3306],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [ColorHelper.gradientStart, ColorHelper.gradientEnd],
  );
  static const LinearGradient newsCardBgGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [-0.0281, 0.0753, 0.9466],
    colors: [
      Color(0XFFF4F2FF),
      Color.fromRGBO(233, 230, 254, 0.8),
      ColorHelper.white,
    ],
  );
  static const LinearGradient offerProgressBgGradient = LinearGradient(
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
    stops: [0.349, 0.9694],
    colors: [
      Color.fromRGBO(249, 249, 249, 0.6),
      Color.fromRGBO(220, 216, 255, 0.6),
    ],
  );
  static const LinearGradient offerNotificationBgGradient = LinearGradient(
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
    stops: [0.0448, 0.6652],
    colors: [
      Color.fromRGBO(220, 216, 255, 0.6),
      Color.fromRGBO(249, 249, 249, 0.6),
    ],
  );

  static const warmSoftDiagonal = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    stops: [-0.1095, 0.9142],
    colors: [Color(0xFFFFE4B9), Color(0xFFF7F7F8)],
  );
  static const hourGlassBgGradient = LinearGradient(
    begin: Alignment(-0.02, 1.0),
    end: Alignment(0.02, -1.0),
    stops: [-0.0531, 0.896],
    colors: [
      Color.fromRGBO(249, 249, 249, 0.6),
      Color.fromRGBO(220, 216, 255, 0.6),
    ],
  );
  static const categoryBgGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.648, 0.9846],
    colors: [
      Color.fromRGBO(220, 216, 255, 0.6),
      Color.fromRGBO(249, 249, 249, 0.6),
    ],
  );
}
