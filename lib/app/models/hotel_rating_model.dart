class HotelRatingModel{
  int? hotelRatingId;
  int? userId;
  int? hotelId;
  double? rating;
  String? comment;
  String? status;
  String? createdAt;
  String? updatedAt;

  HotelRatingModel({
    this.hotelRatingId,
    this.userId,
    this.hotelId,
    this.rating,
    this.comment,
    this.status,
    this.createdAt,
    this.updatedAt
  });

  HotelRatingModel.fromJson(Map<String, dynamic> json) {
    hotelRatingId = json['hotel_rating_id'];
    userId = json['user_id'];
    hotelId = json['hotel_id'];
    rating = json['rating']?.toDouble();
    comment = json['comment'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hotel_rating_id'] = this.hotelRatingId;
    data['user_id'] = this.userId;
    data['hotel_id'] = this.hotelId;
    data['rating'] = this.rating;
    data['comment'] = this.comment;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}