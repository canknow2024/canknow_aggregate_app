import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color.fromRGBO(66, 176, 73, 1);
  static const Color backgroundColor = Color.fromRGBO(245, 245, 245, 1);
  static const double borderRadius = 6;
  static const double moduleBorderRadius = 16;
  static const double cardBorderRadius = 12;
  static const double contentPadding = 12;
  static const double contentPaddingSmall = 6;
  static const double componentSpan = 12;

  static const fontSizeSmall = 12.0;
  static const fontSizeMedium = 14.0;
  static const fontSizeLarge = 16.0;
  static const fontSizeExtraLarge = 18.0;

  // displayLarge	57.0	w400 (Normal)	Colors.black87	1.12
  // displayMedium	45.0	w400	Colors.black87	1.16
  // displaySmall	36.0	w400	Colors.black87	1.22
  // headlineLarge	32.0	w400	Colors.black87	1.25
  // headlineMedium	28.0	w400	Colors.black87	1.29
  // headlineSmall	24.0	w400	Colors.black87	1.33
  // titleLarge	22.0	w400	Colors.black87	1.27
  // titleMedium	16.0	w500 (Medium)	Colors.black87	1.25
  // titleSmall	14.0	w500	Colors.black87	1.21
  // bodyLarge	16.0	w400	Colors.black87	1.5
  // bodyMedium	14.0	w400	Colors.black87	1.43
  // bodySmall	12.0	w400	Colors.black54	1.33
  // labelLarge	14.0	w500	Colors.black87	1.43
  // labelMedium	12.0	w500	Colors.black87	1.33
  // labelSmall	11.0	w500	Colors.black87	1.45

  static final light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: primaryColor,
      onSecondary: Colors.white,
      surface: Colors.white,
      onSurface: Colors.black87,
    ),
    scaffoldBackgroundColor: backgroundColor,
    dividerTheme: DividerThemeData(
      color: Colors.grey[200],
    ),
    iconTheme: IconThemeData(
      size: 20,
      color: Colors.grey[600],
    ),
    fontFamily: 'PingFang SC',
    unselectedWidgetColor: Colors.grey[300],
    textTheme: TextTheme(
      titleLarge: TextStyle(fontSize: fontSizeExtraLarge, color: Colors.black87),
      titleMedium: TextStyle(fontSize: fontSizeLarge, color: Colors.black87),
      titleSmall: TextStyle(fontSize: fontSizeMedium, color: Colors.black87),
      bodyLarge: TextStyle(fontSize: fontSizeExtraLarge, color: Colors.grey[800]),
      bodyMedium: TextStyle(fontSize: fontSizeMedium, color: Colors.grey[800]),
      bodySmall: TextStyle(fontSize: fontSizeSmall, color: Colors.grey[600]),
      labelLarge: TextStyle(fontSize: fontSizeLarge, color: Colors.black87),
      labelMedium: TextStyle(fontSize: fontSizeMedium, color: Colors.grey),
      labelSmall: TextStyle(fontSize: fontSizeSmall, color: Colors.grey),
    ),
    listTileTheme: ListTileThemeData(
      tileColor: Colors.white,
      titleTextStyle: TextStyle(fontSize: fontSizeLarge, color: Colors.black87),
      subtitleTextStyle: TextStyle(fontSize: fontSizeMedium, color: Colors.grey[600]),
      leadingAndTrailingTextStyle: TextStyle(fontSize: fontSizeMedium, color: Colors.grey[600]),
      contentPadding: EdgeInsets.symmetric(horizontal: contentPadding),
      iconColor: Colors.grey[600],
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: EdgeInsets.symmetric(vertical: contentPadding),
        textStyle: TextStyle(
            fontSize: fontSizeLarge,
            height: 1.5
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        elevation: 0,
        side: const BorderSide(color: primaryColor, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: EdgeInsets.symmetric(vertical: contentPadding),
        textStyle: TextStyle(
            fontSize: fontSizeLarge,
            height: 1.5
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        textStyle: const TextStyle(fontSize: fontSizeLarge),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: primaryColor),
      ),
      filled: false,
      fillColor: Colors.grey[100],
      contentPadding: EdgeInsets.symmetric(vertical: contentPadding, horizontal: contentPadding),
      hintStyle: TextStyle(color: Colors.grey[500], fontSize: fontSizeLarge),
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
      side: BorderSide(color: Colors.grey[300]!),
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black87),
      titleTextStyle: TextStyle(color: Colors.black, fontSize: fontSizeLarge, fontWeight: FontWeight.normal),
      centerTitle: true,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(borderRadius)),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 0,
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      highlightElevation: 0,
      shape: CircleBorder(),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 14)),
        minimumSize: MaterialStateProperty.all(const Size(0, 44)),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        )),
        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: contentPadding, vertical: contentPadding)),
        side: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const BorderSide(color: primaryColor, width: 1);
          }
          return BorderSide(color: Colors.grey[300]!, width: 1);
        }),
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryColor;
          }
          return Colors.white;
        }),
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.white;
          }
          return primaryColor;
        }),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(
        fontSize: 18,
        color: Colors.black87,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(moduleBorderRadius),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(moduleBorderRadius),
          topRight: Radius.circular(moduleBorderRadius),
        ),
      ),
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(moduleBorderRadius),
      ),
    ),
    chipTheme: ChipThemeData(
      elevation: 0,
      shadowColor: Colors.transparent,
      labelStyle: TextStyle(
        fontSize: 14,
        color: Colors.black87,
      ),
      selectedColor: primaryColor,
      secondaryLabelStyle: TextStyle(
        fontSize: 14,
        color: Colors.white,
      ),
      side: BorderSide(
        color: Colors.grey[300]!,
        width: 1,
      ),
    ),
    cupertinoOverrideTheme: CupertinoThemeData(
      primaryColor: primaryColor,
    ),
  );

  static final dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
      primary: primaryColor,
      onPrimary: Colors.black,
      secondary: primaryColor,
      onSecondary: Colors.black,
      surface: Color(0xFF23272F),
      onSurface: Colors.white,
    ),
    scaffoldBackgroundColor: Color(0xFF181A20),
    dividerTheme: const DividerThemeData(
      color: Colors.white24,
    ),
    iconTheme: IconThemeData(
      size: 20,
      color: Colors.grey[300],
    ),
    fontFamily: 'PingFang SC',
    unselectedWidgetColor: Colors.grey[700],
    textTheme: TextTheme(
      titleLarge: TextStyle(fontSize: fontSizeLarge, color: Colors.white),
      titleMedium: TextStyle(fontSize: fontSizeLarge, color: Colors.white),
      titleSmall: TextStyle(fontSize: fontSizeMedium, color: Colors.white),
      bodyLarge: TextStyle(fontSize: fontSizeLarge, color: Colors.grey[200]),
      bodyMedium: TextStyle(fontSize: fontSizeMedium, color: Colors.grey[200]),
      bodySmall: TextStyle(fontSize: fontSizeSmall, color: Colors.grey[400]),
      labelLarge: TextStyle(fontSize: fontSizeLarge, color: Colors.white),
      labelMedium: TextStyle(fontSize: fontSizeMedium, color: Colors.grey[300]),
      labelSmall: TextStyle(fontSize: fontSizeSmall, color: Colors.grey[500]),
    ),
    listTileTheme: ListTileThemeData(
      tileColor: Color(0xFF23272F),
      titleTextStyle: TextStyle(fontSize: fontSizeLarge, color: Colors.white),
      subtitleTextStyle: TextStyle(fontSize: fontSizeMedium, color: Colors.grey[400]),
      leadingAndTrailingTextStyle: TextStyle(fontSize: fontSizeMedium, color: Colors.grey[400]),
      contentPadding: EdgeInsets.symmetric(horizontal: contentPadding),
      iconColor: Colors.grey[300],
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: EdgeInsets.symmetric(vertical: contentPadding),
        textStyle: TextStyle(
            fontSize: fontSizeLarge,
            height: 1.5
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        elevation: 0,
        side: const BorderSide(color: primaryColor, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: EdgeInsets.symmetric(vertical: contentPadding),
        textStyle: TextStyle(
            fontSize: fontSizeLarge,
            height: 1.5
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        textStyle: const TextStyle(fontSize: fontSizeLarge),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: Colors.grey[700]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: Colors.grey[700]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: primaryColor),
      ),
      filled: false,
      fillColor: Colors.white24,
      contentPadding: EdgeInsets.symmetric(vertical: contentPadding, horizontal: contentPadding),
      hintStyle: TextStyle(color: Colors.grey[500], fontSize: fontSizeLarge),
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
      side: BorderSide(color: Colors.grey[700]!),
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: fontSizeLarge, fontWeight: FontWeight.normal),
      centerTitle: true,
    ),
    cardTheme: CardThemeData(
      color: Color(0xFF23272F),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(borderRadius)),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 0,
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      highlightElevation: 0,
      shape: CircleBorder(),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      showUnselectedLabels: true,
      backgroundColor: Color(0xFF23272F),
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.white70,
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all(const TextStyle(fontSize: fontSizeMedium)),
        minimumSize: MaterialStateProperty.all(const Size(0, 44)),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        )),
        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: contentPadding, vertical: contentPadding)),
        side: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const BorderSide(color: primaryColor, width: 1);
          }
          return BorderSide(color: Colors.grey[700]!, width: 1);
        }),
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryColor;
          }
          return Color(0xFF23272F);
        }),
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.white;
          }
          return primaryColor;
        }),
      ),
    ),
    dialogTheme: DialogThemeData(
      titleTextStyle: TextStyle(
        fontSize: fontSizeExtraLarge,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(moduleBorderRadius),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(moduleBorderRadius),
          topRight: Radius.circular(moduleBorderRadius),
        ),
      ),
    ),
  );
}