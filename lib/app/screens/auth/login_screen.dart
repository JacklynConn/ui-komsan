import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ui_komsan/root_screen.dart';
import '/app/controllers/auth_controller.dart';
import '/app/screens/auth/signup_screen.dart';
import '../../widgets/app_name_widget.dart';
import '../../widgets/subtitle_widget.dart';
import '../../widgets/title_text_widget.dart';
import 'forget_password_screen.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/LoginScreen';

  LoginScreen({super.key});

  final AuthController _authController = Get.put(AuthController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Obx(
      () => _authController.isLoading.value
          ? Container(
              width: double.infinity,
              height: double.infinity,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: const Center(
                  child: CircularProgressIndicator(
                color: Colors.blueAccent,
              )),
            )
          : GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Scaffold(
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: SizedBox(
                      height: height,
                      width: width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 40,
                                          width: 80,
                                          decoration: const BoxDecoration(
                                            color: Colors.blueAccent,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(30),
                                              bottomLeft: Radius.circular(30),
                                            ),
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              Get.offAll(()=>const RootScreen(),
                                                transition: Transition.leftToRight
                                              );
                                            },
                                            child: const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SubtitleWidget(
                                                  label: 'Skip',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(
                                                  width: 2.0,
                                                ),
                                                Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Colors.white,
                                                  size: 14,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 40),
                                const AppNameTextWidget(fontSize: 60),
                                const SizedBox(height: 40),
                                const TitleTextWidget(
                                  label: 'Please login to continue...',
                                  fontSize: 16,
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  cursorColor: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                  controller: _authController.phoneController,
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(
                                      RegExp(r'\D'),
                                    ),
                                  ],
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Phone number is required';
                                    } else if (value.length <= 7) {
                                      return 'Phone must be at least 8 characters long';
                                    } else if (value.length >= 12) {
                                      return 'Phone must be at most 12 characters long';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Phone Number',
                                    labelStyle: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'GeneralFont',
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary,
                                    ),
                                    prefix: Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: SubtitleWidget(
                                        label: '+855',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary,
                                      ),
                                    ),
                                    prefixIcon: const Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Icon(Icons.phone),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.blueAccent),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    isDense: true,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  cursorColor: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                  controller:
                                      _authController.passwordController,
                                  keyboardType: TextInputType.text,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(
                                      RegExp(r'\s'),
                                    ),
                                  ],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    } else if (value.length <= 7) {
                                      return 'Password must be at least 8 characters long';
                                    }
                                    return null;
                                  },
                                  obscureText:
                                      _authController.isHiddenPassword.value,
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    labelStyle: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'GeneralFont',
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary,
                                    ),
                                    prefixIcon: const Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Icon(Icons.lock),
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        _authController
                                            .togglePasswordVisibility();
                                      },
                                      icon: Obx(
                                        () => Icon(
                                          _authController.isHiddenPassword.value
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                        ),
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.blueAccent),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    isDense: true,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blueAccent,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 10,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            final phone = _authController
                                                .phoneController.text;
                                            final password = _authController
                                                .passwordController.text;
                                            _authController.login(
                                              phone: phone,
                                              password: password,
                                            );
                                          }
                                        },
                                        child: const TitleTextWidget(
                                          label: 'Login',
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SubtitleWidget(
                                      label: 'Don\'t have an account?',
                                      fontSize: 14,
                                      // modify #IT-64 Mak Mach 2024-03-30
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Get.offAll(
                                          () => SignUpScreen(),
                                          transition:
                                              Transition.rightToLeftWithFade,
                                        );
                                      },
                                      child: const SubtitleWidget(
                                        label: 'Register',
                                        color: Colors.blueAccent,
                                        fontSize: 14,
                                        // modify #IT-64 Mak Mach 2024-03-30
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ForgetPasswordScreen(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          const SubtitleWidget(
                            label: '© 2024 Komsan. All rights reserved.',
                            fontSize: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
