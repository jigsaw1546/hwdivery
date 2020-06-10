import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hiwwoydelivery/utility/my_constant.dart';
import 'package:hiwwoydelivery/utility/my_style.dart';
import 'package:hiwwoydelivery/utility/normal_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddInfoShop extends StatefulWidget {
  @override
  _AddInfoShopState createState() => _AddInfoShopState();
}

class _AddInfoShopState extends State<AddInfoShop> {
  // field
  double lat, lng;
  File file;
  String nameShop, address, phone, urlImage;
  @override
  void initState() {
    super.initState();
    findLatLng();
  }

  Future<Null> findLatLng() async {
    LocationData locationData = await findLocationData();
    setState(() {
      lat = locationData.latitude;
      lng = locationData.longitude;
    });
    print('lat = $lat lng = $lng');
  }

  Future<LocationData> findLocationData() async {
    Location location = Location();
    try {
      return location.getLocation();
    } catch (e) {
      return null;
    }
  }

  String nameform;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มข้อมูลร้านค้า'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFFFFFFF),
              Color(0xFFFFFFFF),
              Color(0xFFFFFFFF),
              //  Color(0xFF64B5F6),
              // Color(0xFF42A5F5),
              // Color(0xFF2196F3),
              // Color(0xFF1E88E5),
            ],
            stops: [0.1, 0.4, 0.7, 0.9],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                groupImage(),
                groupImageicon(),
                nameForm(),
                addressForm(),
                phoneForm(),
                MyStyle().mySizebox(),
                lat == null ? MyStyle().showProgress() : showmap(),
                MyStyle().mySizebox(),
                saveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  RaisedButton saveButton() {
    return RaisedButton.icon(
      onPressed: () {
        if (nameShop == null || nameShop.isEmpty) {
          normalDialog(context, 'กรุณากรอกชื่อร้าน');
        } else if (address == null || address.isEmpty) {
          normalDialog(context, 'กรุณากรอกที่อยู่ร้าน');
        } else if (phone == null || phone.isEmpty) {
          normalDialog(context, 'กรุณากรอกเบอร์ติดต่อร้าน');
        } else if (file == null) {
          normalDialog(context, 'กรุณาเลือกโลโก้ร้าน');
        } else {
          UploadImage();
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
      borderRadius: BorderRadius.circular(30.0),
      ),
      color: Colors.blue,
    );
  }

  Future<Null> UploadImage() async {
    Random random = Random();
    int i = random.nextInt(100000);
    String nameImage = 'shop$i.jpg';
    String url = '${MyConstant().domain}/HiwwoyDelivery/saveFile.php';
    try {
      Map<String, dynamic> map = Map();
      map['file'] =
          await MultipartFile.fromFile(file.path, filename: nameImage);

      FormData formData = FormData.fromMap(map);
      await Dio().post(url, data: formData).then((value) {
        print('responst ==>> $value');
        urlImage = '/HiwwoyDelivery/Images/Shop/$nameImage';
        print('urlimage = $urlImage');
        editUsershop();
      });
    } catch (e) {}
  }

  Future<Null> editUsershop()async{

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String mem_id = preferences.getString('mem_id');

    String url ='${MyConstant().domain}/HiwwoyDelivery/edituserwhereid.php?isAdd=true&mem_id=$mem_id&shop_name=$nameShop&shop_phone=$phone&shop_address=$address&shop_image=$urlImage&shop_lat=$lat&shop_lng=$lng';

    await Dio().get(url).then((value) { 
      if (value.toString() == 'true') {
        Navigator.pop(context);
      } else {
        normalDialog(context, 'กรุณาลองอีกครั้ง ไม่สามารถบันทึกได้');
      }
    });
  }

  Set<Marker> myMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId('myShop'),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(
          title: 'ร้านของคุณ',
          snippet: 'ละติจุด = $lat , ลองติจุด = $lng',
        ),
      )
    ].toSet();
  }

  Container showmap() {
    LatLng latLng = LatLng(lat, lng);
    CameraPosition cameraPosition = CameraPosition(
      target: latLng,
      zoom: 16.0,
    );
    return Container(
      height: 300.0,
      child: GoogleMap(
        initialCameraPosition: cameraPosition,
        mapType: MapType.normal,
        onMapCreated: (controlller) {},
        markers: myMarker(),
      ),
    );
  }

  Row groupImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 250.0,
          height: 200.0,
          child: file == null
              ? Image.asset('images/myimage2.png')
              : Image.file(file),
        ),
      ],
    );
  }

  Row groupImageicon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
            icon: Icon(
              Icons.add_a_photo,
              size: 36.0,
              color: Colors.black,
            ),
            onPressed: () => chooseImage(ImageSource.camera)),
        IconButton(
            icon: Icon(
              Icons.add_photo_alternate,
              size: 36.0,
              color: Colors.black,
            ),
            onPressed: () => chooseImage(ImageSource.gallery))
      ],
    );
  }

  Future<Null> chooseImage(ImageSource imageSource) async {
    try {
      var object = await ImagePicker.pickImage(
        source: imageSource,
        maxHeight: 800.0,
        maxWidth: 800.0,
      );
      setState(() {
        file = object;
      });
    } catch (e) {}
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
                onChanged: (value) => nameShop = value.trim(),
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
              child: TextField(
                onChanged: (value) => address = value.trim(),
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
              child: TextField(
                onChanged: (value) => phone = value.trim(),
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
