import 'village_model.dart';
import 'hotel_gallery_model.dart';
import 'hotel_type_model.dart';

class HotelModel {
  int? hotelId;
  int? villageCode;
  String? hotelName;
  String? hotelDes;
  String? phone;
  String? email;
  String? latitude;
  String? longitude;
  String? website;
  double? price;
  int? status;
  String? createdAt;
  String? updatedAt;
  double? averageRating;
  double? distance;
  VillageModel? village;
  List<HotelTypeModel>? hotelTypes;
  List<HotelGalleryModel>? hotelGallery;
  bool? isFavorite;

  HotelModel({
    this.hotelId,
    this.villageCode,
    this.hotelName,
    this.hotelDes,
    this.phone,
    this.email,
    this.latitude,
    this.longitude,
    this.website,
    this.price,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.averageRating,
    this.village,
    this.hotelTypes,
    this.hotelGallery,
    this.isFavorite,
    this.distance,
  });

  HotelModel.fromJson(Map<String, dynamic> json) {
    hotelId = json['hotel_id'];
    villageCode = json['village_code'];
    hotelName = json['hotel_name'];
    hotelDes = json['hotel_des'];
    phone = json['phone'];
    email = json['email'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    website = json['website'];
    price = json['price']?.toDouble();
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    distance = json['distance']?.toDouble();
    averageRating = json['average_rating']?.toDouble();
    village =
        json['village'] != null ? VillageModel.fromJson(json['village']) : null;
    if (json['hotel_types'] != null) {
      hotelTypes = <HotelTypeModel>[];
      json['hotel_types'].forEach((v) {
        hotelTypes!.add(HotelTypeModel.fromJson(v));
      });
    }
    if (json['hotel_gallery'] != null) {
      hotelGallery = <HotelGalleryModel>[];
      json['hotel_gallery'].forEach((v) {
        hotelGallery!.add(HotelGalleryModel.fromJson(v));
      });
    }
    isFavorite = json['is_favorite'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hotel_id'] = hotelId;
    data['village_code'] = villageCode;
    data['hotel_name'] = hotelName;
    data['hotel_des'] = hotelDes;
    data['phone'] = phone;
    data['email'] = email;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['website'] = website;
    data['price'] = price;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['average_rating'] = averageRating;
    data['distance'] = distance;
    if (village != null) {
      data['village'] = village!.toJson();
    }
    if (hotelTypes != null) {
      data['hotel_types'] = hotelTypes!.map((v) => v.toJson()).toList();
    }
    if (hotelGallery != null) {
      data['hotel_gallery'] = hotelGallery!.map((v) => v.toJson()).toList();
    }
    data['is_favorite'] = isFavorite;
    return data;
  }
}
