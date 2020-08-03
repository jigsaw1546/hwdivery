import 'package:flutter/material.dart';
import 'package:hiwwoydelivery/screens/home.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
        seconds: 5,
        navigateAfterSeconds: Home(),
        title: Text(
          'บริการส่งอาหาร สะดวก รวดเร็ว ทันใจ ',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0,color: Colors.white,),
        ),
        image: Image.asset('images/logo1.png'),
        
        backgroundColor: Colors.blue,
        styleTextUnderTheLoader: TextStyle(color: Colors.deepPurple),
        photoSize: 100.0,
        loaderColor: Colors.pinkAccent);
  }
}