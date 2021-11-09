import 'widget.dart';

class ListView extends Widget {
  List<Widget>? children;
  @override
  add(param) {
    if(param is Map) {
      Map v = param;
      String key = v.keys.first;
      var value = v.values.first;
      if(value == null) return;
      switch(key) {
        case "children":
          if(value is List) {
            List<Widget> chs = [];
            for (var item in value) {
              if(item is Widget) chs.add(item);
            }
            this.children = chs;
          }
          break;
      }
    }
  }
}