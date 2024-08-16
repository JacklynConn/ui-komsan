class UserResModel {
  bool? success;
  String? accessToken;
  User? user;
  String? message;

  UserResModel({this.success, this.accessToken, this.user, this.message});

  UserResModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    accessToken = json['access_token'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['access_token'] = this.accessToken;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? phone;
  String? profileImg;
  int? status;
  String? createdAt;
  String? updatedAt;
  Null? verificationCode;

  User(
      {this.id,
      this.name,
      this.phone,
      this.profileImg,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.verificationCode});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    profileImg = json['profile_img'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    verificationCode = json['verification_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['profile_img'] = this.profileImg;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['verification_code'] = this.verificationCode;
    return data;
  }
}
