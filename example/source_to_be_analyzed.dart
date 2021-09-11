import 'dart:io';
import 'package:glob/glob.dart';

void main() {
  @TestAnnotation()
  var dartFile = Glob('**.dart');
  var dir = Directory.current;
  for (var entity in dir.listSync(recursive: true)) {
    if (dartFile.matches(entity.path)) {
      print('Path: ${entity.path}');
    }
  }
}


class TestAnnotation {
  const TestAnnotation();
}
