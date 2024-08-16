//thak 17-05-2024

class HotelTypeModel {
  int? hotelTypeId;
  int? hotelId;
  String? hotelTypeName;
  int? catHotelId;

  HotelTypeModel(
      {this.hotelTypeId,
        this.hotelId,
        this.hotelTypeName,
        this.catHotelId});

  HotelTypeModel.fromJson(Map<String, dynamic> json) {
    hotelTypeId = json['hotel_type_id'];
    hotelId = json['hotel_id'];
    hotelTypeName = json['hotel_type_name'];
    catHotelId = json['cat_hotel_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hotel_type_id'] = hotelTypeId;
    data['hotel_id'] = hotelId;
    data['hotel_type_name'] = hotelTypeName;
    data['cat_hotel_id'] = catHotelId;
    return data;
  }
}

//thak 17-05-2024