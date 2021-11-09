/*
// js
Page({
  data: {
    motto: 'Hello World',
  },
  // 事件处理函数
  bindViewTap() {

  },
});
 */

/*
// wxml
<!--index.wxml-->
<view class="container">
  <view class="usermotto">
    <text class="user-motto">{{motto}}</text>
  </view>
</view>
 */
/*
/**index.wxss**/
.userinfo {
  display: flex;
  flex-direction: column;
  align-items: center;
  color: #aaa;
}
 */

import '../dartNode/app_bar.dart';
import '../dartNode/list_view.dart';
import '../dartNode/scaffold.dart';
import '../dartNode/text.dart';
import '../dartNode/widget.dart';
import '../parser/AstNode.dart';
import '../parser/AstVisitor.dart';

class Dart2wx extends AstVisitor {
  String? curCls;
  // data
  Map<String, String> data = {};
  dynamic prog(List stmts) {
    for (AstNode item in stmts) {
      super.visit(item);
    }
  }

  @override
  visitClassDeclaration(ClassDeclaration node, {additional}) {
    this.curCls = node.name;
    List uis = [];
    if(node.methods != null) {
      for (AstNode item in node.methods!) {
        var retVal = visit(item, additional: additional);  
        if(retVal != null) uis.add(retVal);
      }
    }
    return uis;
  }


  @override
  visitFunctionDecl(FunctionDecl node, {additional}) {
    // 这里开始是 UI 的描述了
    if(node.returnType != null && node.returnType == "Widget") {
      if(node.parameters != null) {
        for (AstNode item in node.parameters!) {
          visit(item, additional: additional);
        }
      }
      var uis = visit(node.blockStmt, additional: additional);
      return uis;
    }
  }
  @override
  visitBlockStatement(BlockStatement node, {additional}) {
    List uis = [];
    for (Statement item in node.stmts) {
      var retVal = visit(item, additional: additional);  
      if(retVal != null) uis.add(retVal);
    }
    return uis;
  }
  @override
  visitReturnStatement(ReturnStatement node, {additional}) {
    return super.visitReturnStatement(node, additional:additional);
  }
  @override
  visitNamedExpression(NamedExpression node, {additional}) {
    if(node.name == null) return null;
    String name = node.name!;
    var widget = visit(node.exp);
    if(widget == null) return null;
    return {name : widget};
  }
  @override
  visitInstanceCreation(InstanceCreation node, {additional}) {
    String name = node.name;
    Widget? widget = createNode(name);
    if(widget == null) return null;
    if(node.parameters != null) {
      for (var item in node.parameters!) {
        var v = visit(item);
        if(v != null) {
          widget.add(v);
        }
      }
    }
    return widget;
  }
  @override
  visitListLiteral(ListLiteral node, {additional}) {
    List vs = [];
    for (var item in node.list) {
      var v = visit(item);
      if(v != null) vs.add(v);
    }
    return vs;
  }

  @override
  visitFunctionCall(FunctionCall node, {additional}) {
    String? name;
    if(node.callee is StringLiteral) {
      name = visit(node.callee);
    }
    if(name == null) return null;
    // parameters
    // { key : node }
    Widget? widget = createNode(name);
    if(widget == null) {
      widget = Widget();
      widget.isFunc = true;
      widget.uuid = name;
      return widget;
    };
    if(node.parameters != null) {
      for (var item in node.parameters!) {
        var param = visit(item);  
        if(param != null) {
          widget.add(param);
        }
      }
    }
    return widget;
  }
  



  Widget? createNode(String name) {
    switch(name) {
      case "Scaffold":return Scaffold();
      case "AppBar":return AppBar();
      case "ListView":return ListView();
      case "Text": return Text();
    }
  }










}