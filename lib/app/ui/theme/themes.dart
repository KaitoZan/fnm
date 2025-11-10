import 'package:flutter/material.dart';

import 'color.dart';

class Themes {
  final lightTheme = ThemeData.light().copyWith(
    // primaryColor: AppColors.primary,
    primaryColor: Colors.blue,
    colorScheme: ColorScheme.light(
      //   primary: AppColors.primary,
      primary: Colors.blue,
      // secondary: AppColors.secondary,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      surface: Colors.white,
      onSurface: Colors.black,
    ),
    // accentColor: Colors.amber,
    cardColor: Colors.white,
    scaffoldBackgroundColor: Colors.grey[200],
    shadowColor: Colors.grey,
    appBarTheme: const AppBarTheme(
      color: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
    ),
    textTheme: ThemeData.light().textTheme.apply(
          fontFamily: 'Inter',
        ),
  );

  final darkTheme = ThemeData.dark().copyWith(
    primaryColor: Colors.grey[900],
    colorScheme: ColorScheme.dark(
      primary: Colors.grey[900]!,
      // secondary: Colors.grey[700]!,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      surface: Colors.grey[800]!,
      onSurface: Colors.white,
    ),
    // accentColor: Colors.grey[300],
    cardColor: Colors.grey[900],
    scaffoldBackgroundColor: Colors.grey[800],
    shadowColor: Colors.grey,
    appBarTheme: AppBarTheme(
      color: Colors.grey[900],
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
    ),
    textTheme: ThemeData.dark().textTheme.apply(
          fontFamily: 'Inter',
        ),
  );
}
