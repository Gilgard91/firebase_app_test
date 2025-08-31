import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      // // primarySwatch: Colors.blue,
      // // primaryColor: AppColors.primary,
      // scaffoldBackgroundColor: AppColors.background,
      // // appBarTheme: const AppBarTheme(
      // //   backgroundColor: AppColors.primary,
      // //   foregroundColor: Colors.white,
      // //   elevation: 0,
      // //   titleTextStyle: AppTextStyles.heading2,
      // // ),
      // elevatedButtonTheme: ElevatedButtonThemeData(
      //   style: ElevatedButton.styleFrom(
      //     backgroundColor: AppColors.textPrimary,
      //     foregroundColor: Colors.white,
      //     textStyle: TextStyle(fontWeight: FontWeight.w500),
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(30),
      //     ),
      //   ),
      // ),
      // // textTheme: const TextTheme(
      // //   headlineLarge: AppTextStyles.heading1,
      // //   headlineMedium: AppTextStyles.heading2,
      // //   bodyLarge: AppTextStyles.bodyLarge,
      // //   bodyMedium: AppTextStyles.bodyMedium,
      // // ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFFF0F0F0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Colors.black,
            width: 0.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Colors.black,
            width: 0.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Colors.black,
            width: 0.5,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        labelStyle: TextStyle(
          color: Color(0xFFA4A4A4), // Colore del label
          fontSize: 16,
        ),
        floatingLabelStyle: TextStyle(
          color: Colors.red,
        ),

      ),
      textTheme: GoogleFonts.robotoTextTheme(),
      fontFamily: GoogleFonts.roboto().fontFamily
    );
  }
}

class GradientElevatedButtonPrimary extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double? fontSize;
  final Gradient? gradient;

  const GradientElevatedButtonPrimary({
    super.key,
    required this.text,
    this.onPressed,
    this.width = 200,
    this.fontSize = 20,
    this.gradient = AppColors.textPrimary
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(30),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          elevation: 0,
          textStyle: TextStyle(fontWeight: FontWeight.w500),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(text, style: TextStyle(fontSize: fontSize),),
      ),
    );
  }
}

class GradientElevatedButtonSecondary extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;

  const GradientElevatedButtonSecondary({
    super.key,
    required this.text,
    this.onPressed,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
          minimumSize: Size.zero,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: ShaderMask(
          shaderCallback: (bounds) => AppColors.textPrimary.createShader(
            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}