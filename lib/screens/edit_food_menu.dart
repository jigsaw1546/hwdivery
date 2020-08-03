import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hiwwoydelivery/model/food_model.dart';
import 'package:hiwwoydelivery/utility/my_constant.dart';
import 'package:hiwwoydelivery/utility/my_style.dart';
import 'package:hiwwoydelivery/utility/normal_dialog.dart';
import 'package:image_picker/image_picker.dart';

class EditFoodMenu extends StatefulWidget {
  final FoodModel foodModel;
  EditFoodMenu({Key key, this.foodModel}) : super(key: key);

  @override
  _EditFoodMenuState createState() => _EditFoodMenuState();
}

class _EditFoodMenuState extends State<EditFoodMenu> {
  FoodModel foodModel;
  File file;
  String name, price, detail, pathImage;

  @override
  void initState() {
    super.initState();
    foodModel = widget.foodModel;
    name = foodModel.foodsName;
    price = foodModel.foodsPrice;
    detail = foodModel.foodsDetail;
    pathImage = foodModel.foodsImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'แก้ไขเมนู ${foodModel.foodsName}',
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton.extended(
            onPressed: () => chooseImage(ImageSource.camera),
            label: Text('Camera'),
            icon: Icon(Icons.camera),
            heroTag: UniqueKey(),
            backgroundColor: Colors.pink,
          ),
          SizedBox(
            width: 8.0,
          ),
          FloatingActionButton.extended(
            onPressed: () => chooseImage(ImageSource.gallery),
            label: Text('Gallery'),
            heroTag: UniqueKey(),
            icon: Icon(Icons.photo_library),
            backgroundColor: Colors.pink,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            groupImage(),
            nameFood(),
            priceFood(),
            detailFood(),
            MyStyle().mySizebox(),
            MyStyle().mySizebox(),
            MyStyle().mySizebox(),
            editButton(),
          ],
        ),
      ),
    );
  }

  Widget editButton() {
    return RaisedButton.icon(
      onPressed: () {
        if (name == null || name.isEmpty) {
          normalDialog(context, 'กรุณากรอกชื่อเมนู');
        } else if (price == null || price.isEmpty) {
          normalDialog(context, 'กรุณากรอกราคา');
        } else if (pathImage == null) {
          normalDialog(context, 'กรุณาเลือกโลโก้ร้าน');
        } else {
          confirmEdit();
        }
      },
      icon: Icon(
        Icons.edit,
        color: Colors.black,
      ),
      label: Text(
        'แก้ไขข้อมูล',
        style: TextStyle(
          color: Colors.black,
          letterSpacing: 1.5,
          fontSize: 18.0,
          fontFamily: 'Prompt',
        ),
      ),
      padding: EdgeInsets.all(15.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.yellow,
    );
  }

  Future<Null> confirmEdit() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('คุณแน่ใจที่จะแก้ไขข้อมูลนี้ '),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              OutlineButton(
                onPressed: () {
                  Navigator.pop(context);
                  editValueOnSQL();
                },
                child: Text('ตกลง'),
              ),
              MyStyle().mySizebox(),
              OutlineButton(
                onPressed: () => Navigator.pop(context),
                child: Text('ยกเลิก'),
              ),
            ],
          )
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  Future<Null> editValueOnSQL() async {
    
    String id = foodModel.foodsId;
    String url = '${MyConstant().domain}/HiwwoyDelivery/editFoodWhereid.php?isAdd=true&foods_id=$id&foods_name=$name&foods_image=$pathImage&foods_price=$price&foods_detail=$detail';
    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
      } else {
        normalDialog(context, 'กรุณาลองใหม่');
      }
    });

  }

  Widget groupImage() {
    return Container(
      width: 250.0,
      height: 250.0,
      margin: EdgeInsetsDirectional.only(top: 16.0),
      child: Container(
        width: 250.0,
        height: 250.0,
        child: file == null
            ? Image.network(
                '${MyConstant().domain}${foodModel.foodsImage}',
                fit: BoxFit.cover,
              )
            : Image.file(file),
      ),
    );
  }

  Future<Null> chooseImage(ImageSource source) async {
    try {
      var object = await ImagePicker().getImage(
        source: source,
        maxWidth: 800.0,
        maxHeight: 800.0,
      );
      setState(() {
        file = File(object.path);
      });
    } catch (e) {}
  }

  Widget nameFood() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 300.0,
              alignment: Alignment.centerLeft,
              decoration: kBoxstyle,
              height: 60.0,
              child: TextFormField(
                onChanged: (value) => name = value.trim(),
                initialValue: name,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 14.0),
                  prefixIcon: Icon(
                    Icons.fastfood,
                    color: Colors.black,
                  ),
                  hintText: 'ชื่ออาหาร',
                  hintStyle: kLabelStyleblack,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget priceFood() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 300.0,
              alignment: Alignment.centerLeft,
              decoration: kBoxstyle,
              height: 60.0,
              child: TextFormField(
                onChanged: (value) => price = value.trim(),
                initialValue: price,
                keyboardType: TextInputType.number,
                style: TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 14.0),
                  prefixIcon: Icon(
                    Icons.attach_money,
                    color: Colors.black,
                  ),
                  hintText: 'ราคาอาหาร',
                  hintStyle: kLabelStyleblack,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget detailFood() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 300.0,
              alignment: Alignment.centerLeft,
              decoration: kBoxstyle,
              height: 80.0,
              child: TextFormField(
                initialValue: detail,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                onChanged: (value) => detail = value.trim(),
                style: TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 14.0),
                  prefixIcon: Icon(
                    Icons.event_note,
                    color: Colors.black,
                  ),
                  hintText: 'รายละเอียดอาหาร (ไม่บังคับ)',
                  hintStyle: kLabelStyleblack,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
