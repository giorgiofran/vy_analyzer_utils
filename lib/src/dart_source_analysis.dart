import 'dart:io' show Directory, Platform;

import 'package:glob/glob.dart' show Glob;
import 'package:logging/logging.dart' show Logger;
import 'package:analyzer/dart/analysis/analysis_context_collection.dart'
    show AnalysisContextCollection;
import 'package:analyzer/dart/analysis/analysis_context.dart'
    show AnalysisContext;
import 'package:analyzer/dart/analysis/session.dart' show AnalysisSession;
import 'package:analyzer/dart/analysis/results.dart'
    show ParsedUnitResult, ResolvedUnitResult;
import 'package:analyzer/dart/ast/ast.dart' show AstVisitor, CompilationUnit;
import 'package:analyzer/file_system/physical_file_system.dart'
    show PhysicalResourceProvider;

import 'mixin/ast_unit_info.dart';

final dartFile = Glob('**.dart');

class DartSourceAnalysis {
  final Directory dir;
  final Glob fileSelection;
  final AstVisitor visitor;
  final bool resolvedAnalysis;
  final Logger _log = Logger('Source analysis');

  DartSourceAnalysis(this.visitor,
      {this.dir, Glob fileSelection, bool resolvedAnalysis})
      : fileSelection = fileSelection ?? dartFile,
        resolvedAnalysis = resolvedAnalysis ?? true;

  Future<void> run() async {
    var collection =
        getAnalysisContextCollection(dir ?? Directory.current);
    await analyzeAllFiles(collection);
  }

  Future<void> analyzeAllFiles(AnalysisContextCollection collection) async {
    for (var context in collection.contexts) {
      _log.info('Analyzing files "$fileSelection" in context: '
          '${context.contextRoot.root.path}');
      for (var path in context.contextRoot.analyzedFiles()) {
        if (fileSelection.matches(path)) {
          await analyzeSingleFile(context, path);
        }
      }
    }
  }

  Future<void> analyzeSingleFile(AnalysisContext context, String path) async {
    _log.fine('Analyzing source: $path');
    var session = context.currentSession;
    CompilationUnit unit;
    if (resolvedAnalysis) {
      unit = await processResolvedFile(session, path);
    } else {
      unit = processUnresolvedFile(session, path);
    }
    if (visitor is AstUnitInfo) {
      unit.accept<void>((visitor as AstUnitInfo)..sourcePath = path);
    } else {
      unit.accept<void>(visitor);
    }
  }

  /// Unresolved AST
  CompilationUnit processUnresolvedFile(AnalysisSession session, String path) {
    // ignore: omit_local_variable_types
    ParsedUnitResult result = session.getParsedUnit(path);
    return result.unit;
  }

  /// Resolved AST
  Future<CompilationUnit> processResolvedFile(
      AnalysisSession session, String path) async {
    // ignore: omit_local_variable_types
    ResolvedUnitResult result = await session.getResolvedUnit(path);
    return result.unit;
  }

  AnalysisContextCollection getAnalysisContextCollection(Directory directory) {
    var path = PhysicalResourceProvider.INSTANCE.pathContext.normalize(
        directory.absolute.uri.toFilePath(windows: Platform.isWindows));
    return AnalysisContextCollection(includedPaths: [path]);
  }
}
