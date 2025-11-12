import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neuconnectz_dynea/src/core/constants/app_palette.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Color primaryColor = Color(0xFF1B59F8);

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit()
    : super(_buildTheme(primaryColor, Brightness.light, _fontFamily)) {
    _loadTheme();
  }

  static const _colorKey = 'theme_color';
  static const _brightnessKey = 'theme_brightness';

  /// Color and Brightness
  Color _selectedColor = primaryColor;
  Brightness _brightness = Brightness.dark;
  bool get isDarkMode => _brightness == Brightness.dark;

  /// Font Family
  static const _fontStyleKey = 'font_style';
  static String _fontFamily = 'Inter';
  String get fontFamily => _fontFamily;

  static ThemeData _buildTheme(
    Color color,
    Brightness brightness,
    String fontFamily,
  ) {
    return ThemeData(
      fontFamily: fontFamily,
      // primaryColor: AppPalette.primaryColor,
      primaryColor: color,
      colorScheme: ColorScheme.fromSeed(
        seedColor: color,
        brightness: brightness,
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: brightness == Brightness.dark ? Colors.black : Colors.black,
        ),
      ),
      iconTheme: IconThemeData(color: color),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: color,
      ),
      chipTheme: ChipThemeData(backgroundColor: color),
      scaffoldBackgroundColor: AppPalette.scaffoldBackgroundColor,
      useMaterial3: true,
    );
  }

  /// Call this method with a custom color from a color picker.
  Future<void> changeTheme(Color color) async {
    _selectedColor = color;
    await _persistTheme();
    emit(_buildTheme(_selectedColor, _brightness, _fontFamily));
  }

  /// Toggles between light and dark mode.
  Future<void> toggleBrightness() async {
    _brightness =
        _brightness == Brightness.light ? Brightness.dark : Brightness.light;
    await _persistTheme();
    emit(_buildTheme(_selectedColor, _brightness, _fontFamily));
  }

  /// Persist the selected theme color and brightness to local storage.
  Future<void> _persistTheme() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_colorKey, _selectedColor.toARGB32());
    await prefs.setBool(_brightnessKey, _brightness == Brightness.dark);
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedColor = prefs.getInt(_colorKey);
    final isDark = prefs.getBool(_brightnessKey);

    _selectedColor = Color(savedColor ?? 0xFF1B59F8);
    _fontFamily = prefs.getString(_fontStyleKey) ?? 'Inter';
    _brightness = (isDark ?? false) ? Brightness.dark : Brightness.light;

    emit(_buildTheme(_selectedColor, _brightness, _fontFamily));
  }

  Future<void> changeFontFamily(String font) async {
    _fontFamily = font;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fontStyleKey, font);
    emit(_buildTheme(_selectedColor, _brightness, _fontFamily));
  }
}
