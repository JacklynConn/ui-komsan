
class FoodTypeModel {
  int? foodTypeId;
  String? foodTypeName;

  FoodTypeModel({this.foodTypeId, this.foodTypeName});

  FoodTypeModel.fromJson(Map<String, dynamic> json) {
    foodTypeId = json['food_type_id'];
    foodTypeName = json['food_type_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['food_type_id'] = foodTypeId;
    data['food_type_name'] = foodTypeName;
    return data;
  }

}