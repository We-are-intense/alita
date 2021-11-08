import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


// ignore: use_key_in_widget_constructors
class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class  HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Demo"),
        ),
        body: ListView(
          children: [
            _buildImageSection(),
            _buildTitleSection(),
            _buttonSection(),
            _buildTextSection()
          ]
        ),
      );
  }
  Widget _buildImageSection() {
    return Image.asset(
      "images/lake.jpg",
      height: 240,
      fit: BoxFit.cover,
    );
  }
  
  Widget _buildTitleSection() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children:[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: const Text(
                    "Oeschinen Lake Campground",
                    style: TextStyle(fontWeight: FontWeight.bold)
                  ),
                ),
                const Text(
                  "Kandersteg, Switzerland",
                  style: TextStyle(color: Colors.grey)
                )
              ],
            ),
          ),
          const Icon(Icons.star, color: Colors.red),
          const Text("41")
        ]
      ),
    );
  }
  Widget _buttonSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildButton(Icons.call, "CALL"),
        _buildButton(Icons.near_me, "ROUTE"),
        _buildButton(Icons.share, "SHARE"),
      ],
    );
  }
  Widget _buildTextSection() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: const Text("""
        Lake Oeschinen lies at the foot of the Blüemlisalp in the Bernese Alps. Situated 1,578 meters above sea level, it is one of the larger Alpine Lakes. A gondola ride from Kandersteg, followed by a half-hour walk through pastures and pine forest, leads you to the lake, which warms to 20 degrees Celsius in the summer. Activities enjoyed here include rowing, and riding the summer toboggan run.
        """,
        softWrap: true,
      ),
    );
  }


  Column _buildButton(IconData icon, String label) {
    Color color = Theme.of(context).primaryColor;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Container(
          margin: const EdgeInsets.only(top: 8.0),
          child: Text(
            label,
            style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: color,
            )
          )
        )
      ],
    );
  }
}