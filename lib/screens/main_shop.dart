import 'package:flutter/material.dart';
import 'package:hiwwoydelivery/utility/signout_process.dart';
import 'package:hiwwoydelivery/utility/my_style.dart';
import 'package:hiwwoydelivery/widget/information_shop.dart';
import 'package:hiwwoydelivery/widget/list_food_menu_shop.dart';
import 'package:hiwwoydelivery/widget/order_list_shop.dart';

class MainShop extends StatefulWidget {
  @override
  _MainShopState createState() => _MainShopState();
}

class _MainShopState extends State<MainShop> {


  //field
  Widget currentWidget = OrderListShop();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Shop'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => signOutProcess(context),
          )
        ],
      ),
      drawer: showDrawer(),
      body: currentWidget,
      
    );
  }
Drawer showDrawer() => Drawer( 
      child: ListView(
        children: <Widget>[
          showHead(),
          homeMenu(),
          foodMenu(),
          informationMenu(),
          signoutMenu(),
        ],
      ),
    );

ListTile homeMenu() => ListTile(
      leading: Icon(Icons.home),
      title: Text('รายการอาหารที่ลูกค้าสั่ง',
      style: TextStyle(fontFamily: 'Prompt', fontSize: 15.0)),
      subtitle: Text('รายการอาหารที่ยังไม่ได้ส่งลูกค้า'),
      onTap: () {
        setState(() {
          currentWidget = OrderListShop();
        });
          Navigator.pop(context);
      },
    );

ListTile foodMenu() => ListTile(
      leading: Icon(Icons.fastfood),
      title: Text('รายการอาหาร',
          style: TextStyle(fontFamily: 'Prompt', fontSize: 15.0)),
      subtitle: Text('รายการอาหารของร้าน'),
      onTap: (){
        setState(() {
          currentWidget = ListFoodMenuShop();
        });
         Navigator.pop(context);
      },
    );

ListTile informationMenu() => ListTile(
      leading: Icon(Icons.info),
      title: Text('รายละเอียดของร้าน',
          style: TextStyle(fontFamily: 'Prompt', fontSize: 15.0)),
      subtitle: Text('รายละเอียดของร้าน'),
       onTap: (){
         setState(() {
           currentWidget = InformationShop();
         });
         Navigator.pop(context);
      },
    );

ListTile signoutMenu() => ListTile(
      leading: Icon(Icons.exit_to_app),
      title: Text('ออกจากระบบ',
          style: TextStyle(fontFamily: 'Prompt', fontSize: 15.0)),
           onTap: (){
         signOutProcess(context);
      },
    );
    
  UserAccountsDrawerHeader showHead() {
    return UserAccountsDrawerHeader(
      currentAccountPicture: MyStyle().showLogo(),
      accountName: Text('Name Shop'),
      accountEmail: Text('Login'),
    );
  }
}