extension StringExtensions on String {
  String get appendAsterisk {
    return "$this*";
  }

  String? get withoutBopos {
    return this?.replaceAll('bopos', '');
  }

  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
