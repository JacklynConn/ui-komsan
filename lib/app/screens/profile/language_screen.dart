import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui_komsan/app/widgets/title_text_widget.dart';
import '../../widgets/subtitle_widget.dart';
import '/app/services/translation_service.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TitleTextWidget(
          label: 'Language'.tr,
          color: Colors.blueAccent,
          fontSize: 20,
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            size: 24,
            color: Colors.blueAccent,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                TranslationService().changeLanguage('en_US');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset(
                    'assets/images/profile/english.png',
                    width: 28,
                    height: 28,
                  ),
                  SubtitleWidget(
                    label: 'English',
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                TranslationService().changeLanguage('km_KH');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset(
                    'assets/images/profile/khmer.png',
                    width: 28,
                    height: 28,
                  ),
                  SubtitleWidget(
                    label: 'ភាសាខ្មែរ',
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
