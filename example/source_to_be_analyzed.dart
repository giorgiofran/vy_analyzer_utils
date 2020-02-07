import 'dart:io';
import 'package:glob/glob.dart';

void main() {
  @deprecated
  var dartFile = Glob('**.dart');
  Directory dir = Directory.current;
  for (FileSystemEntity entity in dir.listSync(recursive: true)) {
    if (dartFile.matches(entity.path)) {
      print('Path: ${entity.path}');
    }
  }
}
