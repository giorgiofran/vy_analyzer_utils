import 'package:glob/glob.dart';
import 'package:test/test.dart';
import 'package:vy_analyzer_utils/src/dart_source_analysis.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:vy_analyzer_utils/src/value_extractors/dart_object_extractors.dart';

ClassDeclaration testClassDeclaration;

void main() async {
  var dsa = DartSourceAnalysis(ClassRetriever(),
      resolvedAnalysis: true, fileSelection: Glob('**extractor_class.dart'));
  await dsa.run();

  group('Test Extractors', () {
    test('Test DartObject', () {
      expect(testClassDeclaration, isNotNull);
      print(testClassDeclaration.members);
      print(testClassDeclaration.members[3]);
      FieldDeclaration member = testClassDeclaration.members[3];
      print('Member: ${member.toSource()}');
      print(member.fields.variables.last.name);
      print(member.fields.variables.last.initializer);
      print(member.fields.variables.last.initializer.staticType);
      print(member.fields.variables.last.initializer.childEntities);
      var inniz = member.fields.variables.last.initializer;
      print(inniz.toSource());
      print(inniz.childEntities.first.toString());
      var tv =
          testClassDeclaration.declaredElement.getMethod('testValues');
      MethodDeclaration med = testClassDeclaration.members.last;
      print(med.childEntities);
      print(med.toSource());

      var ele =
          testClassDeclaration.declaredElement.getField('intValue');
      expect(dartConstObjectValue(ele.computeConstantValue()), 2);
      print(ele.isConst);
      print(ele.displayName);
      print(ele.name);
      print(ele.id);
      print(ele.type);
      print(ele.declaration.displayName);
      print(ele.hasLiteral);
      //print(ele.library.definingCompilationUnit.source.contents.data);
      var source = ele.library.definingCompilationUnit.source.contents.data;
      print(ele.nameOffset);
      print(ele.nameLength);
      print(source.substring(ele.nameOffset, ele.nameOffset + ele.nameLength));
      print(ele.location.components);
      print(ele.enclosingElement.toString());
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
