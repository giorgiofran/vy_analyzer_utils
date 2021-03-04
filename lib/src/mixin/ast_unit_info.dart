import 'package:analyzer/dart/ast/ast.dart' show AstVisitor;

mixin AstUnitInfo<R> implements AstVisitor<R> {
  String? sourcePath;
}
