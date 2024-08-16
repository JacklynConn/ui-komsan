import 'place_model.dart';

class PlaceFavModel {
  int? favoritePlaceId;
  int? placeId;
  int? userId;
  int? status;
  String? createdAt;
  String? updatedAt;
  PlaceModel? place;

  PlaceFavModel({
    this.favoritePlaceId,
    this.placeId,
    this.userId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.place,
  });

  PlaceFavModel.fromJson(Map<String, dynamic> json) {
    favoritePlaceId = json['favorite_place_id'];
    placeId = json['place_id'];
    userId = json['user_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    place = json['place'] != null ? PlaceModel.fromJson(json['place']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['favorite_place_id'] = favoritePlaceId;
    data['place_id'] = placeId;
    data['user_id'] = userId;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (place != null) {
      data['place'] = place!.toJson();
    }
    return data;
  }
}
