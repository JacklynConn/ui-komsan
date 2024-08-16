import 'village_model.dart';
//heng 29-may-2024
import '';
class CommuneModel {
  int? communeCode;
  String? communeNameen;
  String? communeNamekh;
  VillageModel? village;

  CommuneModel({this.communeCode, this.communeNameen,this.communeNamekh, this.village});

  CommuneModel.fromJson(Map<String, dynamic> json) {
    communeCode = json['commune_code'];
    communeNameen = json['commune_nameen'];
    communeNamekh = json['commune_namekh'];
    village = json['village'] != null ? new VillageModel.fromJson(json['village']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commune_code'] = communeCode;
    data['commune_nameen'] = communeNameen;
    data['commune_namekh'] = communeNamekh;
    if (village != null) {
      data['village'] = village!.toJson();
    }
    return data;
  }}
//heng 10-june-2024