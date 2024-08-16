//thak 17-05-2024
class ProvinceModel {
  int? provinceCode;
  String? provinceNameen;
  // Heng 29-may-2024 update province_namekh with province_Image
  String? provinceNamekh;
  String? provinceImage;

  ProvinceModel(
      {
        this.provinceCode,
        this.provinceNameen,
        this.provinceNamekh,
        this.provinceImage});

  ProvinceModel.fromJson(Map<String, dynamic> json) {
    provinceCode = json['province_code'];
    provinceNameen = json['province_nameen'];
    provinceNamekh = json['province_namekh'];
    provinceImage = json['province_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['province_code'] = provinceCode;
    data['province_nameen'] = provinceNameen;
    data['province_namekh'] = provinceNamekh;
    data['province_image'] = provinceImage;
    // Heng 29-may-2024 update province_namekh with province_Image
    return data;
  }
}
//thak 17-05-2024