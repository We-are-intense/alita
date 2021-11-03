import 'AstNode.dart';

class ParserDartAst {
  Map ast = {};
  Map<String, Function> strategy = {};
  ParserDartAst(Map ast) {
    this.ast = ast;
    this.strategy = {
      "FunctionDeclaration":this.parserFunctionDeclaration,
      "VariableDeclarationList": this.parserVariableDeclarationList,
      "IntegerLiteral": this.parserIntegerLiteral,
      "DoubleLiteral": this.parserDoubleLiteral,
      "StringLiteral": this.parserStringLiteral,
      "BinaryExpression": this.parserBinary,
      "ReturnStatement": this.parserReturnStatement,
      "FormalParameterList": this.parserParameterList,
      "BlockStatement": this.parserBlockStatement,
      "Prefix":this.parserUnary,
      "Postfix":this.parserUnary,
      "ForStatement":this.parsertForStatement,
      "IfStatement":this.parserIfStatement,
      "Identifier":this.parserIdentifier,
      "AssignmentExpression":this.parserAssignmentExpression,
      "PropertyAccess":this.parserPropertyAccess,
      "PrefixedIdentifier":this.parserPrefixedIdentifier,
    };
  }
  dynamic strategyFunc(Map? vv) {
    if(vv == null || vv.isEmpty) return null;
    Function? func = this.strategy[vv["type"]];
    if(func == null) return null;
    return func(vv);
  }

  FunctionDecl parserFunctionDeclaration(Map funcDecl) {
    Map id = funcDecl["id"];
    String name = id["name"];
    Map expression = funcDecl["expression"];
    List<Variable>? parameters = strategyFunc(expression["parameters"]);
    String returnType = funcDecl["returnType"]["name"];
    BlockStatement? blockStmt = strategyFunc(expression["body"]);
    return FunctionDecl(name, parameters, returnType, blockStmt!);
  }

  List<Variable>? parserParameterList(Map? parameters) {
    if(parameters == null) return null;
    List parameterList = parameters["parameterList"];
    if(parameterList.isEmpty) return null;
    List<Variable> paramList = [];
    for (Map item in parameterList) {
      var type = item["paramType"]["name"];
      var name = item["name"];
      if(type && name) {
        paramList.add(Variable(name, type));
      }
    }
    return paramList;
  }

  BlockStatement parserBlockStatement(Map? body) {
    List<Statement> stmts = [];

    return BlockStatement(stmts);
  }

  VariableDecl? parserVariableDeclarationList(Map? vari) {
    if(vari == null) return null;
    String type = vari["typeAnnotation"]["name"];
    List declarations = vari["declarations"];
    if(declarations.isEmpty) return null;
    Map first = declarations.first;
    String name = first["id"]["name"];
    var init = strategyFunc(first["init"]);
    return VariableDecl(name, type, init);
  }

  IntegerLiteral? parserIntegerLiteral(Map ii) {
    return IntegerLiteral(ii["value"]);
  }
  DoubleLiteral? parserDoubleLiteral(Map dd) {
    return DoubleLiteral(dd["value"]);
  }
  StringLiteral? parserStringLiteral(Map ss) {
    return StringLiteral(ss["value"]);
  }

  Binary? parserBinary(Map bb) {
    String operator = bb["operator"];

    Expression? left  = strategyFunc(bb["left"]);
    Expression? right = strategyFunc(bb["right"]);

    if(left != null && right != null) {
      return Binary(operator, left, right);
    }
    return null;
  }
  String? parserIdentifier(Map ii) {
    /*
    "id": {
          "type": "Identifier",
          "name": "mainAxisSize"
      }
     */
    return ii["name"];
  }
  ReturnStatement? parserReturnStatement(Map rr) {
    Expression? exp = strategyFunc(rr["argument"]);
    if(exp == null) return null;
    return ReturnStatement(exp);
  }

  IfStatement? parserIfStatement(Map ii) {
    Expression? condition = strategyFunc(ii["condition"]);
    List<Statement>? thenStatement = strategyFunc(ii["thenStatement"]);
    List<Statement>? elseStatement = strategyFunc(ii["elseStatement"]);
    if(condition == null || thenStatement == null) return null;
    return IfStatement(condition, thenStatement, elseStatement);
  }

  ForStatement? parsertForStatement(Map ff) {
    Expression? init = strategyFunc(ff["loop"]["init"]);
    Expression? condition = strategyFunc(ff["loop"]["condition"]);
    Expression? updaters = strategyFunc(ff["loop"]["updaters"]);
    BlockStatement? blockStatement = strategyFunc(ff["body"]);
    if(blockStatement == null) return null;
    return ForStatement(init, condition, updaters, blockStatement);
  }

  Unary? parserUnary(Map uu) {
    String? op = uu["operator"];
    bool isPrefix = false;
    if(uu["type"] == "Prefix") {
      isPrefix = true;
    }
    Expression? exp = strategyFunc(uu["express"]);
    if(exp == null || op == null) return null;
    return Unary(op, exp, isPrefix);
  }

  Binary? parserAssignmentExpression(Map bb) {
    String op = "=";
    Expression? left = strategyFunc(bb["left"]);
    Expression? right = strategyFunc(bb["right"]);
    if(left == null || right == null) return null;
    return Binary(op, left, right);
  }

  Binary? parserPropertyAccess(Map bb) {
    String op = ".";
    Expression? left = strategyFunc(bb["expression"]);
    Expression? right = strategyFunc(bb["id"]);
    if(left == null || right == null) return null;
    return Binary(op, left, right);
  }

  Binary? parserPrefixedIdentifier(Map bb) {
    /*
      "type": "PrefixedIdentifier",
      "identifier": {
          "type": "Identifier",
          "name": "length"
      },
      "prefix": {
          "type": "Identifier",
          "name": "dd"
      }
     */
    String op = ".";
    Expression? left = strategyFunc(bb["prefix"]);
    Expression? right = strategyFunc(bb["identifier"]);
    if(left == null || right == null) return null;
    return Binary(op, left, right);
  }

  FunctionCall? parserMethodInvocation(Map bb) {

  }

  Binary? parserMemberExpression(Map bb) {

  }

  





}
