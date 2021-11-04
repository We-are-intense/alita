
import 'AstNode.dart';

class AstVisitor {
  dynamic visit(AstNode node, {dynamic additional}) => node.accept(this, additional: additional);
  dynamic visitStringLiteral(StringLiteral node, {dynamic additional}) => node.value;
  dynamic visitIntegerLiteral(IntegerLiteral node, {dynamic additional}) => node.value;
  dynamic visitDoubleLiteral(DoubleLiteral node, {dynamic additional}) => node.value;
  dynamic visitBooleanLiteral(BooleanLiteral node, {dynamic additional}) => node.value;
  dynamic visitVariable(Variable node, {dynamic additional}) => node.name;

  dynamic visitBinary(Binary node, {dynamic additional}) {
    visit(node.left, additional: additional);
    visit(node.right, additional: additional);
    return null;
  }
  
  dynamic visitUnary(Unary node, {dynamic additional}) => visit(node.exp, additional: additional);
  
  dynamic visitFunctionCall(FunctionCall node, {dynamic additional}) {
    if(node.parameters == null) return null;
    visit(node.callee, additional: additional);
    for (Expression item in node.parameters!) {
      visit(item, additional: additional);  
    }
    return null;
  }
  dynamic visitInstanceCreation(InstanceCreation node, {dynamic additional}) {
    if(node.parameters == null) return null;
    for (Expression item in node.parameters!) {
      visit(item, additional: additional);  
    }
    return null;
  }
  
  dynamic visitNamedExpression(NamedExpression node, {dynamic additional}) => visit(node.exp, additional: additional);

  // Statement
  
  dynamic visitVariableDecl(VariableDecl node, {dynamic additional}) {
    if(node.init == null) return null;
    return visit(node.init!, additional: additional);  
  }
  dynamic visitBlockStatement(BlockStatement node, {dynamic additional}) {
    // ignore: prefer_typing_uninitialized_variables
    var retVal;
    for (Statement item in node.stmts) {
      retVal = visit(item, additional: additional);  
    }
    return retVal;
  }

  dynamic visitFunctionDecl(FunctionDecl node, {dynamic additional}) {
    if(node.parameters != null) {
      for (Variable item in node.parameters!) {
        visit(item, additional: additional);  
      }
    }
    return visit(node.blockStmt, additional: additional);  
  }
  dynamic visitExpressionStatement(ExpressionStatement node, {dynamic additional}) => visit(node.exp, additional: additional);
  dynamic visitReturnStatement(ReturnStatement node, {dynamic additional}) => visit(node.exp, additional: additional);
  
  dynamic visitIfStatement(IfStatement node, {dynamic additional}) {
    visit(node.condition, additional: additional);
    visit(node.thenStmts, additional: additional);
    
    if(node.elseStmts != null) {
      visit(node.elseStmts!, additional: additional);
    }
    return null;
  }
  dynamic visitForStatement(ForStatement node, {dynamic additional}) {
    if(node.init != null) {
      visit(node.init!, additional: additional);
    }
    
    if(node.condition != null) {
      visit(node.condition!, additional: additional);
    }

    if(node.updaters != null) {
      for (Expression item in node.updaters!) {
        visit(item, additional: additional);
      }
    }
    visit(node.body, additional: additional);
    return null;
  }

  dynamic visitIndexExpression(IndexExpression node, {dynamic additional}) {
    visit(node.index, additional: additional);
    visit(node.target, additional: additional);
    return null;
  }
}