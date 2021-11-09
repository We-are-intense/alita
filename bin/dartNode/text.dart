
import 'widget.dart';

class Text extends Widget {
  String? data;
  Text();
  @override
  add(param) {
    if(param is String) {
      this.data = param;
    }
  }
}