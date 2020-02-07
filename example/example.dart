import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:glob/glob.dart';
import 'package:logging/logging.dart';
import 'package:vy_analyzer_utils/src/mixin/ast_unit_info.dart';
import 'package:vy_analyzer_utils/src/vy_analyzer_utils_base.dart';

Logger _log = Logger('Dart Source Analysis');

Future<void> main() async {
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  await DartSourceAnalysis(AnnotationRetriever(),
          fileSelection: Glob('*example/*.dart'), resolvedAnalysis: false)
      .run();
}

class AnnotationRetriever extends GeneralizingAstVisitor<void>
    with AstUnitInfo<void> {
  @override
  void visitAnnotation(Annotation visitAnnotation) {
    _log.info('Scanning source: $sourcePath \n Annotation: $visitAnnotation');

    super.visitAnnotation(visitAnnotation);
  }
}
