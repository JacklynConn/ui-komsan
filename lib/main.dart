import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '/app/services/fcm_service.dart';
import '/root_screen.dart';
import '/app/controllers/place_fav_controller.dart';
import '/app/controllers/res_fav_controller.dart';
import '/splash_screen.dart';
import 'app/controllers/hotel_fav_controller.dart';
import 'app/controllers/theme_controller.dart';
import 'app/screens/auth/login_screen.dart';
import 'app/screens/home/home_screen.dart';
import 'app/screens/home/notification_screen.dart';
import 'app/services/awesome_notification_service.dart';
import 'app/services/translation_service.dart';
import 'app/themes/theme_color.dart';
import 'app/translations/translation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  await FcmService.initFcm();
  await AwesomeNotificationService.init();
  Get.put(PlaceFavController(), permanent: true);
  Get.put(HotelFavController(), permanent: true);
  Get.put(RestFavController(), permanent: true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final service = Get.put(TranslationService());
  final themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Komsan App',
      debugShowCheckedModeBanner: false,
      locale: TranslationService().currentLanguage == 'km_KH'
          ? const Locale('km', 'KH')
          : const Locale('en', 'US'),
      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
      themeMode: ThemeMode.system,
      fallbackLocale: const Locale('en', 'US'),
      translations: AppTranslation(),
      routes: {
        '/': (context) => const SplashScreen(),
        NotificationScreen.routeName: (context) => NotificationScreen(),
        RootScreen.routeName: (context) => const RootScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        HomeScreen.routeName: (context) => const HomeScreen(),
      },
    );
  }
}
