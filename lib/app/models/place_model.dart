import 'place_rating_model.dart';
import 'place_gallery_model.dart';
import 'place_type_model.dart';
import 'village_model.dart';

class PlaceModel {
  int? placeId;
  int? villageCode;
  String? placeName;
  String? placeDes;
  String? phone;
  String? email;
  String? latitude;
  String? longitude;
  String? website;
  bool? status;
  String? createdAt;
  String? updatedAt;
  double? averageRating;
  double? distance;
  VillageModel? village;
  List<PlaceTypesModel>? placeTypes;
  List<PlaceGalleryModel>? placeGallery;
  List<PlaceRatingModel>? placeRatings;

  PlaceModel({
    this.placeId,
    this.villageCode,
    this.placeName,
    this.placeDes,
    this.phone,
    this.email,
    this.latitude,
    this.longitude,
    this.website,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.averageRating,
    this.distance,
    this.village,
    this.placeTypes,
    this.placeGallery,
    this.placeRatings,
  });

  PlaceModel.fromJson(Map<String, dynamic> json) {
    placeId = json['place_id'];
    villageCode = json['village_code'];
    placeName = json['place_name'];
    placeDes = json['place_des'];
    phone = json['phone'];
    email = json['email'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    website = json['website'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    averageRating = json['average_rating']?.toDouble();
    distance = json['distance']?.toDouble();
    village = json['village'] != null ? VillageModel.fromJson(json['village']) : null;

    if (json['place_type'] != null) {
      placeTypes = <PlaceTypesModel>[];
      json['place_type'].forEach((v) {
        placeTypes!.add(PlaceTypesModel.fromJson(v));
      });
    }

    if (json['place_gallery'] != null) {
      placeGallery = <PlaceGalleryModel>[];
      json['place_gallery'].forEach((v) {
        placeGallery!.add(PlaceGalleryModel.fromJson(v));
      });
    }
    if (json['place_ratings'] != null) {
      placeRatings = <PlaceRatingModel>[];
      json['place_ratings'].forEach((v) {
        placeRatings!.add(PlaceRatingModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['place_id'] = placeId;
    data['village_code'] = villageCode;
    data['place_name'] = placeName;
    data['place_des'] = placeDes;
    data['phone'] = phone;
    data['email'] = email;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['website'] = website;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['distance'] = distance;
    data['average_rating'] = averageRating;
    if (village != null) {
      data['village'] = village!.toJson();
    }
    if (placeTypes != null) {
      data['place_type'] = placeTypes!.map((v) => v.toJson()).toList();
    }
    if (placeGallery != null) {
      data['place_gallery'] = placeGallery!.map((v) => v.toJson()).toList();
    }
    if (placeRatings != null) {
      data['place_ratings'] = placeRatings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}