import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ui_komsan/splash_screen.dart';

import '../services/auth_service.dart';
import '../models/user_res_model.dart';

class ProfileController extends GetxController {
  final _authService = AuthService();
  final box = GetStorage();
  final isLogin = false.obs;

  UserResModel? profile;

  @override
  void onInit() {
    getProfile();
    super.onInit();
  }

  void getProfile() async {
    try {
      final response = await _authService.me();
      profile = response;
      update();
      print("response: ${response.user!.phone}");
    } catch (e) {
      print(e);
    }
  }

  void logout() async {
    await box.remove('access_token');
    Get.offAll(() => const SplashScreen());
  }
}
