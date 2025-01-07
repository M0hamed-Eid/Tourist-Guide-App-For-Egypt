import 'package:flutter/material.dart';

class ResponsiveUtils {
  
  static double screenWidth(BuildContext context) => MediaQuery.sizeOf(context).width;
  static double screenHeight(BuildContext context) => MediaQuery.sizeOf(context).height;

  static bool isMobile(BuildContext context) => screenWidth(context) < 600;
  static bool isTablet(BuildContext context) => screenWidth(context) >= 600 && screenWidth(context) < 900;
  static bool isDesktop(BuildContext context) => screenWidth(context) >= 900;

  static double getCardWidth(BuildContext context) {
    if (isMobile(context)) return screenWidth(context) * 0.44;
    if (isTablet(context)) return screenWidth(context) * 0.28;
    return screenWidth(context) * 0.2;
  }

  static double getPopularCardWidth(BuildContext context) {
    if (isMobile(context)) return screenWidth(context) * 0.6;
    if (isTablet(context)) return screenWidth(context) * 0.4;
    return screenWidth(context) * 0.25;
  }

  static int getGridCrossAxisCount(BuildContext context) {
    if (isMobile(context)) return 2;
    if (isTablet(context)) return 3;
    return 4;
  }
}