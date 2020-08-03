import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hiwwoydelivery/model/food_model.dart';
import 'package:hiwwoydelivery/screens/add_food_menu.dart';
import 'package:hiwwoydelivery/screens/edit_food_menu.dart';
import 'package:hiwwoydelivery/utility/my_constant.dart';
import 'package:hiwwoydelivery/utility/my_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListFoodMenuShop extends StatefulWidget {
  @override
  _ListFoodMenuShopState createState() => _ListFoodMenuShopState();
}

class _ListFoodMenuShopState extends State<ListFoodMenuShop> {
  bool loadStatus = true; //กำลังโหลด json
  bool status = true; //มีข้อมูล

  List<FoodModel> foodModels = List();

  @override
  void initState() {
    super.initState();
    readFoodMenu();
  }

  Future<Null> readFoodMenu() async {
    if (foodModels.length != 0) {
      foodModels.clear();
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String idShop = preferences.getString('mem_id');

    String url =
        '${MyConstant().domain}/HiwwoyDelivery/getFoodWhereidShop.php?isAdd=true&mem_id=$idShop';
    await Dio().get(url).then((value) {
      setState(() {
        loadStatus = false;
      });

      if (value.toString() != 'null') {
        //print('value =>> $value');
        var result = json.decode(value.data);
        // print('result =>> $result');

        for (var map in result) {
          FoodModel foodModel = FoodModel.fromJson(map);
          setState(() {
            foodModels.add(foodModel);
          });
        }
      } else {
        setState(() {
          status = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        loadStatus ? MyStyle().showProgress() : showContent(),
        addMenuButton(),
      ],
    );
  }

  Widget showContent() {
    return status
        ? showListFood()
        : Center(
            child: Text(
              'ยังไม่มีรายการอาหาร',
            ),
          );
  }

  Widget showListFood() => ListView.builder(
        itemCount: foodModels.length,
        itemBuilder: (context, index) => Container(
          height: 160,
          child: Card(
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 4, 4, 4),
                      // backgroundImage: NetworkImage(
                      //   '${MyConstant().domain}${foodModels[index].foodsImage}',
                      // ),
                      child: ClipRRect(
                        child: Image.network(
                          '${MyConstant().domain}${foodModels[index].foodsImage}',
                          fit: BoxFit.cover,
                          width: 120,
                          height: 120,
                        ),
                      ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.width * 0.6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            foodModels[index].foodsName,
                            style: MyStyle().mainTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          'ราคา ${foodModels[index].foodsPrice}.00 บาท',
                          style: MyStyle().mainTitleh3,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FlatButton.icon(
                                onPressed: () {
                                  MaterialPageRoute route = MaterialPageRoute(
                                    builder: (context) => EditFoodMenu(foodModel: foodModels[index],),
                                  );
                                  Navigator.push(context, route).then((value) => readFoodMenu());
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.yellow,
                                ),
                                label: Text('แก้ไข')),
                            FlatButton.icon(
                                onPressed: () => deleateFood(foodModels[index]),
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                label: Text('ลบ')),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
      );

  Future<Null> deleateFood(FoodModel foodModel) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: MyStyle()
            .showTitleblackh3('คุณต้องการลบ เมนู ${foodModel.foodsName} ?'),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton(
                onPressed: () async {
                  Navigator.pop(context);
                  String url =
                      '${MyConstant().domain}/HiwwoyDelivery/deleteFoodWhereId.php?isAdd=true&id=${foodModel.foodsId}';
                  await Dio().get(url).then((value) => readFoodMenu());
                },
                child: Text('ยืนยัน'),
              ),
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text('ยกเลิก'),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget addMenuButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 16.0, right: 16.0),
              child: FloatingActionButton.extended(
                onPressed: () {
                  MaterialPageRoute route = MaterialPageRoute(
                    builder: (context) => AddFoodMenu(),
                  );
                  Navigator.push(context, route).then(
                    (value) => readFoodMenu(),
                  );
                },
                label: Text('เพิ่มเมนูอาหาร'),
                icon: Icon(Icons.add),
                heroTag: UniqueKey(),
                backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
