class RegularExpressions {
  RegularExpressions._();
  static var denyLeadingZero = RegExp(r'^(?:[1-9]\d*)?$');
  static final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
}


