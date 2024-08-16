import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui_komsan/app/controllers/app_version_controller.dart';
import 'package:ui_komsan/app/controllers/authentication_controller.dart';
import 'package:ui_komsan/app/screens/auth/authentication_screen.dart';
import 'package:ui_komsan/app/screens/profile/about_us.dart';
import '../../constants/global_variable.dart';
import '../../widgets/global/app_elevated_btn.dart';
import '/app/screens/profile/favorite_screen.dart';
import '../../controllers/profile_controller.dart';
import '../../widgets/subtitle_widget.dart';
import '../../widgets/title_text_widget.dart';
import '../../controllers/theme_controller.dart';
import 'language_screen.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/ProfileScreen';

  ProfileScreen({super.key});

  final themeController =
  Get.find<ThemeController>(); // modify #IT-131 Mak Mach 2024-05-19
  final _profileController = Get.put(ProfileController());
  final _checkToken = Get.put(AuthenticationController());
  final AppVersionController _appVersionController =
  Get.put(AppVersionController());

  @override
  Widget build(BuildContext context) {
    if (_checkToken.hasToken()) {
      _profileController.getProfile();
      return Scaffold(
        appBar: AppBar(
          title: TitleTextWidget(
            label: 'Profile'.tr,
            color: Colors.blueAccent,
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: GetBuilder<ProfileController>(builder: (_) {
            return Column(
              children: [
                _profileController.profile?.user?.profileImg == null
                    ? CircleAvatar(
                  radius: 45,
                  // backgroundColor: Colors.grey,
                  child: _profileController.profile?.user?.name == null
                      ? const Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.blueAccent,
                  )
                      : Text(
                    _profileController.profile?.user?.name![0]
                        .toUpperCase() ??
                        "",
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                )
                    : CircleAvatar(
                  radius: 45,
                  // backgroundColor: Colors.grey,
                  backgroundImage: CachedNetworkImageProvider(
                    "$baseProfileUrl${_profileController.profile?.user?.profileImg ?? ''}",
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                SubtitleWidget(
                  label:
                  _profileController.profile?.user?.name ?? 'Username'.tr,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 8, right: 8),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.background,
                          offset: const Offset(2, 2),
                          spreadRadius: 0.8,
                          blurRadius: 3.0,
                        ),
                      ]),
                  child: Column(
                    children: [
                      ListTile(
                        title: TitleTextWidget(
                          label: 'Favorite'.tr,
                          fontSize: 16,
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Get.to(
                                () => FavoriteScreen(),
                            transition: Transition.rightToLeft,
                          );
                        },
                      ),
                      Container(
                        width: double.infinity,
                        height: 4,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      ListTile(
                        title: TitleTextWidget(
                          label: 'Language'.tr,
                          fontSize: 16,
                        ),
                        subtitle: SubtitleWidget(
                          label: Get.locale?.languageCode == 'en'
                              ? 'English'
                              : Get.locale?.languageCode == 'km'
                              ? 'ខ្មែរ'
                              : 'English',
                          fontSize: 14,
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Get.to(
                                () => const LanguageScreen(),
                            transition: Transition.rightToLeft,
                          );
                        },
                      ),
                      Container(
                        width: double.infinity,
                        height: 4,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      // modify #IT-131 Mak Mach 2024-05-19
                      Obx(
                            () => ListTile(
                          title: Text(
                            'Dark Mode'.tr,
                            style: const TextStyle(
                              // add IT-129-Pithak-2024-05-21
                              fontSize: 16,
                              fontFamily: 'GeneralFont',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            themeController.isDarkMode.value
                                ? 'Dark'.tr
                                : 'Light'.tr,
                            style: const TextStyle(
                                color: Colors.grey, fontFamily: 'GeneralFont'),
                          ),
                          trailing: Switch(
                            value: themeController.isDarkMode.value,
                            activeColor: Colors.blueAccent,
                            onChanged: (value) {
                              themeController.toggleTheme();
                            },
                          ),
                        ),
                      ),
                      // modify #IT-131 Mak Mach 2024-05-19
                      Container(
                        width: double.infinity,
                        height: 4,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      ListTile(
                        title: TitleTextWidget(
                          label: 'About Us'.tr,
                          fontSize: 16,
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Get.to(
                                () => const AboutUs(),
                            transition: Transition.rightToLeft,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                // app version
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SubtitleWidget(
                      label: 'App Version'.tr,
                      fontSize: 12,
                    ),
                    const SubtitleWidget(
                      label: ' : ',
                      fontSize: 12,
                    ),
                    const SubtitleWidget(
                      label: currentVersion ?? '',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.blueAccent,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding:
                        const EdgeInsets.only(top: 40, left: 40, right: 40),
                        child: AppElevatedBtn(
                          onPressed: () {
                            if (_profileController.box.read('access_token') ==
                                null) {
                              Get.to(
                                    () => Authentication(),
                                transition: Transition.rightToLeft,
                              );
                            } else {
                              // Show confirmation dialog before logging out
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: TitleTextWidget(
                                      label: 'Logout'.tr,
                                      fontSize: 20,
                                      color: Colors.redAccent,
                                    ),
                                    content: SubtitleWidget(
                                      label: 'Are you sure you want to log out?'.tr,
                                      fontSize: 16,
                                    ),
                                    backgroundColor: themeController.isDarkMode.value
                                        ? Colors.grey[800]
                                        : Colors.grey[200],
                                    actions: <Widget>[
                                      TextButton(
                                        child: SubtitleWidget(
                                          label: 'No'.tr,
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          Get.back(); // Close the dialog
                                        },
                                      ),
                                      TextButton(
                                        child: SubtitleWidget(
                                          label: 'Yes'.tr,
                                          fontSize: 14,
                                          color: Colors.redAccent,
                                        ),
                                        onPressed: () {
                                          Get.back(); // Close the dialog
                                          _profileController.logout(); // Log the user out
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          backgroundColor:
                          _profileController.box.read('access_token') ==
                              null
                              ? Colors.blue
                              : Colors.redAccent,
                          child: _profileController.box.read('access_token') ==
                              null
                              ? TitleTextWidget(
                            label: 'Login'.tr,
                            color: Colors.white,
                            fontSize: 16,
                          )
                              : TitleTextWidget(
                            label: 'Logout'.tr,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            );
          }),
        ),
      );
    } else {
      return SizedBox(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.background,
                        offset: const Offset(2, 2),
                        spreadRadius: 0.5,
                        blurRadius: 2.0,
                      ),
                    ]),
                child: ClipRRect(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    "assets/images/favorite.gif",
                    width: 140,
                    height: 140,
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const SizedBox(
                width: 300,
                child: SubtitleWidget(
                  label: "Please login to use other feature",
                  fontSize: 14,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary),
                onPressed: () {
                  Get.to(() => Authentication(),
                      transition: Transition.rightToLeft);
                },
                child: const SubtitleWidget(
                  label: 'Login',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
