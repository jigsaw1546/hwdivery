import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hiwwoydelivery/utility/my_constant.dart';
import 'package:hiwwoydelivery/utility/my_style.dart';
import 'package:hiwwoydelivery/utility/normal_dialog.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String fullname, username, password, phone;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'สมัครสมาชิก',
          style: TextStyle(fontFamily: 'Prompt'),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF73AEF5),
              Color(0xFF61A4F1),
              Color(0xFF478DE0),
              Color(0xFF398AE5),
            ],
            stops: [0.1, 0.4, 0.7, 0.9],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                MyStyle().showLogo(),
                MyStyle().mySizebox(),
                fullnameForm(),
                MyStyle().mySizebox(),
                userForm(),
                MyStyle().mySizebox(),
                passwordForm(),
                MyStyle().mySizebox(),
                phoneForm(),
                MyStyle().mySizebox(),
                registerButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget registerButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      width: 300.0,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          print(
              'Fullname =$fullname, Username = $username , Password = $password , Phone = $phone');
          if (fullname == null ||
              fullname.isEmpty ||
              username == null ||
              username.isEmpty ||
              password == null ||
              password.isEmpty ||
              phone == null ||
              phone.isEmpty) {
            print('Have Spece');
            normalDialog(context, 'มีช่องว่าง กรุณากรอกทุกช่อง');
          }else{
            checkusername();
          }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'สมัครสมาชิก',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Prompt',
          ),
        ),
      ),
    );
  }
  Future<Null> checkusername()async{
    String url= '${MyConstant().domain}/HiwwoyDelivery/getUserWhereUser.php?isAdd=true&mem_username=$username';

    try {
      Response response = await Dio().get(url);
      if (response.toString()== 'null') {
        registerThread();
      } else {
        normalDialog(context, 'ชื่อผู้ใช้ $username มีผู้ใช้แล้ว');
      }
    } catch (e) {
    }
  }
  Future<Null> registerThread()async{
    String url = '${MyConstant().domain}/HiwwoyDelivery/addData.php?isAdd=true&mem_fullname=$fullname&mem_username=$username&mem_password=$password&mem_phone=$phone';

    try {
      Response response = await Dio().get(url);
      print('res = $response');

      if (response.toString() == 'true') {
        Navigator.pop(context);
      } else {
        normalDialog(context, 'ไม่สามารถสมัครสมาชิก กรุณาลองใหม่อีกครั้ง');
      }

    } catch (e) {
    }
  }

  Widget phoneForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'เบอร์โทรศัพท์',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          width: 300.0,
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            onChanged: (value) => phone = value.trim(),
            keyboardType: TextInputType.number,
            style: TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.local_phone,
                color: Colors.white,
              ),
              hintText: 'โปรดใส่เบอร์โทรศัพท์ของท่าน',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget fullnameForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'ชื่อ-สกุล',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          width: 300.0,
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            onChanged: (value) => fullname = value.trim(),
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.account_box,
                color: Colors.white,
              ),
              hintText: 'โปรดใส่ชื่อ-สกุลของท่าน',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget userForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'ชื่อผู้ใช้',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          width: 300.0,
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            onChanged: (value) => username = value.trim(),
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.account_box,
                color: Colors.white,
              ),
              hintText: 'โปรดใส่ชื่อผู้ใช้ของท่าน',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget passwordForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'รหัสผ่าน',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          width: 300.0,
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            onChanged: (value) => password = value.trim(),
            obscureText: true,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Prompt',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'โปรดใส่รหัสผ่านของท่าน',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }
}
