import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

final appTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF36393f), // Discord Background
  cardColor: const Color(0xFF2f3136), // Discord Card
  canvasColor: const Color(0xFF202225), // Sidebar
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF5865F2), // Discord Blurple
    secondary: Color(0xFF3BA55C), // Discord Green
    surface: Color(0xFF2f3136),
    error: Color(0xFFED4245),
    onSurface: Color(0xFFdcddde),
  ),
  textTheme: GoogleFonts.notoSansKrTextTheme(
    ThemeData.dark().textTheme,
  ).apply(
    bodyColor: const Color(0xFFdcddde),
    displayColor: Colors.white,
  ),
  scrollbarTheme: ScrollbarThemeData(
    thumbColor: WidgetStateProperty.all(const Color(0xFF202225)),
    trackColor: WidgetStateProperty.all(const Color(0xFF2f3136)),
  ),
);
