import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/subtitle_widget.dart';
import '../widgets/title_text_widget.dart';
import '../screens/auth/login_screen.dart';

void alertMessage(BuildContext context) { // modify #IT-193 Mach 2024-06-12
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const TitleTextWidget(
          label: "Login Required",
          fontSize: 20,
        ),
        content: const SubtitleWidget(
          label: "You need to log in to use this function.",
          fontSize: 14,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          TextButton(
            child: SubtitleWidget(
              label: "Cancel",
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const SubtitleWidget(
              label: "Login",
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              Get.to(() => LoginScreen(), transition: Transition.rightToLeft); // modify #IT-193 Mach 2024-06-12
            },
          ),
        ],
      );
    },
  );
}
