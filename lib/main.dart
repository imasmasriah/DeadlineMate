import 'package:flutter/material.dart';
import 'login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Color softPink = Color(0xFFFCE4EC);
  static const Color deepPink = Color(0xFFE91E63);
  static const Color primaryText = Color(0xFF333333);
  static const Color secondaryText = Color(0xFF9E9E9E);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskFlow: Atur Deadline Anda',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(
          seedColor: deepPink,
          primary: deepPink,
          secondary: const Color(0xFFE8F5E9),
          background: softPink,
          surface: Colors.white,
          onPrimary: Colors.white,
          onBackground: primaryText,
          onSurface: primaryText,
        ),
        scaffoldBackgroundColor: softPink,
        textTheme: TextTheme(
          bodyLarge: const TextStyle(color: primaryText),
          bodyMedium: const TextStyle(color: primaryText),
          titleLarge:
              const TextStyle(color: primaryText, fontWeight: FontWeight.bold),
          titleMedium:
              const TextStyle(color: primaryText, fontWeight: FontWeight.w600),
          labelLarge: const TextStyle(color: primaryText),
          bodySmall: TextStyle(color: secondaryText),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(
              color: deepPink,
              width: 2.0,
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          hintStyle: TextStyle(color: secondaryText.withOpacity(0.8)),
          labelStyle: const TextStyle(color: primaryText),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: deepPink,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            elevation: 4.0,
          ),
        ),
      ),
      home: const LoginPage(),
    );
  }
}
