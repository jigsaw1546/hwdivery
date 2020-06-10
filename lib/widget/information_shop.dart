import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hiwwoydelivery/model/user_model.dart';
import 'package:hiwwoydelivery/screens/add_info_shop.dart';
import 'package:hiwwoydelivery/screens/edit_info_shop.dart';
import 'package:hiwwoydelivery/utility/my_constant.dart';
import 'package:hiwwoydelivery/utility/my_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InformationShop extends StatefulWidget {
  @override
  _InformationShopState createState() => _InformationShopState();
}

class _InformationShopState extends State<InformationShop> {
  UserModel userModel;

  @override
  void initState() {
    super.initState();
    readDataUser();
  }

  Future<Null> readDataUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String mem_id = preferences.getString('mem_id');
    String url =
        '${MyConstant().domain}/HiwwoyDelivery/getuserwhereid.php?isAdd=true&mem_id=$mem_id';
    await Dio().get(url).then((value) {
      // print('value = $value');
      var result = json.decode(value.data);
      // print('result = $result');
      for (var map in result) {
        setState(() {
          userModel = UserModel.fromJson(map);
        });
        print('shopname = ${userModel.shopName}');
      }
    });
  }

  void routeToAddInfo() {
    Widget widget = userModel.shopName.isEmpty ? AddInfoShop() : EditInfoShop() ;
    MaterialPageRoute materialPageRoute = MaterialPageRoute(
      builder: (context) => widget,
    );
    Navigator.push(context, materialPageRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        userModel == null
            ? MyStyle().showProgress()
            : userModel.shopName.isEmpty
                ? showNoData(context)
                : ShowListInfoShop(),
        addAndEditButton(),
      ],
    );
  }

  Widget ShowListInfoShop() => Column(
        children: <Widget>[
          Center(
              child: MyStyle()
                  .showTitleblack('รายละเอียดร้านค้า : ${userModel.shopName}')),
          showimage(),
          Center(child: MyStyle().showTitleblack('ที่อยู่ของร้าน ')),
          Text(userModel.shopAddress),
          showMap(),
        ],
      );

  Container showimage() {
    return Container(
      width: 200.0,
      height: 200.0,
          child: Image.network('${MyConstant().domain}${userModel.shopImage}'),
        );
        
  }
  

  Set<Marker> shopMarker() {
    return <Marker>[
      Marker(
          markerId: MarkerId('ShopID '),
          position: LatLng(
            double.parse(userModel.shopLat),
            double.parse(userModel.shopLng),
          ),
          infoWindow: InfoWindow(
              title: 'ตำแหน่งร้าน',
              snippet:
                  'ละติจูด = ${userModel.shopLat}, ลองติจูด = ${userModel.shopLng}')),
    ].toSet();
  }

  Widget showMap() {
    double lat = double.parse(userModel.shopLat);
    double lng = double.parse(userModel.shopLng);

    LatLng latLng = LatLng(lat, lng);
    CameraPosition position = CameraPosition(target: latLng, zoom: 16.0);

    return Expanded(

      child: GoogleMap(
        initialCameraPosition: position,
        mapType: MapType.normal,
        onMapCreated: (controller) {},
        markers: shopMarker(),
      ),
    );
  }
  

  Widget showNoData(BuildContext context) =>
      MyStyle().titleCenter(context, 'ยังไม่มีข้อมูล กรุณาเพิ่มข้อมูล!');

  Row addAndEditButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 20.0, bottom: 20.0),
              child: FloatingActionButton(
                child: Icon(Icons.edit),
                onPressed: () {
                  routeToAddInfo();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
