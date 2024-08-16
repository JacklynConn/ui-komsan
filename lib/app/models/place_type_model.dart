
class PlaceTypesModel {
  int? placeTypeId;
  int? placeId;
  String? placeTypeName;
  int? catPlaceId;


  PlaceTypesModel({this.placeTypeId,
    this.placeId,
    this.placeTypeName,
    this.catPlaceId});

  PlaceTypesModel.fromJson(Map<String, dynamic> json) {
    placeTypeId = json['place_type_id'];
    placeId = json['place_id'];
    placeTypeName = json['category_place']['cat_place_name'];
    catPlaceId = json['cat_place_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['place_type_id'] = placeTypeId;
    data['place_id'] = placeId;
    data['category_place']['cat_place_name'] = placeTypeName;
    data['cat_place_id'] = catPlaceId;
    return data;
  }
}