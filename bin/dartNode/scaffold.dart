import 'app_bar.dart';
import 'widget.dart';

class Scaffold extends Widget {
  AppBar? appBar;
  Widget? body;
  Scaffold({
    this.appBar,
    this.body
  });
  @override
  add(param) {
    if(param is Map) {
      Map v = param;
      String key = v.keys.first;
      var value = v.values.first;
      if(value == null) return;
      switch(key) {
        case "appBar":
          if(value is AppBar) this.appBar = value;
          break;
        case "body":
          if(value is Widget) this.body = value;
          break;
      }
    }
  }
}