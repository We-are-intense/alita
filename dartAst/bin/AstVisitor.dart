
import 'AstNode.dart';

class AstVisitor {
  dynamic visit(AstNode node, {dynamic additional}) {
    return node.accept(this, additional: additional);
  }

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
    for (Expression item in node.parameters!) {
      visit(item, additional: additional);  
    }
    return null;
  }
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
      for (VariableDecl item in node.parameters!) {
        visit(item, additional: additional);  
      }
    }
    return visit(node.blockStmt, additional: additional);  
  }
  dynamic visitExpressionStatement(ExpressionStatement node, {dynamic additional}) => visit(node.exp, additional: additional);
  dynamic visitReturnStatement(ReturnStatement node, {dynamic additional}) => visit(node.exp, additional: additional);
  
  dynamic visitIfStatement(IfStatement node, {dynamic additional}) {
    visit(node.condition, additional: additional);
    for (Statement item in node.thenStmts) {
      visit(item, additional: additional);
    }
    if(node.elseStmts != null) {
      for (Statement item in node.elseStmts!) {
        visit(item, additional: additional);
      }
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
      visit(node.updaters!, additional: additional);
    }

    for (Statement item in node.body) {
      visit(item, additional: additional);
    }
    return null;
  }
  

  



}