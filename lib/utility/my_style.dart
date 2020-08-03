import 'package:flutter/material.dart';

class MyStyle {
  Color darkColor = Colors.white;
  Color primaryColor = Colors.green.shade900;
  Widget showProgress(){
    return Center(child: CircularProgressIndicator(),);
  }

  SizedBox mySizebox() => SizedBox(
        width: 8.0,
        height: 16.0,
      );
  TextStyle mainTitle = TextStyle(  
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
   TextStyle mainTitleh3 = TextStyle(  
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
  Text showTitle(String title) => Text(
        title,
        style: TextStyle(
          fontSize: 24.0,
          fontFamily: 'Prompt',
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      );
 
  Text showTitleblack(String title) => Text(
        title,
        style: TextStyle(
          fontSize: 24.0,
          fontFamily: 'Prompt',
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      );
      Text showTitleblackh3(String title) => Text(
        title,
        style: TextStyle(
          fontSize: 18.0,
          fontFamily: 'Prompt',
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      );
  Widget titleCenter(BuildContext context,String string) {
    return Center(
      child: Container(width: MediaQuery.of(context).size.width*0.5,
        child: Text(
          string,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w100,
          ),
        ),
      ),
    );
  }

  Container showLogo() {
    return Container(
      width: 200.0,
      child: Image.asset('images/logo1.png'),
    );
  }

  MyStyle();
}

final kHintTextStyle = TextStyle(
  color: Colors.white54,
  fontFamily: 'Prompt',
);

final kLabelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'Prompt',
);
final kLabelStyleblack = TextStyle(
  color: Colors.black,
  fontFamily: 'Prompt',
);
final kBoxDecorationStyle = BoxDecoration(
  color: Color(0xFF6CA8F1),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);
final kBoxstyle = BoxDecoration(
  color: Color(0xFFFFFFFF),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);