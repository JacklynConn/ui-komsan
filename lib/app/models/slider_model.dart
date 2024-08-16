import 'hotel_model.dart';
import 'place_model.dart';
import 'restaurant_model.dart';

class SliderModel {
  int? idslider;
  String? title;
  String? image;
  String? description;
  int? type;
  int? relatedId;
  String? startDate;
  String? endDate;
  int? activeStatus;
  String? createdAt;
  String? updatedAt;
  dynamic relatedData;

  SliderModel(
      {this.idslider,
        this.title,
        this.image,
        this.description,
        this.type,
        this.relatedId,
        this.startDate,
        this.endDate,
        this.activeStatus,
        this.createdAt,
        this.updatedAt,
        this.relatedData});

  SliderModel.fromJson(Map<String, dynamic> json) {
    idslider = json['idslider'];
    title = json['title'];
    image = json['image'];
    description = json['description'];
    type = json['type'];
    relatedId = json['relatedId'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    activeStatus = json['active_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['related_data'] != null) {
      if(json['type'] == 1) { //=1 means related data is place
        relatedData =  PlaceModel.fromJson(json['related_data']);
      }
      else if(json['type'] == 2) { //=2 means related data is hotel
        relatedData = HotelModel.fromJson(json['related_data']);
      }
      else if(json['type'] ==3) { //=3 means related data is restaurant
        relatedData = RestaurantModel.fromJson(json['related_data']);
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idslider'] = this.idslider;
    data['title'] = this.title;
    data['image'] = this.image;
    data['description'] = this.description;
    data['type'] = this.type;
    data['relatedId'] = this.relatedId;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['active_status'] = this.activeStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['related_data'] = this.relatedData;
    return data;
  }
}