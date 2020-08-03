class FoodModel {
  String foodsId;
  String memId;
  String foodsName;
  String foodsImage;
  String foodsPrice;
  String foodsDetail;

  FoodModel(
      {this.foodsId,
      this.memId,
      this.foodsName,
      this.foodsImage,
      this.foodsPrice,
      this.foodsDetail});

  FoodModel.fromJson(Map<String, dynamic> json) {
    foodsId = json['foods_id'];
    memId = json['mem_id'];
    foodsName = json['foods_name'];
    foodsImage = json['foods_image'];
    foodsPrice = json['foods_price'];
    foodsDetail = json['foods_detail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['foods_id'] = this.foodsId;
    data['mem_id'] = this.memId;
    data['foods_name'] = this.foodsName;
    data['foods_image'] = this.foodsImage;
    data['foods_price'] = this.foodsPrice;
    data['foods_detail'] = this.foodsDetail;
    return data;
  }
}
