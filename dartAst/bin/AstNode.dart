import 'AstVisitor.dart';

class AstNode {
  dynamic accept(AstVisitor visitor, {dynamic additional}) => null;
}

class Statement extends AstNode {}
class Expression extends AstNode {}


// Expression
class StringLiteral extends Expression {
  String value;
  StringLiteral(this.value);
  @override
  accept(AstVisitor visitor, {additional}) {
    return visitor.visitStringLiteral(this, additional: additional);
  }
}

class IntegerLiteral extends Expression {
  int value;
  IntegerLiteral(this.value);
  @override
  accept(AstVisitor visitor, {additional}) {
    return visitor.visitIntegerLiteral(this, additional: additional);
  }
}

class DoubleLiteral extends Expression {
  double value;
  DoubleLiteral(this.value);
  @override
  accept(AstVisitor visitor, {additional}) {
    return visitor.visitDoubleLiteral(this, additional: additional);
  }
}

class BooleanLiteral extends Expression {
  bool value;
  BooleanLiteral(this.value);
  @override
  accept(AstVisitor visitor, {additional}) {
    return visitor.visitBooleanLiteral(this, additional: additional);
  }
}

class Variable extends Expression {
  String name;
  String type;
  Variable(this.name, this.type);
  @override
  accept(AstVisitor visitor, {additional}) {
    return visitor.visitVariable(this, additional: additional);
  }
}

class Binary extends Expression {
  String op;
  Expression left;
  Expression right;
  Binary(this.op, this.left, this.right);
  @override
  accept(AstVisitor visitor, {additional}) {
    return visitor.visitBinary(this, additional: additional);
  }
}

class Unary extends Expression {
  String op;
  Expression exp; // 表达式
  bool isPrefix;// 前缀还是后缀
  Unary(this.op, this.exp, this.isPrefix);
  @override
  accept(AstVisitor visitor, {additional}) {
    return visitor.visitUnary(this, additional: additional);
  }
}

class NamedExpression extends Expression {
  String? name;
  Expression exp;
  NamedExpression(this.name ,this.exp);
  @override
  accept(AstVisitor visitor, {additional}) {
    return visitor.visitNamedExpression(this, additional: additional);
  }
}

class FunctionCall extends Expression {
  String name;
  List<Expression>? parameters;
  Expression callee;
  FunctionCall(this.name, this.parameters, this.callee);
  @override
  accept(AstVisitor visitor, {additional}) {
    return visitor.visitFunctionCall(this, additional: additional);
  }
}

// Statement
class VariableDecl extends Statement {
  String name;
  String type;
  Expression? init;
  VariableDecl(this.name, this.type, this.init);
  @override
  accept(AstVisitor visitor, {additional}) {
    return visitor.visitVariableDecl(this, additional: additional);
  }
}

class BlockStatement extends Statement {
  List<Statement> stmts;
  BlockStatement(this.stmts);
  @override
  accept(AstVisitor visitor, {additional}) {
    return visitor.visitBlockStatement(this, additional: additional);
  }
}

class FunctionDecl extends Statement {
  String name;
  List<Variable>? parameters;
  String returnType;
  BlockStatement blockStmt;
  FunctionDecl(this.name, this.parameters, this.returnType, this.blockStmt);
  @override
  accept(AstVisitor visitor, {additional}) {
    return visitor.visitFunctionDecl(this, additional: additional);
  }
}

class ExpressionStatement extends Statement {
  Expression exp;
  ExpressionStatement(this.exp);
  @override
  accept(AstVisitor visitor, {additional}) {
    return visitor.visitExpressionStatement(this, additional: additional);
  }
}

class ReturnStatement extends Statement {
  Expression exp;
  ReturnStatement(this.exp);
  @override
  accept(AstVisitor visitor, {additional}) {
    return visitor.visitReturnStatement(this, additional: additional);
  }
}

class IfStatement extends Statement {
  Expression condition;
  List<Statement> thenStmts;
  List<Statement>? elseStmts;
  IfStatement(this.condition, this.thenStmts, this.elseStmts);
  @override
  accept(AstVisitor visitor, {additional}) {
    return visitor.visitIfStatement(this, additional: additional);
  }
}

class ForStatement extends Statement {
  Expression? init;
  Expression? condition;
  Expression? updaters;
  BlockStatement body;
  ForStatement(this.init, this.condition, this.updaters, this.body);
  @override
  accept(AstVisitor visitor, {additional}) {
    return visitor.visitForStatement(this, additional: additional);
  }
}

class ClassDeclaration extends Statement {
  String name;
  String superName;
  List<VariableDecl> fields;
  List<FunctionDecl> methods;
  ClassDeclaration(this.name, this.superName, this.fields, this.methods);
}

