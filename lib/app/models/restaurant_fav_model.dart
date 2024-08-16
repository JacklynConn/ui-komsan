
import 'restaurant_model.dart';

class ResFavModel {
  int? favResId;
  int? resId;
  int? userId;
  bool? status;
  String? createdAt;
  String? updatedAt;
  RestaurantModel? restaurant;

  ResFavModel(
      {this.favResId,
        this.resId,
        this.userId,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.restaurant});

  ResFavModel.fromJson(Map<String, dynamic> json) {
    favResId = json['fav_res_id'];
    resId = json['res_id'];
    userId = json['user_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    restaurant = json['restaurant'] != null
        ? RestaurantModel.fromJson(json['restaurant'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fav_res_id'] = this.favResId;
    data['res_id'] = this.resId;
    data['user_id'] = this.userId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.restaurant != null) {
      data['restaurant'] = this.restaurant!.toJson();
    }
    return data;
  }
}
