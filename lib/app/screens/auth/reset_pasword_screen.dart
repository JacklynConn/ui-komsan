import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../widgets/subtitle_widget.dart';
import '../../controllers/auth_controller.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => authController.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Scaffold(
                body: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: const AssetImage(
                        'assets/images/background_signup.jpg',
                      ),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.1),
                        BlendMode.darken,
                      ),
                      filterQuality: FilterQuality.high,
                      opacity: 0.2,
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.black.withOpacity(0.7),
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0.5),
                        Colors.black.withOpacity(0.4),
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.2),
                        Colors.black.withOpacity(0.1),
                        Colors.black.withOpacity(0.075),
                        Colors.black.withOpacity(0.05),
                        Colors.black.withOpacity(0.025),
                      ],
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15.0,
                          vertical: 60.0,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    height: 200,
                                    decoration: const BoxDecoration(
                                      color: Colors.blueAccent,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                      image: DecorationImage(
                                        image: AssetImage(
                                          'assets/images/input_password.gif',
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 10,
                                    left: 10,
                                    child: IconButton(
                                      icon: const Icon(Icons.arrow_back_ios),
                                      onPressed: () {
                                        Get.back();
                                      },
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              const SubtitleWidget(
                                label: 'Reset Password',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  children: [
                                    Form(
                                      key: authController.formKey,
                                      child: Obx(() {
                                        return TextFormField(
                                          style: const TextStyle(
                                            color: Colors.blueAccent,
                                          ),
                                          keyboardType: TextInputType.text,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.deny(
                                              RegExp(r'\s'),
                                            ),
                                          ],
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter your new password';
                                            } else if (value.length <= 7) {
                                              return 'Password must be at least 8 characters';
                                            }
                                            return null;
                                          },
                                          obscureText: authController
                                              .isHiddenPassword.value,
                                          controller:
                                              authController.passwordController,
                                          decoration: InputDecoration(
                                            prefixIcon: const Icon(
                                              Icons.lock,
                                              color: Colors.blueAccent,
                                            ),
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                authController
                                                        .isHiddenPassword.value
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                                color: Colors.blueAccent,
                                              ),
                                              onPressed: () {
                                                authController.isHiddenPassword
                                                        .value =
                                                    !authController
                                                        .isHiddenPassword.value;
                                              },
                                            ),
                                            labelText: 'New Password',
                                            labelStyle: const TextStyle(
                                              color: Colors.blueAccent,
                                            ),
                                            hintText: 'Enter your new password',
                                            hintStyle: const TextStyle(
                                              color: Colors.blueAccent,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                color: Colors.blueAccent,
                                              ),
                                            ),
                                            focusColor: Colors.blueAccent,
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                color: Colors.blueAccent,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                color: Colors.blueAccent,
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueAccent,
                                      elevation: 0,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(30),
                                          bottomRight: Radius.circular(30),
                                        ),
                                      ),
                                      shadowColor: Colors.grey.withOpacity(0.5),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 15),
                                    ),
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: const SubtitleWidget(
                                      label: 'Back',
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueAccent,
                                      elevation: 0,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30),
                                          bottomLeft: Radius.circular(30),
                                        ),
                                      ),
                                      shadowColor: Colors.grey.withOpacity(0.5),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 15),
                                    ),
                                    onPressed: () {
                                      if (authController.formKey.currentState!
                                          .validate()) {
                                        authController.resetPassword(
                                          phone: authController
                                              .phoneController.text,
                                          password: authController
                                              .passwordController.text,
                                        );
                                      }
                                    },
                                    child: const SubtitleWidget(
                                      label: 'Reset Password',
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
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
