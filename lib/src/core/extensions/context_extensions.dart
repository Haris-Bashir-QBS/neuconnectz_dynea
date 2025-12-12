import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
  Color get primaryColor => Theme.of(this).primaryColor;
  Color get primaryColorLight => Theme.of(this).colorScheme.primaryContainer;
  bool get bottomInsetsZero => MediaQuery.of(this).viewInsets.bottom == 0;
  void unfocusFocusScope() {
    FocusScope.of(this).unfocus();
  }
}


