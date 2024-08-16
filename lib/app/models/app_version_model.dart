class AppVersionModel {
  String? message;
  Version? version;

  AppVersionModel({this.message, this.version});

  AppVersionModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    version =
    json['version'] != null ? new Version.fromJson(json['version']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.version != null) {
      data['version'] = this.version!.toJson();
    }
    return data;
  }
}

class Version {
  String? version;
  String? updatedAt;
  String? createdAt;
  int? id;

  Version({this.version, this.updatedAt, this.createdAt, this.id});

  Version.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['version'] = this.version;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}
