import 'package:flutter/material.dart';

class Themes {
  static final ThemeData lightTheme = ThemeData(
    // modify #IT-131 Mak Mach 2024-05-19
    hintColor: Colors.grey.shade500,
    brightness: Brightness.light,
    primaryColor: Colors.white,
    primaryTextTheme: const TextTheme(
      titleLarge: TextStyle(color: Colors.blueAccent),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
    ),
    scaffoldBackgroundColor: Colors.grey.shade200,
    // add #-129 Pithak 2024-05-21
    colorScheme: ColorScheme.light(
      background: Colors.black12, // modify #-129 Pithak 2024-05-21
      primary: Colors.white,
      secondary: Colors.grey.shade300,
      inversePrimary: Colors.grey.shade800,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.transparent,
      backgroundColor: Colors.grey.shade200, // add #-129 Pithak 2024-05-21
      elevation: 0,
    ),
    cardColor: Colors.white,
    canvasColor: Colors.grey.shade300.withOpacity(0.4),
  );

  static final ThemeData darkTheme = ThemeData(
    // modify #IT-131 Mak Mach 2024-05-19
    hintColor: Colors.grey.shade400,
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
    ),
    scaffoldBackgroundColor: const Color(0xff1a1818),
    // modify #-139 Pithak 2024-05-21
    colorScheme: const ColorScheme.dark(
      background: Colors.black54, // modify #-129 Pithak 2024-05-21
      primary: Color(0xff2f2c2c), // modify #-139 Pithak 2024-05-21
      secondary: Color(0xFF463D3D),
      inversePrimary: Colors.white,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      // modify #-129 Pithak 2024-05-21
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    cardColor: Colors.white10,
    canvasColor: Colors.black12.withOpacity(0.1),
  );
}
