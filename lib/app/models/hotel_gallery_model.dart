//thak 17-05-2024

class HotelGalleryModel {
  int? hotelGalleryId;
  int? hotelId;
  String? image;
  int? status;
  String? createdAt;
  String? updatedAt;

  HotelGalleryModel(
      {this.hotelGalleryId,
        this.hotelId,
        this.image,
        this.status,
        this.createdAt,
        this.updatedAt});

  HotelGalleryModel.fromJson(Map<String, dynamic> json) {
    hotelGalleryId = json['hotel_gallery_id'];
    hotelId = json['hotel_id'];
    image = json['image'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hotel_gallery_id'] = hotelGalleryId;
    data['hotel_id'] = hotelId;
    data['image'] = image;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
//thak 17-05-2024