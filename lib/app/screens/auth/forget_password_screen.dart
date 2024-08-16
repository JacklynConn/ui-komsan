import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ui_komsan/app/widgets/subtitle_widget.dart';
import '../../controllers/auth_controller.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({super.key});

  final AuthController authController = Get.put(AuthController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Obx(() {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AlertDialog(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    titlePadding: EdgeInsets.zero,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    title: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage('assets/images/forget_phone.gif'),
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 20),
                        SubtitleWidget(
                          label: 'Enter your phone number',
                          fontSize: 16,
                          color: Colors.blueAccent,
                        ),
                      ],
                    ),
                    content: Form(
                      key: _formKey,
                      child: TextFormField(
                        onChanged: (value) =>
                            authController.phoneController.text = value,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(
                            RegExp(r'\D'),
                          ),
                        ],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                        cursorColor: Colors.blueAccent,
                        decoration: InputDecoration(
                          hintText: 'Phone number',
                          isDense: true,
                          hintStyle: const TextStyle(color: Colors.grey),
                          prefixIcon: const Icon(Icons.phone),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.blueAccent,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: const SubtitleWidget(
                          label: 'Cancel',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                      TextButton(
                        child: authController.isLoading.value
                            ? const CircularProgressIndicator(
                                color: Colors.blueAccent,
                              )
                            : const SubtitleWidget(
                                label: 'Send',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            authController.forgetPassword();
                          }
                        },
                      ),
                    ],
                  ),
                ],
              );
            });
          },
        );
      },
      child: const SubtitleWidget(
        label: 'Forgot Password?',
        fontSize: 14,
        color: Colors.blueAccent,
      ),
    );
  }
}
