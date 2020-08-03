import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:hiwwoydelivery/model/user_model.dart';
import 'package:hiwwoydelivery/screens/show_shop_food_menu.dart';
import 'package:hiwwoydelivery/utility/my_constant.dart';
import 'package:hiwwoydelivery/utility/my_style.dart';
import 'package:hiwwoydelivery/utility/signout_process.dart';
import 'package:hiwwoydelivery/widget/show_list_shop_all.dart';
import 'package:hiwwoydelivery/widget/show_status_food_order.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainUser extends StatefulWidget {
  @override
  _MainUserState createState() => _MainUserState();
}

class _MainUserState extends State<MainUser> {
  String nameUser, usernames;
  List<UserModel> userModels = List();
  List<Widget> shopCards = List();
  Widget currentWidget;
  @override
  void initState() {
    super.initState();
    currentWidget = ShowListShopAll();
    findUser();
    readShop();
  }

  Future<Null> readShop() async {
    String url =
        "${MyConstant().domain}/HiwwoyDelivery/getUserwheretype.php?isAdd=true&mem_status=shop";
    await Dio().get(url).then((value) {
      var result = json.decode(value.data);
      int index = 0;
      for (var map in result) {
        UserModel model = UserModel.fromJson(map);

        String shopname = model.shopName;
        if (shopname.isNotEmpty) {
          setState(() {
            userModels.add(model);
            shopCards.add(createCard(model, index));
            index++;
          });
        }
      }
    });
  }

  Drawer showDrawer() => Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter + Alignment(0, 0),
                    child: CircleAvatar(
                      backgroundImage: AssetImage("images/logo.png"),
                      radius: 45.0,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center + Alignment(0, 0.7),
                    child: Text(
                      nameUser == null ? 'Name Login' : nameUser,
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center + Alignment(0, 1.2),
                    child: Text(
                      '@$usernames',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight + Alignment(0.1, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'Verified',
                          style: TextStyle(color: Colors.white, fontSize: 15.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            profile(),
            borderinfinity(),
            cartme(),
            borderinfinity(),
            history(),
            borderinfinity(),
            setting(),
            borderinfinity(),
            MyStyle().mySizebox(),
            MyStyle().mySizebox(),
            MyStyle().mySizebox(),
            MyStyle().mySizebox(),
            MyStyle().mySizebox(),
            MyStyle().mySizebox(),
            MyStyle().mySizebox(),
            MyStyle().mySizebox(),
            MyStyle().mySizebox(),
            MyStyle().mySizebox(),
            MyStyle().mySizebox(),
            MyStyle().mySizebox(),
            MyStyle().mySizebox(),
            borderinfinity(),
            signout(),
            borderinfinity(),
            version(),
          ],
        ),
      );

  Container version() {
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.all(40.0),
      decoration: BoxDecoration(color: Colors.blue),
      height: 100,
      child: Text('V 1.0.0',
          style: TextStyle(
            color: Colors.white,
          )),
    );
  }

  Container borderinfinity() {
    return Container(
      color: Colors.black,
      width: double.infinity,
      height: 0.1,
    );
  }

  ListTile signout() {
    return ListTile(
      leading: Icon(Icons.exit_to_app),
      title: Text('ออกจากระบบ'),
      onTap: () => signOutProcess(context),
    );
  }

  ListTile setting() {
    return ListTile(
      leading: Icon(Icons.settings),
      title: Text('Settings'),
      onTap: () {
        {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => ShowListShopAll()),
          // );
        }
      },
    );
  }

  ListTile history() {
    return ListTile(
      leading: Icon(Icons.history),
      title: Text('ประวัติการทำรายการ'),
      onTap: () {
         Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ShowStatusFoodOrder()),
          );
      },
    );
  }

  ListTile cartme() {
    return ListTile(
      leading: Icon(Icons.shopping_cart),
      title: Text('ตะกร้าของฉัน'),
      onTap: () {},
    );
  }

  ListTile profile() {
    return ListTile(
      leading: Icon(Icons.account_circle),
      title: Text('ข้อมูลส่วนตัว'),
      onTap: () {},
    );
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nameUser = preferences.getString('mem_fullname');
      usernames = preferences.getString('mem_username');
    });
  }

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(nameUser == null ? 'Main User' : 'หน้าหลัก'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => signOutProcess(context),
          )
        ],
      ),
      bottomNavigationBar: FancyBottomNavigation(tabs: [
        TabData(
          iconData: Icons.home,
          title: "Home",
          onclick: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MainUser(),
            ),
          ),
        ),
        TabData(
          iconData: Icons.shopping_cart,
          title: "Cart",
          onclick: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => showDrawer(),
            ),
          ),
        ),
        TabData(iconData: Icons.settings, title: "Settings"),
      ], onTabChangedListener: (position) {}),
      drawer: showDrawer(),
      //  body: currentWidget,
      body: shopCards.length == 1
          ? MyStyle().showProgress()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 150.0,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            "     ร้านค้า                            ",
                            style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF3a3a3b),
                                fontWeight: FontWeight.w300),
                          ),
                          Container(
                            child: FlatButton(
                                child: Text(
                                  "  เพิ่มเติม",
                                  style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ShowListShopAll()),
                                  );
                                }),
                          ),
                        ],
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: shopCards,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
    return scaffold;
  }

  Widget createCard(UserModel userModel, int index) {
    return GestureDetector(
      onTap: () {
        print('index ====== $index');
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => ShowShopMenu(
            userModel: userModels[index],
          ),
        );
        Navigator.push(context, route);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              width: 80.0,
              height: 80.0,
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    '${MyConstant().domain}${userModel.shopImage}'),
              )),
        ],
      ),
    );
  }
}
