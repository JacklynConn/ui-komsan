

class PlaceRatingModel {
  int? placeRatingId;
  int? placeId;
  int? userId;
  double? rating;
  String? comment;
  String? createdAt;
  String? updatedAt;

  PlaceRatingModel(
      {this.placeRatingId,
        this.placeId,
        this.userId,
        this.rating,
        this.comment,
        this.createdAt,
        this.updatedAt});

  PlaceRatingModel.fromJson(Map<String, dynamic> json) {
    placeRatingId = json['place_rating_id'];
    placeId = json['place_id'];
    userId = json['user_id'];
    rating = json['rating']?.toDouble();
    comment = json['comment'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['place_rating_id'] = this.placeRatingId;
    data['place_id'] = this.placeId;
    data['user_id'] = this.userId;
    data['rating'] = this.rating;
    data['comment'] = this.comment;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
