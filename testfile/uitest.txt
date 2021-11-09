import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const title = '壹钱包大前端产线问题排查系统';
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LayoutBuilder(builder: (context, constraints) {
          return const WebEntry(title: title);
        }),
      );
  }
}

class WebEntry extends StatelessWidget {
  final String title;

  const WebEntry({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        const Text("hell world", style: TextStyle(color: Colors.red),),
        const Text("你好！"),
      ],
    );
  }
}