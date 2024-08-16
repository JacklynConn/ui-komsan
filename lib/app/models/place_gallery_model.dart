
class PlaceGalleryModel {
  int? placeGalleryId;
  int? placeId;
  String? image;
  int? status;
  String? createdAt;
  String? updatedAt;

  PlaceGalleryModel({this.placeGalleryId,
    this.placeId,
    this.image,
    this.status,
    this.createdAt,
    this.updatedAt});

  PlaceGalleryModel.fromJson(Map<String, dynamic> json) {
    placeGalleryId = json['gallery_id'];
    placeId = json['place_id'];
    image = json['place_image'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['gallery_id'] = placeGalleryId;
    data['place_id'] = placeId;
    data['place_image'] = image;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}