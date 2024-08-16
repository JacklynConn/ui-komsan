import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/app/controllers/auth_controller.dart';
import '/app/screens/auth/login_screen.dart';
import '../../widgets/subtitle_widget.dart';
import '../../widgets/title_text_widget.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final AuthController _authController = Get.put(AuthController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Obx(
      () => _authController.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : Scaffold(
              body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: SafeArea(
                  child: Scaffold(
                    body: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: SizedBox(
                          height: size.height,
                          width: size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Spacer(),
                              Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Stack(
                                      children: [
                                        GetBuilder<AuthController>(builder:
                                            (AuthController controller) {
                                          return controller.profileImage == null
                                              ? const CircleAvatar(
                                                  radius: 80,
                                                  backgroundImage: AssetImage(
                                                    'assets/images/profile_img.png',
                                                  ),
                                                  backgroundColor:
                                                      Colors.transparent,
                                                )
                                              : CircleAvatar(
                                                  radius: 80,
                                                  backgroundImage: FileImage(
                                                    controller.profileImage!,
                                                  ),
                                                );
                                        }),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () {
                                              _authController
                                                  .selectProfileImage();
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.all(5.0),
                                              child: CircleAvatar(
                                                radius: 25,
                                                backgroundColor:
                                                    Colors.blueAccent,
                                                child: Icon(
                                                  CupertinoIcons.camera_fill,
                                                  size: 28,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 30),
                                    TextFormField(
                                      cursorColor: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary,
                                      controller:
                                          _authController.nameController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your name';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Username',
                                        prefixIcon: const Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Icon(
                                            Icons.person,
                                            size: 20,
                                          ),
                                        ),
                                        labelStyle: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'GeneralFont',
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inversePrimary,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.blueAccent),
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                          _authController.phoneController,
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
                                          padding:
                                              const EdgeInsets.only(right: 10),
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
                                          child: Icon(
                                            Icons.phone,
                                            size: 20,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.blueAccent),
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your password';
                                        } else if (value.length <= 7) {
                                          return 'Password must be at least 8 characters long';
                                        }
                                        return null;
                                      },
                                      obscureText: _authController
                                          .isHiddenPassword.value,
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
                                          child: Icon(
                                            Icons.lock,
                                            size: 20,
                                          ),
                                        ),
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            _authController
                                                .togglePasswordVisibility();
                                          },
                                          icon: Icon(
                                            _authController
                                                    .isHiddenPassword.value
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .inversePrimary,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.blueAccent),
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                              backgroundColor:
                                                  Colors.blueAccent,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 10,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            onPressed: () async {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                await _authController
                                                    .checkPhone();
                                              }
                                            },
                                            child: const TitleTextWidget(
                                              label: 'Next',
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const SubtitleWidget(
                                          label: 'Already have an account?',
                                          fontSize: 14,
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Get.offAll(
                                              () => LoginScreen(),
                                              transition: Transition
                                                  .leftToRightWithFade,
                                            );
                                          },
                                          child: const SubtitleWidget(
                                            label: 'Login',
                                            color: Colors.blueAccent,
                                            fontSize: 14,
                                          ),
                                        ),
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
                              SizedBox(height: size.height * 0.05),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
