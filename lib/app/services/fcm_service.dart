import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '/app/constants/global_variable.dart';
import '../../firebase_options.dart';
import 'awesome_notification_service.dart';

class FcmService {
  FcmService._();

  static late FirebaseMessaging messaging;

  static Future<void> initFcm() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      messaging = FirebaseMessaging.instance;
      await _setupFcmNotificationSettings();
      await _generateFcmToken();
      FirebaseMessaging.instance.subscribeToTopic('MACH');
      FirebaseMessaging.onMessage.listen(_fcmForegroundHandler);
      FirebaseMessaging.onBackgroundMessage(_fcmBackgroundHandler);
      FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);
    } catch (error) {
      print('Error initializing FCM: $error');
    }
  }

  static Future<void> _setupFcmNotificationSettings() async {
    messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      sound: true,
      badge: true,
    );
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  static Future<void> _generateFcmToken() async {
    try {
      var token = await messaging.getToken();
      if (token != null) {
        print("token : $token");
        await sendTokenToBackend(token: token);
      } else {
        await Future.delayed(const Duration(seconds: 5));
        _generateFcmToken();
      }
    } catch (e) {
      print('Error generating FCM token: $e');
    }
  }

  // static _sendFcmTokenToServer() async {
  //   // var token = StorageService.read('fcm_token');
  //   // // check is authenticated
  //   // var isAuthenticated = StorageService.read('isAuthenticated');
  //   // if (token != null && isAuthenticated != null && isAuthenticated) {
  //   // // TODO SEND FCM TOKEN TO SERVER
  //   // await AuthNetworkService.to.sendDeviceToken(deviceToken: token);
  //   // }
  // }

  @pragma('vm:entry-point')
  static Future<void> _fcmBackgroundHandler(RemoteMessage message) async {
    if (message.data.isEmpty && message.data['title'] == null) {
      return;
    }

    if (GetPlatform.isAndroid) {
      AwesomeNotificationService.showNotification(
        id: 1,
        title: message.data['title'] ?? 'Tittle',
        body: message.data['body'] ?? 'Body',
        payload: message.data.cast(),
        actionButtons: [],
        notificationLayout: NotificationLayout.Default,
      );
    }
    if (GetPlatform.isIOS) {
      AwesomeNotificationService.showNotification(
        id: 1,
        title: message.notification?.title ?? 'Tittle',
        body: message.notification?.body ?? 'Body',
        payload: message.data.cast(),
        actionButtons: [],
        notificationLayout: NotificationLayout.Default,
      );
    }
  }

  static Future<void> _fcmForegroundHandler(RemoteMessage message) async {
    print("foreground message : ${message.data}");
    if (message.data.isEmpty && message.notification?.title == null) {
      return;
    }
    if (GetPlatform.isAndroid) {
      AwesomeNotificationService.showNotification(
        id: 1,
        title: message.notification?.title ?? 'Tittle',
        body: message.notification?.body ?? 'Body',
        payload: message.data.cast(),
        actionButtons: [],
        notificationLayout: NotificationLayout.Default,
      );
    }
  }

  static Future<void> _onMessageOpenApp(RemoteMessage message) async {
    if (message.data.isEmpty && message.data['title'] == null) {
      return;
    }
    if (GetPlatform.isAndroid) {
      AwesomeNotificationService.showNotification(
        id: 1,
        title: message.data['title'] ?? 'Tittle',
        body: message.data['body'] ?? 'Body',
        payload: message.data.cast(),
        actionButtons: [],
        notificationLayout: NotificationLayout.Default,
      );
    }
    if (GetPlatform.isIOS) {
      AwesomeNotificationService.showNotification(
        id: 1,
        title: message.notification?.title ?? 'Tittle',
        body: message.notification?.body ?? 'Body',
        payload: message.data.cast(),
        actionButtons: [],
        notificationLayout: NotificationLayout.Default,
      );
    }
  }

  static sendTokenToBackend({required String token}) async {
    final storage = GetStorage();
    Dio dio = Dio();
    var accessToken = storage.read('access_token');
    if (accessToken == null) {
      print("Access token is null, can't send token to backend");
      return;
    }

    try {
      var response = await dio.post(
        '$baseApiUrl/device-tokens',
        data: {
          'device_token': token,
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      if (response.statusCode == 200) {
        print('Token sent to backend');
      } else {
        print('Error sending token to backend: ${response.data}');
      }
    } on DioException catch (e) {
      print('Error sending token to backend: $e');
    } catch (e) {
      throw Exception('Error sending token to backend: $e');
    }
  }
}
