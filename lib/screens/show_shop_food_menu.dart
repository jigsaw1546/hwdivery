import 'package:flutter/material.dart';

import 'package:hiwwoydelivery/model/user_model.dart';

class ShowShopMenu extends StatefulWidget {
  final UserModel userModel;
  ShowShopMenu({Key key, this.userModel}) : super(key: key);
  @override
  _ShowShopMenuState createState() => _ShowShopMenuState();
}

class _ShowShopMenuState extends State<ShowShopMenu> {
  UserModel userModel;
  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(userModel.shopName),),);
  }
}
