
import 'hotel_model.dart';

class HotelFavModel {
  int? hotelFavoriteId;
  int? hotelId;
  int? userId;
  int? status;
  String? createdAt;
  String? updatedAt;
  HotelModel? hotel;

  HotelFavModel({
    this.hotelFavoriteId,
    this.hotelId,
    this.userId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.hotel,
  });

  HotelFavModel.fromJson(Map<String, dynamic> json) {
    hotelFavoriteId = json['hotel_favorite_id'];
    hotelId = json['hotel_id'];
    userId = json['user_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    hotel = json['hotel'] != null ? HotelModel.fromJson(json['hotel']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hotel_favorite_id'] = hotelFavoriteId;
    data['hotel_id'] = hotelId;
    data['user_id'] = userId;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (hotel != null) {
      data['hotel'] = hotel!.toJson();
    }
    return data;
  }
}