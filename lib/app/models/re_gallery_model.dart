
class ReGalleryModel {
  int? resGalleryId;
  int? resId;
  String? image;
  String? createdAt;
  String? updatedAt;

  ReGalleryModel(
      {this.resGalleryId,
        this.resId,
        this.image,
        this.createdAt,
        this.updatedAt});

  ReGalleryModel.fromJson(Map<String, dynamic> json) {
    resGalleryId = json['res_gallery_id'];
    resId = json['res_id'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['res_gallery_id'] = resGalleryId;
    data['res_id'] = resId;
    data['image'] = image;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}