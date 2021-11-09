import '../dart2wx/dart2wx.dart';
import 'AstNode.dart';
import 'dart:io';
import 'dart:convert' as convert;

class ParserDartAst {
  Map ast = {};
  Map<String, Function> strategy = {};
  ParserDartAst(Map ast) {
    this.ast = ast;
    this.strategy = {
      "FunctionDeclaration":this.parserFunctionDeclaration,
      "FunctionExpression":this.parserFunctionExpression,
      "VariableDeclarationList": this.parserVariableDeclarationList,
      "IntegerLiteral": this.parserIntegerLiteral,
      "DoubleLiteral": this.parserDoubleLiteral,
      "StringLiteral": this.parserStringLiteral,
      "BinaryExpression": this.parserBinary,
      "ReturnStatement": this.parserReturnStatement,
      "FormalParameterList": this.parserParameterList,
      "SimpleFormalParameter": this.parserParameterList,
      "BlockStatement": this.parserBlockStatement,
      "Prefix":this.parserUnary,
      "Postfix":this.parserUnary,
      "ForStatement":this.parsertForStatement,
      "IfStatement":this.parserIfStatement,
      "Identifier":this.parserIdentifier,
      "AssignmentExpression":this.parserAssignmentExpression,
      "PropertyAccess":this.parserPropertyAccess,
      "PrefixedIdentifier":this.parserPrefixedIdentifier,
      "MethodInvocation":this.parserMethodInvocation,
      "MemberExpression":this.parserMemberExpression,
      "ArgumentList":this.parserArgumentList,
      "ClassDeclaration":this.parserClassDeclaration,
      "FieldDeclaration":this.parserFieldDeclaration,
      "MethodDeclaration":this.parserMethodDeclaration,
      "ReturnType":this.parserReturnType,
      "NamedExpression":this.parserNamedExpression,
      "InstanceCreationExpression":this.parserInstanceCreationExpression,
      "ListLiteral":this.parserListLiteral,
      "IndexExpression":this.parserIndexExpression,
    };
  }

  List<AstNode> prog() {
    List<AstNode> stmts = [];
    List? body = this.ast["body"];
    if(body == null) return stmts;
    for (Map item in body) {
      AstNode? node = strategyFunc(item);
      if(node != null) stmts.add(node);
    }
    return stmts;
  }


  dynamic strategyFunc(Map? vv) {
    if(vv == null || vv.isEmpty) return null;
    Function? func = this.strategy[vv["type"]];
    if(func == null) return null;
    return func(vv);
  }

  FunctionDecl? parserFunctionDeclaration(Map? bb) {
    if(bb == null) return null;
    String? name = bb["id"]?["name"];
    if(name == null) return null;
    FunctionDecl? decl = strategyFunc(bb["expression"]);
    if(decl == null) return null;
    StringLiteral returnType = strategyFunc(bb["returnType"]); 
    bool isAsync = bb["isAsync"] == null ? false : bb["isAsync"];
    decl.name = name;
    decl.returnType = returnType.value;
    decl.isAsync = isAsync;
    return decl;
  }

  FunctionDecl? parserFunctionExpression(Map? bb) {
    if(bb == null) return null;
    List<Variable>? parameters = strategyFunc(bb["parameters"]);
    BlockStatement? blockStmt = strategyFunc(bb["body"]);
    if(blockStmt == null) return null;
    return FunctionDecl(null, parameters, null, blockStmt, false);
  }

  List<Variable>? parserParameterList(Map? parameters) {
    if(parameters == null) return null;
    List parameterList = parameters["parameterList"];
    if(parameterList.isEmpty) return null;
    List<Variable> paramList = [];
    for (Map item in parameterList) {
      var type = item["paramType"]?["name"];
      var name = item["name"];
      if(name != null) {
        paramList.add(Variable(name, type));
      }
    }
    return paramList;
  }

  BlockStatement? parserBlockStatement(Map? bb) {
    if(bb == null) return null;
    List<Statement> stmts = [];
    List? body = bb["body"];
    if(body == null) return null;
    for (Map item in body) {
      AstNode? node = strategyFunc(item);
      if(node is Expression) {
        node = ExpressionStatement(node);
      }
      if(node != null) stmts.add(node as Statement);
    }
    return BlockStatement(stmts);
  }

  VariableDecl? parserVariableDeclarationList(Map? vari) {
    if(vari == null) return null;
    String type = "var";
    if(vari["typeAnnotation"] != null && vari["typeAnnotation"]["name"] != null) {
      type = vari["typeAnnotation"]["name"];
    }
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
  StringLiteral? parserIdentifier(Map ii) {
    /*
    "id": {
          "type": "Identifier",
          "name": "mainAxisSize"
      }
     */
    String? name = ii["name"];
    if(name == null) return null;
    return StringLiteral(name);
  }
  ReturnStatement? parserReturnStatement(Map rr) {
    Expression? exp = strategyFunc(rr["argument"]);
    if(exp == null) return null;
    return ReturnStatement(exp);
  }

  IfStatement? parserIfStatement(Map ii) {
    Expression? condition = strategyFunc(ii["condition"]);
    BlockStatement? thenStatement = strategyFunc(ii["thenStatement"]);
    BlockStatement? elseStatement = strategyFunc(ii["elseStatement"]);
    if(condition == null || thenStatement == null) return null;
    return IfStatement(condition, thenStatement, elseStatement);
  }

  ForStatement? parsertForStatement(Map ff) {
    AstNode? init = strategyFunc(ff["loop"]?["init"]);
    Expression? condition = strategyFunc(ff["loop"]?["condition"]);
    List? updaterList = ff["loop"]?["updaters"];
    List<Expression>? updaters = [];
    if(updaterList != null) {
      for (Map item in updaterList) {
        Expression? exp = strategyFunc(item);
        if(exp != null) {
          updaters.add(exp);
        }    
      }
    }
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

  Expression? parserPropertyAccess(Map bb) {
    String op = ".";
    Expression? left = strategyFunc(bb["expression"]);
    Expression? right = strategyFunc(bb["id"]);
    if(left == null && right == null) return null;
    if(left != null && right == null) return left;
    if(left == null && right != null) return right;
    return Binary(op, left!, right!);
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
    Expression? callee = strategyFunc(bb["callee"]);
    StringLiteral? name = strategyFunc(bb["callee"]["property"]);
    List<Expression>? args = strategyFunc(bb["argumentList"]);
    if(callee == null) return null;
    return FunctionCall(name?.value, args,callee);
  }

  Expression? parserMemberExpression(Map bb) {
    return strategyFunc(bb["object"]);
  }

  List<Expression>? parserArgumentList(Map bb) {
    List? argumentList = bb["argumentList"];
    if(argumentList == null || argumentList.isEmpty) return null;
    List<Expression> args = [];
    for (Map item in argumentList) {
      Expression? exp = strategyFunc(item);
      if(exp != null) {
        args.add(exp);
      }
    }
    return args;
  }

//-------------------------
  ClassDeclaration? parserClassDeclaration(Map bb) {
    StringLiteral? name = strategyFunc(bb["id"]);
    if(name == null) return null;
    StringLiteral? superName = strategyFunc(bb["superClause"]);
    List? body = bb["body"];
    if(body == null || body.isEmpty) return null;
    List<VariableDecl> fields = [];
    List<FunctionDecl> methods = [];
    for (Map item in body) {
      AstNode? exp = strategyFunc(item);
      if(item["type"] == "FieldDeclaration") {
        if(exp != null) fields.add(exp as VariableDecl);
      } else if(item["type"] == "MethodDeclaration") {
        if(exp != null) methods.add(exp as FunctionDecl);
      }
    }
    return ClassDeclaration(name.value, superName?.value, fields, methods);
  }

  VariableDecl? parserFieldDeclaration(Map bb) {
    return strategyFunc(bb["init"]);
  }

  FunctionDecl? parserMethodDeclaration(Map bb) {
    /*
      String name;
      List<Variable>? parameters;
      String returnType;
      BlockStatement blockStmt;
    */
    StringLiteral? name = strategyFunc(bb["id"]);
    if(name == null) return null;
    List<Variable>? parameters = strategyFunc(bb["parameters"]); 
    BlockStatement? blockStmt  = strategyFunc(bb["body"]); 
    if(blockStmt == null) return null;
    StringLiteral returnType = strategyFunc(bb["returnType"]); 
    bool isAsync = bb["isAsync"];
    return FunctionDecl(name.value, parameters, returnType.value, blockStmt, isAsync);
  }

  StringLiteral? parserReturnType(Map bb) {
    String? returnType = bb["name"];
    return (returnType == null ? StringLiteral("void") : StringLiteral(returnType));
  }

  NamedExpression? parserNamedExpression(Map bb) {
    StringLiteral? name = strategyFunc(bb["id"]);
    AstNode? exp = strategyFunc(bb["expression"]); 
    if(exp == null) return null;
    return NamedExpression(name?.value, exp);
  }

  InstanceCreation? parserInstanceCreationExpression(Map bb) {
    StringLiteral? name = strategyFunc(bb["name"]);
    if(name == null) return null;
    List? arguments = bb["arguments"];
    if(arguments == null) return null;
    List<Expression> parameters = [];
    for (Map item in arguments) {
      Expression? exp = strategyFunc(item);
      if(exp != null) parameters.add(exp);
    }
    return InstanceCreation(name.value, parameters);
  }
  ListLiteral? parserListLiteral(Map bb) {
    List? value = bb["value"];
    if(value == null) return null;
    List<Expression> exps = [];
    for (Map item in value) {
      Expression? exp = strategyFunc(item);
      if(exp != null) exps.add(exp);
    }
    return ListLiteral(exps);
  }

  IndexExpression? parserIndexExpression(Map bb) {
    Expression? index = strategyFunc(bb["index"]);
    Expression? target = strategyFunc(bb["target"]);
    if(index == null || target == null) return null;
    return IndexExpression(index, target);
  }
}


void main() async {
  String path = Platform.script.toFilePath();
  List<String> sps = path.split("/");
  sps.removeLast();sps.removeLast();sps.removeLast();
  path = sps.join("/");
  File file = new File(path + "/testfile/demoui.json");
  String content = await file.readAsString();
  Map mc = convert.jsonDecode(content);
  ParserDartAst ast = ParserDartAst(mc);
  List<AstNode> stmts = ast.prog();
  Dart2wx().prog(stmts);
  print("done");

}
