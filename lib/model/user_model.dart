class UserModel {
  String memId;
  String memFullname;
  String memUsername;
  String memPassword;
  String memPhone;
  String memStatus;
  String shopName;
  String shopPhone;
  String shopAddress;
  String shopImage;
  String shopLat;
  String shopLng;
  String token;

  UserModel(
      {this.memId,
      this.memFullname,
      this.memUsername,
      this.memPassword,
      this.memPhone,
      this.memStatus,
      this.shopName,
      this.shopPhone,
      this.shopAddress,
      this.shopImage,
      this.shopLat,
      this.shopLng,
      this.token});

  UserModel.fromJson(Map<String, dynamic> json) {
    memId = json['mem_id'];
    memFullname = json['mem_fullname'];
    memUsername = json['mem_username'];
    memPassword = json['mem_password'];
    memPhone = json['mem_phone'];
    memStatus = json['mem_status'];
    shopName = json['shop_name'];
    shopPhone = json['shop_phone'];
    shopAddress = json['shop_address'];
    shopImage = json['shop_image'];
    shopLat = json['shop_lat'];
    shopLng = json['shop_lng'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mem_id'] = this.memId;
    data['mem_fullname'] = this.memFullname;
    data['mem_username'] = this.memUsername;
    data['mem_password'] = this.memPassword;
    data['mem_phone'] = this.memPhone;
    data['mem_status'] = this.memStatus;
    data['shop_name'] = this.shopName;
    data['shop_phone'] = this.shopPhone;
    data['shop_address'] = this.shopAddress;
    data['shop_image'] = this.shopImage;
    data['shop_lat'] = this.shopLat;
    data['shop_lng'] = this.shopLng;
    data['token'] = this.token;
    return data;
  }
}
