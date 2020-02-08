class ExtractorClass {
  static const String stringValue = 'Value';
  static const bool boolValue = true;
  static const num numValue = 1;
  static const int intValue = 2, intValue2 = 4, intValue3 = 7;
  static const double doubleValue = 3.0;
  static const List<int> listValue = <int>[1, 2, 3];
  static const Map<String, bool> mapValues = <String, bool>{
    '1': true,
    '2': false
  };
  static const Set<int> setValues = <int>{7, 8, 9};

  const ExtractorClass();

  int testValues() {
    return 4;
  }
}
