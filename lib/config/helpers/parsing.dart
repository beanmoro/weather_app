class Parsing {
  static double tryDouble(dynamic value) {
    return value is String ? double.tryParse(value) : value;
  }

  static int tryInt(dynamic value) {
    return value is String ? int.tryParse(value) : value;
  }
}
