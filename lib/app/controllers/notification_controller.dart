import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import '/app/constants/global_variable.dart';
import '../models/notification_model.dart';

class NotificationController extends GetxController {
  var notifications = <Notifications>[].obs;
  var unreadCount = 0.obs;
  var isLoading = false.obs;
  var dio = Dio();
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
    fetCountUnreadNotifications();
  }

  String formatDateTime(String date, String time) {
    final DateTime dateTime = DateTime.parse(date);
    final DateFormat formatter = DateFormat('yyyy-MM-dd ● kk:mm', 'km_KH');
    return formatter.format(dateTime);
  }


  String formatDateTimeWithTimeZone(String dateTime, String timeZone) {
    final DateTime parsedDateTime = DateTime.parse(dateTime).toUtc();
    final DateFormat formatter = DateFormat('dd-MMM-yyyy ● HH:mm:ss');
    return formatter.format(parsedDateTime.add(Duration(hours: int.parse(timeZone))));
  }

  Future<void> fetchNotifications() async {
    isLoading.value = true;
    try {
      final token = box.read('access_token');
      var response = await dio.get(
        '$baseApiUrl/get-notification',
        options: Options(
          validateStatus: (status) {
            return status! < 500;
          },
          followRedirects: false,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        notifications.value = (response.data['notifications'] as List)
            .map((data) => Notifications.fromJson(data))
            .toList();
        notifications.refresh();
      }
    } catch (e) {
      print('Failed to load notifications $e');
      throw Exception('Failed to load notifications $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetCountUnreadNotifications() async {
    try {
      final token = box.read('access_token');
      var response = await dio.get(
        '$baseApiUrl/count-unread-notification',
        options: Options(
          validateStatus: (status) {
            return status! < 500;
          },
          followRedirects: false,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        unreadCount.value = response.data['count'];
      }
    } catch (e) {
      print('Failed to load unread notifications $e');
      throw Exception('Failed to load unread notifications $e');
    }
  }

  Future<void> markAsRead(int id) async {
    try {
      final token = box.read('access_token');
      var response = await dio.post(
        '$baseApiUrl/mark-read/$id',
        queryParameters: {'id': id},
        options: Options(
          validateStatus: (status) {
            return status! < 500;
          },
          followRedirects: false,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        fetchNotifications();
        fetCountUnreadNotifications();
      }
    } catch (e) {
      print('Failed to mark as read $e');
      throw Exception('Failed to mark as read $e');
    }
  }

  Future<void> deleteNotification(int notificationId) async {
    try {
      final token = box.read('access_token');
      var response = await dio.post(
        '$baseApiUrl/delete-notification/$notificationId',
        queryParameters: {'id': notificationId},
        options: Options(
          validateStatus: (status) {
            return status! < 500;
          },
          followRedirects: false,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        fetchNotifications();
        fetCountUnreadNotifications();
      }
    } catch (e) {
      print('Failed to delete notification $e');
      throw Exception('Failed to delete notification $e');
    }
  }

  Future<void> deleteAllNotifications() async {
    try {
      final token = box.read('access_token');
      var response = await dio.post(
        '$baseApiUrl/delete-all-notification',
        options: Options(
          validateStatus: (status) {
            return status! < 500;
          },
          followRedirects: false,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        fetchNotifications();
        fetCountUnreadNotifications();
      }
    } catch (e) {
      print('Failed to delete all notifications $e');
      throw Exception('Failed to delete all notifications $e');
    }
  }
}
