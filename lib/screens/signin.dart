import 'dart:convert';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hiwwoydelivery/model/user_model.dart';
import 'package:hiwwoydelivery/screens/main_admin.dart';
import 'package:hiwwoydelivery/screens/main_rider.dart';
import 'package:hiwwoydelivery/screens/main_shop.dart';
import 'package:hiwwoydelivery/screens/main_user.dart';
import 'package:hiwwoydelivery/utility/my_constant.dart';
import 'package:hiwwoydelivery/utility/my_style.dart';
import 'package:hiwwoydelivery/utility/normal_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  @override
  
  _SignInState createState() => _SignInState();
    
  
}

class _SignInState extends State<SignIn> {

  //  Field
  String username , password;


  @override
  Widget build(BuildContext context) {
    return Scaffold(

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
                MyStyle().mySizebox(),
                userForm(),
                MyStyle().mySizebox(),
                passwordForm(),
                MyStyle().mySizebox(),
                loginButton(),
                 MyStyle().mySizebox(),
                _buildSignInWithText(),
                _buildSocialBtnRow(),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget loginButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      width: 300.0,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: (){
          if (username == null || username.isEmpty) {
            normalDialog(context, 'กรุณากรอกชื่อผู้ใช้ของท่าน');
          }else if (password == null || password.isEmpty){
             normalDialog(context, 'กรุณากรอกรหัสผ่านของท่าน');
          }else {
            checkAuthen();
          }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'เข้าสู่ระบบ',
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
  Future<Null> checkAuthen()async{
    String url = '${MyConstant().domain}/HiwwoyDelivery/getUserWhereUser.php?isAdd=true&mem_username=$username';
    try {
      Response response = await Dio().get(url);
      print('res = $response');
      
      var result =json.decode(response.data);
      print('result = $result');
      for (var map in result) {
        UserModel userModel = UserModel.fromJson(map);
        
        if (password == userModel.memPassword) {
          String memStatus = userModel.memStatus;
          if (memStatus == 'user') {
            routeTuService(MainUser(),userModel);
          } else if (memStatus == 'shop'){
            routeTuService(MainShop(),userModel);
          } else if (memStatus == 'rider'){
            routeTuService(MainRider(),userModel);
          } else if (memStatus == 'admin'){
            routeTuService(MainAdmin(),userModel);
          }else if(memStatus == 'ban'){
            normalDialog(context, 'บัญชีผู้ใช้ถูกระงับโปรดติดต่อเจ้าหน้าที่');
          }else {
            normalDialog(context, 'Error');
          }
        } else {
          normalDialog(context, 'รหัสผ่านผิดกรุณาลองอีกครั้ง!');
        }
      }
    } catch (e) {
    }
  }

  Future<Null> routeTuService(Widget myWidget,UserModel userModel)async {

    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('mem_id', userModel.memId);
    preferences.setString('mem_status', userModel.memStatus);
    preferences.setString('mem_fullname', userModel.memFullname);

     MaterialPageRoute route = MaterialPageRoute(builder: (context)=>myWidget,);
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

Widget _buildSocialBtnRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical:10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildSocialBtn(
            
            () => print('Login with Facebook'),
            AssetImage(
              'images/facebook.jpg',
            ),
          ),
        ],
      ),
    );
  }
Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        Text(
          '- OR -',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
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
          child: TextField(onChanged: (value) => username = value.trim(),
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
          child: TextField(onChanged: (value) => password = value.trim(),
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
