import 'dart:io';
import 'dart:convert';
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:args/args.dart';
import 'DartAstParser.dart';
void main(List<String> arguments) async {
  arguments = ["-f", "./testfile/test.dart"];
  print(arguments);
  final parser = ArgParser()..addFlag("file", negatable: false, abbr: 'f');
  var argResults = parser.parse(arguments);
  final paths = argResults.rest;
    if (paths.isEmpty) {
    stdout.writeln('No file found');
  } else {
    var ast = await generate(paths[0]);
  }


}

//生成AST
Future generate(String path) async {
  if (path.isEmpty) {
    stdout.writeln("No file found");
  } else {
    await _handleError(path);
    if (exitCode == 2) {
      try {
        print(path);
        var parseResult =
            // ignore: deprecated_member_use
            parseFile(path: "/Users/xiaerfei762/Documents/study/dart/dartAst/testfile/uitest.dart", featureSet: FeatureSet.fromEnableFlags([]));
        var compilationUnit = parseResult.unit;
        //遍历AST
        var astData = compilationUnit.accept(DartAstParser());
        stdout.writeln(jsonEncode(astData));
        return Future.value(astData);
      } catch (e) {
        stdout.writeln('Parse file error: ${e.toString()}');
      }
    }
  }
}

Future _handleError(String path) async {
  if (await FileSystemEntity.isDirectory(path)) {
    stderr.writeln('error: $path is a directory');
  } else {
    exitCode = 2;
  }
}
