import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui_komsan/app/widgets/subtitle_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/global_variable.dart';
import '../models/app_version_model.dart';

class AppVersionController extends GetxController {
  var appVersions = <Version>[].obs;
  var latestVersion = ''.obs;
  Dio dio = Dio();

  @override
  void onInit() {
    super.onInit();
    checkVersion();
  }

  Future<void> checkVersion() async {
    try {
      final response = await dio.get(
        '$baseApiUrl/get-app-version',
        options: Options(
          validateStatus: (status) {
            return status! < 500;
          },
          followRedirects: false,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        latestVersion.value = data['version'];
        if (latestVersion.value != currentVersion) {
          Get.bottomSheet(
            Container(
              width: Get.width,
              height: Get.height * 0.5,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(Get.context!).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/play-store.png',
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        const SubtitleWidget(label: 'Google Play'),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Update Available',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'A new version of the app is available.',
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                        'To use this app, download the latest version. You keep using this app while downloading the update.'),
                    const SizedBox(height: 20),
                    const SubtitleWidget(label: 'What\'s New'),
                    // Row(
                    //   children: [
                    //     Text('Last updated: ${latestVersion.value[0]}'),
                    //     IconButton(
                    //       onPressed: () {},
                    //       icon: const Icon(Icons.arrow_drop_down_sharp),
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            onPressed: () {
                              redirectToPlayStore(); // Replace with your app's package name
                            },
                            child: const Text('Update'),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                            ),
                            onPressed: () => Get.back(),
                            child: const Text('Later'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        }
      }
    } catch (e) {
      print('Failed to check version $e');
    }
  }

  void redirectToPlayStore() async {
    const url = playStoreUrl;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
