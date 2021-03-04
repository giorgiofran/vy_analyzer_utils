import 'package:glob/glob.dart';
import 'package:test/test.dart';
import 'package:vy_analyzer_utils/src/dart_source_analysis.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:vy_analyzer_utils/src/value_extractors/dart_object_extractors.dart';

ClassDeclaration? testClassDeclaration;

void main() async {
  var dsa = DartSourceAnalysis(ClassRetriever(),
      resolvedAnalysis: true, fileSelection: Glob('**extractor_class.dart'));
  await dsa.run();

  group('Test Extractors', () {
    test('Test DartObject', () {
      expect(testClassDeclaration, isNotNull);
      var ele = testClassDeclaration?.declaredElement?.getField('intValue');
      expect(dartConstObjectValue(ele?.computeConstantValue()), 2);
    });
  });
}

class ClassRetriever extends GeneralizingAstVisitor<void> {
  @override
  void visitClassDeclaration(ClassDeclaration visitClass) {
    testClassDeclaration = visitClass;
    super.visitClassDeclaration(visitClass);
  }
}
