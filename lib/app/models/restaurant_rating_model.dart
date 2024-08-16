

class ResRatingModel {
  int? resRatingId;
  int? userId;
  int? resId;
  double? rating;
  String? comment;
  int? status;
  String? createdAt;
  String? updatedAt;

  ResRatingModel(
      {this.resRatingId,
        this.userId,
        this.resId,
        this.rating,
        this.comment,
        this.status,
        this.createdAt,
        this.updatedAt});

  ResRatingModel.fromJson(Map<String, dynamic> json) {
    resRatingId = json['res_rating_id'];
    userId = json['user_id'];
    resId = json['res_id'];
    rating = json['rating']?.toDouble();
    comment = json['comment'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['res_rating_id'] = this.resRatingId;
    data['user_id'] = this.userId;
    data['res_id'] = this.resId;
    data['rating'] = this.rating;
    data['comment'] = this.comment;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
