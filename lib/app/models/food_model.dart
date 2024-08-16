


class FoodModel {
  int? foodId;
  int? resId;
  int? foodTypeId;
  String? foodName;
  double? foodPrice;
  String? createdAt;
  String? updatedAt;

  FoodModel(
      {this.foodId,
        this.resId,
        this.foodTypeId,
        this.foodName,
        this.foodPrice,
        this.createdAt,
        this.updatedAt});

  FoodModel.fromJson(Map<String, dynamic> json) {
    foodId = json['food_id'];
    resId = json['res_id'];
    foodTypeId = json['food_type_id'];
    foodName = json['food_name'];
    foodPrice = (json['food_price'] as num?)?.toDouble();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['food_id'] = foodId;
    data['res_id'] = resId;
    data['food_type_id'] = foodTypeId;
    data['food_name'] = foodName;
    data['food_price'] = foodPrice;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}