import 'dart:ui';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class TranslationService extends GetxService{
  static TranslationService get to => Get.find();
  final _box = GetStorage();
  final _key = 'language';
  final _defaultLanguage = 'km_KH';

  String get currentLanguage => _box.read(_key) ?? _defaultLanguage;

  void changeLanguage(String language) async{
    Get.updateLocale(Locale(language));
    _box.write(_key, language);
  }

  @override
  void onInit() {
    init();
    super.onInit();
  }
  void init() async{
    await GetStorage.init();
    Get.updateLocale(Locale(currentLanguage));
  }
}