import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hiwwoydelivery/utility/my_constant.dart';
import 'package:hiwwoydelivery/utility/my_style.dart';
import 'package:hiwwoydelivery/utility/normal_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddFoodMenu extends StatefulWidget {
  @override
  _AddFoodMenuState createState() => _AddFoodMenuState();
}

class _AddFoodMenuState extends State<AddFoodMenu> {
  String namemenu, detail, price;
  File file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มเมนูอาหาร'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            MyStyle().mySizebox(),
            groupImage(),
            MyStyle().mySizebox(),
            nameForm(),
            priceForm(),
            detailForm(),
            MyStyle().mySizebox(),
            saveButton(),
            MyStyle().mySizebox(),
            MyStyle().mySizebox(),
          ],
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
    );
  }

  RaisedButton saveButton() {
    return RaisedButton.icon(
      onPressed: () {
        if (namemenu == null || namemenu.isEmpty) {
          normalDialog(context, 'กรุณากรอกชื่ออาหาร');
        } else if (price == null || price.isEmpty) {
          normalDialog(context, 'กรุณากรอกราคาอาหาร');
        } else if (file == null) {
          normalDialog(context, 'กรุณาเลือกรูปอาหาร');
        } else {
          uploadFoodAndInsertData();
        }
      },
      icon: Icon(
        Icons.save,
        color: Colors.white,
      ),
      label: Text(
        'บันทึกข้อมูล',
        style: TextStyle(
          color: Colors.white,
          letterSpacing: 1.5,
          fontSize: 18.0,
          fontFamily: 'Prompt',
        ),
      ),
      padding: EdgeInsets.all(15.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.green,
    );
  }

  Future<Null> uploadFoodAndInsertData() async {
    String urlUpload = '${MyConstant().domain}/HiwwoyDelivery/savefood.php';
    Random random = Random();
    int i = random.nextInt(1000000);
    String nameFile = 'Food$i.jpg';

    try {

    Map<String, dynamic> map = Map();
    map['file'] = await MultipartFile.fromFile(file.path, filename: nameFile);
    FormData formData = FormData.fromMap(map);
    
    await Dio().post(urlUpload, data: formData).then((value) async {
      String urlPathImage = '/hiwwoydelivery/images/food/$nameFile';
      print('urlPathImage = ${MyConstant().domain}$urlPathImage');


      SharedPreferences preferences = await SharedPreferences.getInstance();
      String idShop = preferences.getString('mem_id');

      String urlInsertData = '${MyConstant().domain}/HiwwoyDelivery/addfoods.php?isAdd=true&mem_id=$idShop&foods_name=$namemenu&foods_image=$urlPathImage&foods_price=$price&foods_detail=$detail';
      await Dio().get(urlInsertData).then((value) => Navigator.pop(context));
    });


    } catch (e) {
    }

  }

  Widget nameForm() {
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
              child: TextField(
                onChanged: (value) => namemenu = value.trim(),
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

  Widget priceForm() {
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
              child: TextField(
                onChanged: (value) => price = value.trim(),
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

  Widget detailForm() {
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
              child: TextField(
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

  Future<Null> chooseImage(ImageSource source) async {
    try {
      var object = await ImagePicker().getImage(
        source: source,
        maxHeight: 800.0,
        maxWidth: 800.0,
      );
      setState(() {
        file = File(object.path);
      });
    } catch (e) {}
  }

  Center groupImage() {
    return Center(
      child: Container(
        width: 250.0,
        height: 250.0,
        child:
            file == null ? Image.asset('images/addmenu.png') : Image.file(file),
      ),
    );
  }
}
