import 'AstNode.dart';
import 'AstVisitor.dart';
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


class VisitDartAst extends AstVisitor {
  // data
  Map<String, String> data = {};
  dynamic prog(List stmts) {
    for (AstNode item in stmts) {
      visit(item);
    }
  }

  @override
  visitFunctionDecl(FunctionDecl node, {additional}) {
    // 这里开始是 UI 的描述了
    if(node.returnType != null && node.name != null && node.name == "Widget") {
      
    }
  }


}