import 'package:flutter/material.dart';

const int primaryColorInt = 0xFF0cb9f3;

const Color primaryColor = const Color(primaryColorInt);

const Color hintColor = Colors.grey;

const MaterialColor materialPrimary =
    const MaterialColor(primaryColorInt, <int, Color>{
  50: Color(0xFF86dcf9),
  100: Color(0xFF6dd5f8),
  200: Color(0xFF55cef7),
  300: Color(0xFF3dc7f5),
  400: Color(0xFF25c0f4),
  500: primaryColor,
  600: primaryColor,
  700: primaryColor,
  800: primaryColor,
  900: primaryColor,
});
