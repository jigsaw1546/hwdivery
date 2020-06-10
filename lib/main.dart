import 'package:flutter/material.dart';
import 'package:hiwwoydelivery/screens/home.dart';

main() => runApp(Myapp());

class Myapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Prompt'),
      title: 'หิวโว้ยย Delivery',
      home: Home(),
    );
  }
}
