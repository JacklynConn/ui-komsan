import '/app/models/hotel_model.dart';
import '/app/models/place_model.dart';
import '/app/models/restaurant_model.dart';

class NotificationModel {
  List<Notifications>? notifications;

  NotificationModel({this.notifications});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    if (json['notifications'] != null) {
      notifications = <Notifications>[];
      json['notifications'].forEach((v) {
        notifications!.add(Notifications.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (notifications != null) {
      data['notifications'] =
          notifications!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Notifications {
  int? id;
  int? userId;
  int? notificationId;
  int? status;
  String? createdAt;
  String? updatedAt;
  dynamic relatedData;
  Notification? notification;

  Notifications({
    this.id,
    this.userId,
    this.notificationId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.relatedData,
    this.notification,
  });

  factory Notifications.fromJson(Map<String, dynamic> json) {
    dynamic relatedData;
    switch (json['notification']['type']) {
      case 1:
        relatedData = PlaceModel.fromJson(json['related_data']);
        break;
      case 2:
        relatedData = HotelModel.fromJson(json['related_data']);
        break;
      case 3:
        relatedData = RestaurantModel.fromJson(json['related_data']);
        break;
      default:
        relatedData = null;
    }

    return Notifications(
      id: json['id'],
      userId: json['user_id'],
      notificationId: json['notification_id'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      relatedData: relatedData,
      notification: Notification.fromJson(json['notification']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['notification_id'] = notificationId;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['related_data'] = relatedData;
    if (notification != null) {
      data['notification'] = notification!.toJson();
    }
    return data;
  }
}

class Notification {
  int? id;
  String? title;
  String? body;
  String? image;
  int? type;
  int? relatedId;
  int? status;
  String? createdAt;
  String? updatedAt;

  Notification(
      {this.id,
      this.title,
      this.body,
      this.image,
      this.type,
      this.relatedId,
      this.status,
      this.createdAt,
      this.updatedAt});

  Notification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    image = json['image'];
    type = json['type'];
    relatedId = json['related_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['body'] = body;
    data['image'] = image;
    data['type'] = type;
    data['related_id'] = relatedId;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
