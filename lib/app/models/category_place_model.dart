class CategoryPlaceModel {
  int catPlaceId;
  String catPlaceName;
  bool isSelected = false;

  CategoryPlaceModel({
    required this.catPlaceId,
    required this.catPlaceName,
  });

  factory CategoryPlaceModel.fromJson(Map<String, dynamic> json) => CategoryPlaceModel(
    catPlaceId: json["cat_place_id"],
    catPlaceName: json["cat_place_name"],
  );

  Map<String, dynamic> toJson() => {
    "cat_place_id": catPlaceId,
    "cat_place_name": catPlaceName,
  };
}