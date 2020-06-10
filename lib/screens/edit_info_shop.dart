import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hiwwoydelivery/model/user_model.dart';
import 'package:hiwwoydelivery/utility/my_constant.dart';
import 'package:hiwwoydelivery/utility/my_style.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hiwwoydelivery/utility/normal_dialog.dart';

class EditInfoShop extends StatefulWidget {
  @override
  _EditInfoShopState createState() => _EditInfoShopState();
}

class _EditInfoShopState extends State<EditInfoShop> {
  String nameShop, address, phone, urlImage;
  Location location = Location();
  double lat, lng;

  UserModel userModel;

  @override
  void initState() {
 
    super.initState();
    readCurrentInfo();

    location.onLocationChanged.listen((event) {
      setState(() {
        lat = event.latitude;
        lng = event.longitude;
        // print('lat = $lat');
        // print('lng = $lng');
      });
    });
  }

  Future<Null> readCurrentInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String mem_id = preferences.getString('mem_id');

    String url =
        '${MyConstant().domain}/HiwwoyDelivery/getuserwhereid.php?isAdd=true&mem_id=$mem_id';

    Response response = await Dio().get(url);
    print('respon ===============> $response');

    var result = json.decode(response.data);
    print('result ===============> $result');

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
            onPressed: () {},
            label: Text('Camara'),
            icon: Icon(Icons.camera),
            heroTag: UniqueKey(),
            backgroundColor: Colors.pink,
          ),
          SizedBox(
            width: 8.0,
          ),
          FloatingActionButton.extended(
            onPressed: () {},
            label: Text('Camara'),
            heroTag: UniqueKey(),
            icon: Icon(Icons.photo_library),
            backgroundColor: Colors.pink,
          ),
        ],
      ),
    );
  }

  Widget showContent() {
  return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            showImage(),
            nameShopForm(),
            addressForm(),
            phoneForm(),
            lat == null ? MyStyle().showProgress : ShowMap() ,
            MyStyle().mySizebox(),
            saveButton(),
            MyStyle().mySizebox(),
            MyStyle().mySizebox(),
            MyStyle().mySizebox(),
            MyStyle().mySizebox(),
            MyStyle().mySizebox(),
            // addAndEditButton(),
            // addAndEditButton2(),
          ],
        ),
      );
  }
  Widget saveButton() {
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
       
        }
      },
      icon: Icon(
        Icons.save,
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
      borderRadius: BorderRadius.circular(30.0),
      ),
      color: Colors.yellow,
    );
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

  Container ShowMap() {
    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(lat, lng),
      zoom: 16.0,
    );

    return Container(
      margin: EdgeInsets.only(top: 16.0),
      height: 250.0,
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
          child: Image.network('${MyConstant().domain}$urlImage'),
        ),
      );
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
