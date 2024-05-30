import 'package:flutter/material.dart';

class Palette {
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF007bff),
    secondary: Color(0xFF6c757d),
    surface: Color(0xFFf4f5f7),
    error: Color(0xFFd32f2f),
    onPrimary: Color(0xFFFFFFFF),
    onSecondary: Color(0xFFFFFFFF),
    onSurface: Color(0xFF000000),
    onError: Color(0xFFFFFFFF),
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF00b8d4),
    secondary: Color(0xFFa8dadc),
    surface: Color(0xFF1e1e1e),
    error: Color(0xFFcf6679),
    onPrimary: Color(0xFFFFFFFF),
    onSecondary: Color(0xFFFFFFFF),
    onSurface: Color(0xFFFFFFFF),
    onError: Color(0xFFFFFFFF),
  );

  static ThemeData lightTheme = ThemeData(
    colorScheme: lightColorScheme,
    scaffoldBackgroundColor: Palette.lightColorScheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: Palette.lightColorScheme.primary,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: darkColorScheme,
    scaffoldBackgroundColor: Palette.darkColorScheme.surface,
    appBarTheme: AppBarTheme(
    backgroundColor: Palette.darkColorScheme.primary,
    )
  );
}