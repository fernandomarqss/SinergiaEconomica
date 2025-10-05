import 'package:flutter/material.dart';

class AppTheme {
  // Paleta de cores baseada no brasão de Cascavel-PR
  static const Color cascavelGreen = Color(0xFF0F670E); // Verde principal
  static const Color heraldicBlue = Color(0xFF1E3A82); // Azul heraldico
  static const Color crownGold = Color(0xFFEADC25); // Dourado
  static const Color oliveShade = Color(0xFF6E713E); // Verde oliva
  static const Color neutral100 = Color(0xFFEBECEB); // Fundo claro
  static const Color neutral400 = Color(0xFFACB0AD); // Texto secundário
  static const Color neutral900 = Color(0xFF111418); // Texto principal

  // Cores para status de alertas
  static const Color successGreen = cascavelGreen;
  static const Color warningOrange = Color(0xFFFF8C00);
  static const Color errorRed = Color(0xFFD32F2F);
  static const Color infoGold = crownGold;

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: cascavelGreen,
      scaffoldBackgroundColor: neutral100,

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: neutral100,
        foregroundColor: neutral900,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: neutral900,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),

      // Card Theme
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        shadowColor: Colors.black.withValues(alpha: 0.1),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: cascavelGreen,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: heraldicBlue,
          side: const BorderSide(color: heraldicBlue),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: heraldicBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: neutral400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: neutral400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: heraldicBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorRed),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),

      // Dropdown Button Theme
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: neutral400),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: neutral400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: heraldicBlue, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),

      // Text Themes
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: neutral900,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: neutral900,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: neutral900,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: TextStyle(
          color: heraldicBlue,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: heraldicBlue,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: heraldicBlue,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: neutral900,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: neutral900,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        titleSmall: TextStyle(
          color: neutral900,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: neutral900,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: TextStyle(
          color: neutral900,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        bodySmall: TextStyle(
          color: neutral400,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        labelLarge: TextStyle(
          color: neutral900,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        labelMedium: TextStyle(
          color: neutral900,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: TextStyle(
          color: neutral400,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // Cores para gráficos
  static const List<Color> chartColors = [
    heraldicBlue, // Linha principal
    cascavelGreen, // Segunda linha
    crownGold, // Pontos/acentos
    oliveShade, // Linha de apoio
  ];

  // Método para obter cor baseada em delta
  static Color getDeltaColor(double delta) {
    if (delta > 0) return successGreen;
    if (delta < 0) return errorRed;
    return neutral400;
  }

  // Método para obter cor baseada em severidade
  static Color getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
        return errorRed;
      case 'medium':
        return warningOrange;
      case 'low':
        return successGreen;
      case 'info':
        return infoGold;
      default:
        return neutral400;
    }
  }
}
