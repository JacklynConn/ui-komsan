//heng 29-may-2024
import 'province_model.dart';

class DistrictModel {
  int? districtCode;
  String? districtNameen;
  String? districtNamekh;
  ProvinceModel? province;

  DistrictModel({
    this.districtCode,
    this.districtNameen,
    this.districtNamekh,
    this.province,
  });

  DistrictModel.fromJson(Map<String, dynamic> json) {
    districtCode = json['district_code'];
    districtNameen = json['district_nameen'];
    districtNamekh = json['district_namekh'];
    province = json['province'] != null ? ProvinceModel.fromJson(json['province']) : null;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['district_code'] = districtCode;
    data['district_nameen'] = districtNameen;
    data['district_namekh'] = districtNamekh;
    if (province != null) {
      data['province'] = province!.toJson();
    }
    return data;
  }
}
//heng 10-june-2024