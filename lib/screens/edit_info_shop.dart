import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hiwwoydelivery/model/user_model.dart';
import 'package:hiwwoydelivery/utility/my_constant.dart';
import 'package:hiwwoydelivery/utility/my_style.dart';
import 'package:hiwwoydelivery/utility/normal_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditInfoShop extends StatefulWidget {
  @override
  _EditInfoShopState createState() => _EditInfoShopState();
}

class _EditInfoShopState extends State<EditInfoShop> {
  String nameShop, address, phone, urlImage;
  UserModel userModel;
  Location location = Location();
  double lat, lng;
  File file;

  @override
  void initState() {
    super.initState();
    readCurrentInfo();
    findLatLng();
    //error ตัวนี้ Error
  }

  Future<Null> findLatLng() async {
    LocationData locationData = await findLocationData();
    setState(() {
      lat = locationData.latitude;
      lng = locationData.longitude;
    });
    print('lat = $lat |||| lng = $lng');
  }

  Future<LocationData> findLocationData() async {
    Location location = Location();
    try {
      return location.getLocation();
    } catch (e) {
      return null;
    }
  }

  Future<Null> readCurrentInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String memId = preferences.getString('mem_id');
    print('memids ==>>$memId');
    String url =
        '${MyConstant().domain}/HiwwoyDelivery/getuserwhereid.php?isAdd=true&mem_id=$memId';
    Response response = await Dio().get(url);
    //print('respon ===============> $response');
    var result = json.decode(response.data);
    // print('result ===============> $result');
    print('==================================');

    for (var map in result) {
      print('map = $map');
      setState(() {
        userModel = UserModel.fromJson(map);
        nameShop = userModel.shopName;
        address = userModel.shopAddress;
        phone = userModel.shopPhone;
        urlImage = userModel.shopImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userModel == null ? MyStyle().showProgress() : showContent(),
      appBar: AppBar(
        title: Text('แก้ไขรายละเอียดร้าน'),
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

  Widget showContent() => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            showImage(),
            nameShopForm(),
            addressForm(),
            phoneForm(),
            lat == null ? MyStyle().showProgress : showMap(),
            MyStyle().mySizebox(),
            editButton(),
            MyStyle().mySizebox(),
            MyStyle().mySizebox(),
            MyStyle().mySizebox(),
            MyStyle().mySizebox(),
            MyStyle().mySizebox(),
          ],
        ),
      );

  Widget editButton() {
    return RaisedButton.icon(
      onPressed: () {
        if (nameShop == null || nameShop.isEmpty) {
          normalDialog(context, 'กรุณากรอกชื่อร้าน');
        } else if (address == null || address.isEmpty) {
          normalDialog(context, 'กรุณากรอกที่อยู่ร้าน');
        } else if (phone == null || phone.isEmpty) {
          normalDialog(context, 'กรุณากรอกเบอร์ติดต่อร้าน');
        } else if (urlImage == null) {
          normalDialog(context, 'กรุณาเลือกโลโก้ร้าน');
        } else {
          confirmDialog();
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

  Future<Null> confirmDialog() async {
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
                  editThread();
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

  Future<Null> editThread() async {
    Random random = Random();
    int i = random.nextInt(100000);
    String nameFile = 'editShop$i.jpg';
    Map<String, dynamic> map = Map();
    map['file'] = await MultipartFile.fromFile(file.path, filename: nameFile);
    FormData formData = FormData.fromMap(map);

    String urlUpload = '${MyConstant().domain}/HiwwoyDelivery/saveFile.php';
    await Dio().post(urlUpload, data: formData).then((value) async {
      urlImage = '/HiwwoyDelivery/Images/Shop/$nameFile';
      String memId = userModel.memId;
      //print('MEMID = $memId');
      String url =
          '${MyConstant().domain}/HiwwoyDelivery/edituserwhereid.php?isAdd=true&mem_id=$memId&shop_name=$nameShop&shop_phone=$phone&shop_address=$address&shop_image=$urlImage&shop_lat=$lat&shop_lng=$lng';
      Response response = await Dio().get(url);
      if (response.toString() == 'true') {
        Navigator.pop(context);
      } else {
        normalDialog(context, 'แก้ไขข้อมูลไม่สำเร็จ');
      }
    });
  }

  Set<Marker> currentMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId('MyMarker'),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(
            title: 'ตำแหน่งร้าน ', snippet: 'ละติจูด = $lat , ลองติจูด = $lng'),
      ),
    ].toSet();
  }

  Container showMap() {
    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(lat, lng),
      zoom: 16.0,
    );

    return Container(
      margin: EdgeInsets.only(top: 16.0),
      height: 250,
      child: GoogleMap(
        initialCameraPosition: cameraPosition,
        mapType: MapType.normal,
        onMapCreated: (controller) {},
        markers: currentMarker(),
      ),
    );
  }

  Widget showImage() {
    return Container(
      width: 250.0,
      height: 250.0,
      margin: EdgeInsetsDirectional.only(top: 16.0),
      child: Container(
        width: 250.0,
        height: 250.0,
        child: file == null
            ? Image.network('${MyConstant().domain}$urlImage')
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

  Widget nameShopForm() {
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
                onChanged: (value) => nameShop = value.trim(),
                initialValue: nameShop,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 14.0),
                  prefixIcon: Icon(
                    Icons.store,
                    color: Colors.black,
                  ),
                  hintText: 'ชื่อร้านค้า',
                  hintStyle: kLabelStyleblack,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget addressForm() {
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
                onChanged: (value) => address = value.trim(),
                initialValue: address,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 14.0),
                  prefixIcon: Icon(
                    Icons.home,
                    color: Colors.black,
                  ),
                  hintText: 'ที่อยู่ร้านค้า',
                  hintStyle: kLabelStyleblack,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget phoneForm() {
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
                onChanged: (value) => phone = value.trim(),
                initialValue: phone,
                keyboardType: TextInputType.phone,
                style: TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 14.0),
                  prefixIcon: Icon(
                    Icons.call,
                    color: Colors.black,
                  ),
                  hintText: 'เบอร์ติดต่อร้านค้า',
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
