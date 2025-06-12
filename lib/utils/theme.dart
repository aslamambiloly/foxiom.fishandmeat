import 'package:flutter/material.dart';
import 'package:ecom_one/utils/colors.dart';

class AppThemes {
  static final primaryColour = AppColors.primaryColour;

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Sora-Bold',
    progressIndicatorTheme: ProgressIndicatorThemeData(color: Colors.grey[700]),
    brightness: Brightness.light,
    primaryColor: primaryColour,
    scaffoldBackgroundColor: const Color(0xFFFEFFFE),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.grey,
      foregroundColor: Colors.white,
      shadowColor: Color(0xff2f2f2f),
      //elevation: 10
    ),
    textTheme: const TextTheme(bodyMedium: TextStyle(color: Color(0xFF0D0D0D))),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      backgroundColor: AppColors.primaryColour,
      foregroundColor: Color(0xFF2F2F2F),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Color(0xFF2F2F2F),
      contentTextStyle: TextStyle(color: Colors.white),
      actionTextColor: AppColors.primaryColour,
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryColour,
      inactiveTrackColor: Colors.grey,
      thumbColor: primaryColour,
    ),

    dialogTheme: const DialogThemeData(
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      contentTextStyle: TextStyle(color: Colors.black),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColour,
        foregroundColor: Colors.black,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: primaryColour,
        foregroundColor: Colors.black,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      labelStyle: const TextStyle(color: Colors.black),
      hintStyle: const TextStyle(color: Colors.grey),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(15),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColour, width: 2),
        borderRadius: BorderRadius.circular(15),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 2),
        borderRadius: BorderRadius.circular(15),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        borderRadius: BorderRadius.circular(15),
      ),
    ),

    checkboxTheme: CheckboxThemeData(
      checkColor: WidgetStateProperty.all(Colors.white),
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryColour; // Checked color
        }
        return Colors.grey; // Default color
      }),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryColour;
        }
        return Colors.grey;
      }),
    ),
    switchTheme: SwitchThemeData(
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryColour.withAlpha((0.5 * 255).round());
        }
        return Colors.grey;
      }),
      thumbColor: WidgetStateProperty.all(primaryColour),
    ),

    tabBarTheme: TabBarThemeData(
      labelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 16),
      unselectedLabelStyle: const TextStyle(fontFamily: 'Poppins-Medium'),
      labelColor: primaryColour,
      unselectedLabelColor: const Color(0xFFFEFFFE),
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: primaryColour, width: 2),
      ),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.grey, // Light theme background
      selectedItemColor: primaryColour,
      unselectedItemColor: Colors.white,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    ),

    /// == CARD THEME ==
    /// Use CardThemeData instead of CardTheme
    cardTheme: CardThemeData(
      color: primaryColour,
      shadowColor: Colors.black54,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    progressIndicatorTheme: ProgressIndicatorThemeData(color: Colors.grey[700]),
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF212121),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF2F2F2F),
      foregroundColor: Colors.white,
      elevation: 10,
    ),
    textTheme: const TextTheme(bodyMedium: TextStyle(color: Color(0xFFFEFFFE))),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      backgroundColor: Color(0xFF2F2F2F),
      foregroundColor: AppColors.primaryColour,
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Colors.black,
      contentTextStyle: TextStyle(color: Colors.white),
      actionTextColor: AppColors.primaryColour,
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryColour,
      inactiveTrackColor: Colors.grey,
      thumbColor: primaryColour,
    ),

    /// == DIALOG THEME ==
    /// Use DialogThemeData instead of DialogTheme
    dialogTheme: const DialogThemeData(
      backgroundColor: Color(0xFF2F2F2F),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      contentTextStyle: TextStyle(color: Colors.white),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2F2F2F),
        overlayColor: const Color(0xFF0D0D0D),
        foregroundColor: primaryColour,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: const Color(0xFF2F2F2F),
        foregroundColor: primaryColour,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2F2F2F),
      labelStyle: const TextStyle(color: Colors.white, fontFamily: 'Sora-Bold'),
      hintStyle: const TextStyle(color: Colors.grey),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFF2F2F2F), width: 2),
        borderRadius: BorderRadius.circular(15),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.foxiomOriginalBlue, width: 2),
        borderRadius: BorderRadius.circular(15),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 2),
        borderRadius: BorderRadius.circular(15),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        borderRadius: BorderRadius.circular(15),
      ),
    ),

    checkboxTheme: CheckboxThemeData(
      checkColor: WidgetStateProperty.all(Colors.black),
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryColour;
        }
        return Colors.grey;
      }),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryColour;
        }
        return Colors.grey;
      }),
    ),
    switchTheme: SwitchThemeData(
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryColour.withAlpha((0.5 * 255).round());
        }
        return Colors.grey;
      }),
      thumbColor: WidgetStateProperty.all(primaryColour),
    ),

    tabBarTheme: TabBarThemeData(
      labelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 16),
      unselectedLabelStyle: const TextStyle(fontFamily: 'Poppins-Medium'),
      labelColor: primaryColour,
      unselectedLabelColor: Colors.grey,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: primaryColour, width: 2),
      ),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color(0xFF2F2F2F), // Dark theme background
      selectedItemColor: primaryColour,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    ),

    cardTheme: CardThemeData(
      color: const Color(0xFF2F2F2F),
      shadowColor: Colors.black54,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}
