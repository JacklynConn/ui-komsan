import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/app/screens/auth/signup_screen.dart';
import '../screens/auth/verify_code_screen.dart';

class PhoneRegisterWidget extends StatelessWidget {
  const PhoneRegisterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Get.to(
                    () => SignUpScreen(),
                    transition: Transition.rightToLeft,
                  );
                },
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      hintText: 'Enter your phone number',
                      helperStyle: const TextStyle(
                        fontSize: 13,
                        fontFamily: 'GeneralFont',
                      ),
                      prefixIcon: const Icon(Icons.phone),
                      prefix: const Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Text(
                          '+855 | ',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'GeneralFont',
                          ),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Get.to(
                              () => const VerifyCode(),
                              transition: Transition.rightToLeft,
                            );
                          },
                          child: const Text(
                            'Send Code',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
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
    );
  }
}
