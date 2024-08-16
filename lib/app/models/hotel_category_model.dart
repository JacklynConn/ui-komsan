class HotelCatModel {
  int? catHotelId;
  String? catHotelName;

  HotelCatModel({this.catHotelId, this.catHotelName});

  HotelCatModel.fromJson(Map<String, dynamic> json) {
    catHotelId = json['cat_hotel_id'];
    catHotelName = json['cat_hotel_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cat_hotel_id'] = catHotelId;
    data['cat_hotel_name'] = catHotelName;
    return data;
  }
}