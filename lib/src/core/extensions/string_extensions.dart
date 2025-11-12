extension StringExtensions on String {
  String get appendAsterisk {
    return "$this*";
  }

  String? get withoutBopos {
    return this?.replaceAll('bopos', '');
  }
}
