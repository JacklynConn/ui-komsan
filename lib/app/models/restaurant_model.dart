import 'village_model.dart';
import 'food_model.dart';
import 're_gallery_model.dart';

// class RestaurantModel {
//   Data? data;
//   RestaurantModel ({this.data});
//
//   RestaurantModel.fromJson(Map<String, dynamic> json) {
//     data = json['data'] != null ? Data.fromJson(json['data']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     return data;
//   }
// }

class RestaurantModel {
  int? resId;
  int? villageCode;
  String? resName;
  String? resDes;
  String? latitude;
  String? longitude;
  String? resPhone;
  String? resEmail;
  String? resWeb;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? openTime;
  String? closeTime;
  double? averageRating;
  double? distance;
  VillageModel? village;
  List<FoodModel>? foods;
  List<ReGalleryModel>? restaurantGallery;

  RestaurantModel(
      {this.resId,
        this.villageCode,
        this.resName,
        this.resDes,
        this.latitude,
        this.longitude,
        this.resPhone,
        this.resEmail,
        this.resWeb,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.openTime,
        this.closeTime,
        this.averageRating,
        this.distance,
        this.village,
        this.foods,
        this.restaurantGallery});

  RestaurantModel.fromJson(Map<String, dynamic> json) {
    resId = json['res_id'];
    villageCode = json['village_code'];
    resName = json['res_name'];
    resDes = json['res_des'];
    latitude = json['latitude'] ;
    longitude = json['longitude'];
    resPhone = json['res_phone'];
    resEmail = json['res_email'];
    resWeb = json['res_web'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    openTime = json['open_time'];
    closeTime = json['close_time'];
    averageRating = json['average_rating']?.toDouble();
    distance = json['distance']?.toDouble();
    village =
    json['village'] != null ? VillageModel.fromJson(json['village']) : null;
    if (json['foods'] != null) {
      foods = <FoodModel>[];
      json['foods'].forEach((v) {
        foods!.add(FoodModel.fromJson(v));
      });
    }
    if (json['restaurant_gallery'] != null) {
      restaurantGallery = <ReGalleryModel>[];
      json['restaurant_gallery'].forEach((v) {
        restaurantGallery!.add(ReGalleryModel.fromJson(v));
      });
    }
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['res_id'] = resId;
    data['village_code'] = villageCode;
    data['res_name'] = resName;
    data['res_des'] = resDes;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['res_phone'] = resPhone;
    data['res_email'] = resEmail;
    data['res_web'] = resWeb;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['open_time'] = openTime;
    data['close_time'] = closeTime;
    data['average_rating'] = averageRating;
    data['distance'] = distance;
    if (village != null) {
      data['village'] = village!.toJson();
    }
    if (foods != null) {
      data['foods'] = foods!.map((v) => v.toJson()).toList();
    }
    if (restaurantGallery != null) {
      data['restaurant_gallery'] =
          restaurantGallery!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
