import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui_komsan/app/screens/auth/authentication_screen.dart';
import 'package:ui_komsan/root_screen.dart';
import 'app/widgets/app_name_widget.dart';
import 'app/controllers/root_controller.dart';
import 'app/screens/auth/login_screen.dart';
import 'app/screens/home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAll(
        () => const RootScreen(),
        transition: Transition.rightToLeft,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Colors.transparent,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppNameTextWidget(
              fontSize: 50,
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(
              color: Colors.blueAccent,
            ),
          ],
        ),
      ),
    );
  }
}
