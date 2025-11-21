import 'package:flutter/material.dart';

final appTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF36393f), // Discord 배경색
  cardColor: const Color(0xFF2f3136), // Discord 카드색
  canvasColor: const Color(0xFF202225), // 사이드바 배경색
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF5865F2), // Discord Blurple
    secondary: Color(0xFF3BA55C), // Discord Green
    surface: Color(0xFF2f3136),
    error: Color(0xFFED4245),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Color(0xFFdcddde)),
    titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  ),
  scrollbarTheme: ScrollbarThemeData(
    thumbColor: MaterialStateProperty.all(const Color(0xFF202225)),
    trackColor: MaterialStateProperty.all(const Color(0xFF2f3136)),
  ),
);
