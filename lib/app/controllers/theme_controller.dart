// modify #IT-131 Mak Mach 2024-05-19
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final _box = GetStorage();
  final String _key = 'isDarkMode';

  var isDarkMode = false.obs;

  ThemeController() {
    isDarkMode.value = _box.read(_key) ?? false;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  ThemeMode get theme => isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    _box.write(_key, isDarkMode.value);
  }
}
// modify #IT-131 Mak Mach 2024-05-19
