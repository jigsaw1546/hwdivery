import 'package:flutter/material.dart';
import 'package:hiwwoydelivery/screens/main_admin.dart';
import 'package:hiwwoydelivery/screens/main_rider.dart';
import 'package:hiwwoydelivery/screens/main_shop.dart';
import 'package:hiwwoydelivery/screens/main_user.dart';
import 'package:hiwwoydelivery/screens/signIn.dart';
import 'package:hiwwoydelivery/screens/signup.dart';
import 'package:hiwwoydelivery/utility/my_style.dart';
import 'package:hiwwoydelivery/utility/normal_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    checkPreferance();
  }


  Future<Null> checkPreferance() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String memStatus = preferences.getString('mem_status');
      if (memStatus != null && memStatus.isNotEmpty) {
        if (memStatus == 'user') {
          routeToService(MainUser());
        } else if (memStatus == 'shop') {
          routeToService(MainShop());
        } else if (memStatus == 'rider') {
          routeToService(MainRider());
        } else if (memStatus == 'admin') {
          routeToService(MainAdmin());
        } else {
          normalDialog(context, 'Error User Type');
        }
      }
    } catch (e) {}
  }

  void routeToService(Widget myWidget) {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => myWidget,
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: showDrawer(),
    );
  }

  Drawer showDrawer() => Drawer(
        child: ListView(
          children: <Widget>[
            
            showHeadDreawer(),
            signInMenu(),
            signUpMenu(),
          ],
        ),
      );

  ListTile signInMenu() {
    return ListTile(
      leading: Icon(Icons.smartphone),
      title: Text(
        'เข้าสู่ระบบ',
        style: TextStyle(fontFamily: 'Prompt', fontSize: 15.0),
      ),
      onTap: () {
        Navigator.pop(context);
        MaterialPageRoute route =
            MaterialPageRoute(builder: (value) => SignIn());
        Navigator.push(context, route);
      },
    );
  }

  ListTile signUpMenu() {
    return ListTile(
      leading: Icon(Icons.person_add),
      title: Text(
        'สมัครสมาชิก',
        style: TextStyle(fontFamily: 'Prompt', fontSize: 15.0),
      ),
      onTap: () {
        Navigator.pop(context);
        MaterialPageRoute route =
            MaterialPageRoute(builder: (value) => SignUp());
        Navigator.push(context, route);
      },
    );
  }

  UserAccountsDrawerHeader showHeadDreawer() {
    return UserAccountsDrawerHeader(
        currentAccountPicture: MyStyle().showLogo(),
        accountName: Text(
          'Guest',
          style: TextStyle(fontFamily: 'Prompt', fontSize: 14.0),
        ),
        accountEmail: Text(
          'โปรดเข้าสู่ระบบ',
          style: TextStyle(fontFamily: 'Prompt', fontSize: 15.0),
        ));
  }
}
