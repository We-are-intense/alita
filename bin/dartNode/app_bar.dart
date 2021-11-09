import 'widget.dart';

class AppBar extends Widget {
  Widget? title;
  AppBar({
    this.title,
  });
  @override
  add(param) {
    if(param is Map) {
      Map v = param;
      String key = v.keys.first;
      var value = v.values.first;
      if(value == null) return;
      switch(key) {
        case "title":
          if(value is Widget) this.title = value;
          break;
      }
    }
  }
}