//thak 17-05-2024
import 'province_model.dart';
//heng 29-may-2024
import 'commune_model.dart';
import 'district_model.dart';

class VillageModel {
  int? villageCode;
  String? villageNameen;
  ProvinceModel? province;

  VillageModel({this.villageCode, this.villageNameen,this.province});

  VillageModel.fromJson(Map<String, dynamic> json) {
    villageCode = json['village_code'];
    villageNameen = json['village_nameen'];
    province = json['province'] != null ? ProvinceModel.fromJson(json['province']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['village_code'] = villageCode;
    data['village_nameen'] = villageNameen;
    if (province != null) {
      data['province'] = province!.toJson();
    }
    return data;
  }
}
//thak 17-05-2024