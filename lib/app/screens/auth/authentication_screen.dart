import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui_komsan/root_screen.dart';
import '../../controllers/authentication_controller.dart';
import 'login_screen.dart';

class Authentication extends StatelessWidget {
  Authentication({super.key});

  final _controller = Get.put(AuthenticationController());

  @override
  Widget build(BuildContext context) {
    return _controller.hasToken() ? const RootScreen() : LoginScreen();
  }
}
