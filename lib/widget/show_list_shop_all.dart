import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:hiwwoydelivery/model/user_model.dart';
import 'package:hiwwoydelivery/screens/main_rider.dart';
import 'package:hiwwoydelivery/screens/main_user.dart';
import 'package:hiwwoydelivery/screens/show_shop_food_menu.dart';
import 'package:hiwwoydelivery/utility/my_constant.dart';
import 'package:hiwwoydelivery/utility/my_style.dart';

class ShowListShopAll extends StatefulWidget {
  @override
  _ShowListShopAllState createState() => _ShowListShopAllState();
}

class _ShowListShopAllState extends State<ShowListShopAll> {
  List<UserModel> userModels = List();
  List<Widget> shopCards = List();

  @override
  void initState() {
    super.initState();
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

   Widget createCard(UserModel userModel, int index) {
    return GestureDetector(
      onTap: () {
        print('You Click index $index');
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => ShowShopMenu(
            userModel: userModels[index],
          ),
        );
        Navigator.push(context, route);
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 80.0,
              height: 80.0,
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    '${MyConstant().domain}${userModel.shopImage}'),
              ),
            ),
            MyStyle().mySizebox(),
            Container(width: 120,
              child: MyStyle().showTitleblack(userModel.shopName),
            ),
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ร้านทั้งหมด'),
      ),
      body: shopCards.length == 0
        ? MyStyle().showProgress()
        : GridView.extent(
            maxCrossAxisExtent: 220.0,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            children: shopCards,
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
    );
  }
}
