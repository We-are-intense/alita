import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/ast/ast.dart';



class DartAstParser extends SimpleAstVisitor<Map> {
  /// 遍历节点
  Map? _safelyVisitNode(AstNode? node) {
    // ignore: unnecessary_null_comparison
    if (node != null) {
      return node.accept(this);
    }
    return null;
  }

  /// 遍历节点列表
  List<Map> _safelyVisitNodeList(NodeList<AstNode> nodes) {
    List<Map> maps = [];
    if (nodes != null) {
      int size = nodes.length;
      for (int i = 0; i < size; i++) {
        var node = nodes[i];
        if (node != null) {
          var res = node.accept(this);
          if (res != null) {
            maps.add(res);
          }
        }
      }
    }
    return maps;
  }

  //构造根节点
  Map? _buildAstRoot(List<Map> body) {
    if (body.isNotEmpty) {
      return {
        "type": "Program",
        "body": body,
      };
    } else {
      return null;
    }
  }

  //构造代码块Bloc 结构
  Map _buildBloc(List body) => {"type": "BlockStatement", "body": body};

  //构造运算表达式结构
  Map _buildBinaryExpression(Map? left, Map? right, String? lexeme) => {
        "type": "BinaryExpression",
        "operator": lexeme,
        "left": left,
        "right": right
      };

  //构造变量声明
  Map _buildVariableDeclaration(Map? id, Map? init) => {
        "type": "VariableDeclarator",
        "id": id,
        "init": init,
      };

  //构造变量声明
  Map _buildVariableDeclarationList(
          Map? typeAnnotation, List<Map> declarations) =>
      {
        "type": "VariableDeclarationList",
        "typeAnnotation": typeAnnotation == null ? { "type": "Identifier","name": "var"} : typeAnnotation,
        "declarations": declarations,
      };
  //构造标识符定义
  Map _buildIdentifier(String name) => {"type": "Identifier", "name": name};

  //构造数值定义
  Map _buildNumericLiteral(num? value) =>
      {"type": "IntegerLiteral", "value": value};

  //构造函数声明
  Map _buildFunctionDeclaration(Map? id, Map? expression, Map? returnType) => {
        "type": "FunctionDeclaration",
        "id": id,
        "expression": expression,
        "returnType": returnType
      };

  //构造函数表达式
  Map _buildFunctionExpression(Map? params, Map? body, {bool isAsync: false}) => {
        "type": "FunctionExpression",
        "parameters": params,
        "body": body,
        "isAsync": isAsync,
      };

  //构造函数参数
  Map _buildFormalParameterList(List<Map> parameterList) =>
      {"type": "FormalParameterList", "parameterList": parameterList};

  //构造函数参数
  Map _buildSimpleFormalParameter(Map? type, String? name) =>
      {"type": "SimpleFormalParameter", "paramType": type, "name": name};

  //构造函数参数类型
  Map _buildTypeName(String name) => {
        "type": "Identifier",
        "name": name,
      };

  //构造返回数据定义
  Map _buildReturnStatement(Map? argument) => {
        "type": "ReturnStatement",
        "argument": argument,
      };

  Map _buildMethodDeclaration(
          Map? id, Map? parameters, Map? typeParameters, Map? body, Map? returnType,
          {bool isAsync: false}) =>
      {
        "type": "MethodDeclaration",
        "id": id,
        "parameters": parameters,
        "typeParameters": typeParameters,
        "body": body,
        "isAsync": isAsync,
        "returnType": returnType,
      };

  Map _buildNamedExpression(Map? id, Map? expression) => {
        "type": "NamedExpression",
        "id": id,
        "expression": expression,
      };

  Map _buildPrefixedIdentifier(Map? identifier, Map? prefix) => {
        "type": "PrefixedIdentifier",
        "identifier": identifier,
        "prefix": prefix,
      };

  Map _buildMethodInvocation(Map? callee, Map? typeArguments, Map? argumentList) =>
      {
        "type": "MethodInvocation",
        "callee": callee,
        "typeArguments": typeArguments,
        "argumentList": argumentList,
      };

  Map _buildClassDeclaration(Map? id, Map? superClause, Map? implementsClause,
          Map? mixinClause, List<Map> metadata, List<Map> body) =>
      {
        "type": "ClassDeclaration",
        "id": id,
        "superClause": superClause,
        "implementsClause": implementsClause,
        "mixinClause": mixinClause,
        'metadata': metadata,
        "body": body,
      };

  Map _buildArgumentList(List<Map> argumentList) =>
      {"type": "ArgumentList", "argumentList": argumentList};

  Map _buildStringLiteral(String value) =>
      {"type": "StringLiteral", "value": value};

  Map _buildBooleanLiteral(bool value) =>
      {"type": "BooleanLiteral", "value": value};

  Map _buildImplementsClause(List<Map> implementList) =>
      {"type": "ImplementsClause", "implements": implementList};

  Map _buildPropertyAccess(Map? id, Map? expression) => {
        "type": "PropertyAccess",
        "id": id,
        "expression": expression,
      };
  Map _buildForStatement(Map? loop, Map? body) => {
    "type":"ForStatement",
    "loop":loop,
    "body": body
  };


  @override
  Map? visitCompilationUnit(CompilationUnit node) {
    return _buildAstRoot(_safelyVisitNodeList(node.declarations));
  }

  @override
  Map visitBlock(Block node) {
    return _buildBloc(_safelyVisitNodeList(node.statements));
  }

  @override
  Map? visitBlockFunctionBody(BlockFunctionBody node) {
    return _safelyVisitNode(node.block);
  }

  @override
  Map? visitVariableDeclaration(VariableDeclaration node) {
    return _buildVariableDeclaration(
        _safelyVisitNode(node.name), _safelyVisitNode(node.initializer));
  }

  @override
  Map? visitVariableDeclarationStatement(VariableDeclarationStatement node) {
    return _safelyVisitNode(node.variables);
  }

  @override
  Map? visitVariableDeclarationList(VariableDeclarationList node) {
    
    return _buildVariableDeclarationList(
        _safelyVisitNode(node.type), _safelyVisitNodeList(node.variables));
  }

  @override
  Map visitSimpleIdentifier(SimpleIdentifier node) {
    return _buildIdentifier(node.name);
  }

  @override
  Map? visitBinaryExpression(BinaryExpression node) {
    return _buildBinaryExpression(_safelyVisitNode(node.leftOperand),
        _safelyVisitNode(node.rightOperand), node.operator.lexeme);
  }

  @override
  Map visitIntegerLiteral(IntegerLiteral node) {
    return _buildNumericLiteral(node.value);
  }
  @override
  Map? visitDoubleLiteral(DoubleLiteral node) {
    return {"type": "DoubleLiteral", "value": node.value};
  }
  @override
  Map visitFunctionDeclaration(FunctionDeclaration node) {
    Map? type;
    if(node.returnType != null) {
      type = _safelyVisitNode(node.returnType!);
    } else {
      type = { 
      "type": "Identifier",
        "name": "void"
      };
    }
    return _buildFunctionDeclaration(
        _safelyVisitNode(node.name), 
        _safelyVisitNode(node.functionExpression), 
        type);
  }

  @override
  Map? visitFunctionDeclarationStatement(FunctionDeclarationStatement node) {
    return _safelyVisitNode(node.functionDeclaration);
  }

  @override
  Map visitFunctionExpression(FunctionExpression node) {
    return _buildFunctionExpression(
        _safelyVisitNode(node.parameters), _safelyVisitNode(node.body),
        isAsync: node.body.isAsynchronous);
  }

  @override
  Map visitSimpleFormalParameter(SimpleFormalParameter node) {
    return _buildSimpleFormalParameter(
        _safelyVisitNode(node.type), node.identifier!.name);
  }

  @override
  Map visitFormalParameterList(FormalParameterList node) {
    return _buildFormalParameterList(_safelyVisitNodeList(node.parameters));
  }

  @override
  Map visitTypeName(TypeName node) {
    return _buildTypeName(node.name.name);
  }

  @override
  Map visitReturnStatement(ReturnStatement node) {
    return _buildReturnStatement(_safelyVisitNode(node.expression));
  }
  @override
  Map? visitInstanceCreationExpression(InstanceCreationExpression node) {
    var name = _safelyVisitNode(node.constructorName.type2);
    var args = _safelyVisitNodeList(node.argumentList.arguments);
    return {
      "type": "InstanceCreationExpression",
      "name": name,
      "arguments": args
    };
  }

  @override
  visitMethodDeclaration(MethodDeclaration node) {
    return _buildMethodDeclaration(
        _safelyVisitNode(node.name),
        _safelyVisitNode(node.parameters),
        _safelyVisitNode(node.typeParameters),
        _safelyVisitNode(node.body),
        _safelyVisitNode(node.returnType),
        isAsync: node.body.isAsynchronous);
  }

  @override
  visitNamedExpression(NamedExpression node) {
    return _buildNamedExpression(
        _safelyVisitNode(node.name), _safelyVisitNode(node.expression));
  }

  @override
  visitPrefixedIdentifier(PrefixedIdentifier node) {
    return _buildPrefixedIdentifier(
        _safelyVisitNode(node.identifier), _safelyVisitNode(node.prefix));
  }

  @override
  visitMethodInvocation(MethodInvocation node) {
    Map callee;
    if (node.target != null) {
      node.target!.accept(this);
      callee = {
        "type": "MemberExpression",
        "object": _safelyVisitNode(node.target),
        "property": _safelyVisitNode(node.methodName),
      };
    } else {
      callee = _safelyVisitNode(node.methodName)!;
    }
    return _buildMethodInvocation(callee, _safelyVisitNode(node.typeArguments),
        _safelyVisitNode(node.argumentList));
  }

  @override
  visitClassDeclaration(ClassDeclaration node) {
    return _buildClassDeclaration(
        _safelyVisitNode(node.name),
        _safelyVisitNode(node.extendsClause),
        _safelyVisitNode(node.implementsClause),
        _safelyVisitNode(node.withClause),
        _safelyVisitNodeList(node.metadata),
        _safelyVisitNodeList(node.members));
  }
  @override
  Map? visitFieldDeclaration(FieldDeclaration node) {
    return {
      "type": "FieldDeclaration",
      "init": _safelyVisitNode(node.fields)
    };
  }
/**
 *TODO: 函数初始化暂时有问题
 */
  @override
  Map? visitConstructorDeclaration(ConstructorDeclaration node) {
  return {
      "name":_safelyVisitNode(node.name),
      "parameters": _safelyVisitNode(node.parameters),
      "body": _safelyVisitNode(node.body),
    };
}

  @override
  visitSimpleStringLiteral(SimpleStringLiteral node) {
    return _buildStringLiteral(node.value);
  }

  @override
  visitBooleanLiteral(BooleanLiteral node) {
    return _buildBooleanLiteral(node.value);
  }

  @override
  visitArgumentList(ArgumentList node) {
    return _buildArgumentList(_safelyVisitNodeList(node.arguments));
  }

  @override
  visitLabel(Label node) {
    return _safelyVisitNode(node.label);
  }

  @override
  visitExtendsClause(ExtendsClause node) {
    return _safelyVisitNode(node.superclass2);
  }

  @override
  visitImplementsClause(ImplementsClause node) {
    return _buildImplementsClause(_safelyVisitNodeList(node.interfaces));
  }

  @override
  visitWithClause(WithClause node) {
    return _safelyVisitNode(node);
  }

  @override
  visitPropertyAccess(PropertyAccess node) {
    return _buildPropertyAccess(
        _safelyVisitNode(node.propertyName), _safelyVisitNode(node.target));
  }
  @override
  Map? visitThisExpression(ThisExpression node) {
    return {
      "type": "PropertyAccess",
      "id": {
          "type": "Identifier",
          "name": "this"
      }
    };
  }
  @override
  Map? visitForStatement(ForStatement node) {
    var loop = _safelyVisitNode(node.forLoopParts);
    var body = _safelyVisitNode(node.body);
    return _buildForStatement(
      loop,
      body
    );
  }
  @override
  Map? visitForPartsWithExpression(ForPartsWithExpression node) {
    return super.visitForPartsWithExpression(node);
  }
  @override
  Map? visitForEachPartsWithDeclaration(ForEachPartsWithDeclaration node) {
    var iterable = _safelyVisitNode(node.iterable);
    var vari = {
      "type": "VariableDeclarationList",
      "typeAnnotation": {
          "type": "Identifier",
          "name": node.loopVariable.type?.type?.getDisplayString(withNullability: true)
      },
      "declarations": [
          {
              "type": "VariableDeclarator",
              "id": {
                  "type": "Identifier",
                  "name": node.loopVariable.identifier.name
              }
          }
      ]
    };
    return {
      "type": "ForEachPartsOfIn",
      "var" : vari,
      "express": iterable
    };
  }
  @override
  Map? visitForEachPartsWithIdentifier(ForEachPartsWithIdentifier node) {
    return super.visitForEachPartsWithIdentifier(node);
  }
  @override
  Map? visitForElement(ForElement node) {
    return super.visitForElement(node);
  }
  @override
  Map? visitForPartsWithDeclarations(ForPartsWithDeclarations node) {
    Map? init = _safelyVisitNode(node.variables);
    Map? condition =_safelyVisitNode(node.condition);
    var updaters = _safelyVisitNodeList(node.updaters);
    return {
      "init": init,
      "condition": condition,
      "updaters": updaters
    };
  }

  @override
  Map? visitPostfixExpression(PostfixExpression node) {
    var exp = _safelyVisitNode(node.operand);
    return {
      "type": "Postfix",
      "operator": node.operator.stringValue,
      "express": exp
    };
  }

  @override
  Map? visitPrefixExpression(PrefixExpression node) {
    var exp = _safelyVisitNode(node.operand);
    return {
      "type": "Prefix",
      "operator": node.operator.stringValue,
      "express": exp
    };
  }

  @override
  Map? visitExpressionStatement(ExpressionStatement node) {
    return _safelyVisitNode(node.expression);
  }

  @override
  Map? visitAssignmentExpression(AssignmentExpression node) {
    var left = _safelyVisitNode(node.leftHandSide);
    var right = _safelyVisitNode(node.rightHandSide);
    var operator = node.operator.stringValue;
    return {
      "type": "AssignmentExpression",
      "left": left,
      "right": right,
      "operator": operator
    };
  }
  @override
  Map? visitListLiteral(ListLiteral node) {
    List lists = [];
    for (AstNode item in node.elements) {
      var res = _safelyVisitNode(item);
      if(res != null) {
        lists.add(res);
      }
    }
    return {
      "type": "ListLiteral",
      "value": lists
    };
  }
  @override
  Map? visitIndexExpression(IndexExpression node) {
    var index = _safelyVisitNode(node.index);
    var target = _safelyVisitNode(node.realTarget);

    return {
      "type": "IndexExpression",
      "index": index,
      "target": target,
    };
  }

  @override
  Map? visitIfStatement(IfStatement node) {
    var condition = _safelyVisitNode(node.condition);
    var thenStmt = _safelyVisitNode(node.thenStatement);
    Map? elseStmt;
    if(node.elseStatement != null) {
      elseStmt = _safelyVisitNode(node.elseStatement);
    }
    return {
      "type": "IfStatement",
      "condition": condition,
      "thenStatement": thenStmt,
      "elseStatement": elseStmt
    };
  }
}