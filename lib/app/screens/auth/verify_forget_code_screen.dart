import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../widgets/subtitle_widget.dart';
import '../../controllers/auth_controller.dart';

class VerifyCodeForgetPassword extends StatelessWidget {
  VerifyCodeForgetPassword({super.key});

  final AuthController authController = Get.put(AuthController());
  String smsCode = "";

  // StreamController<ErrorAnimationType> errorController =
  // StreamController<ErrorAnimationType>();
  // int resendOTPCounter = 60;

  @override
  Widget build(BuildContext context) {
    return authController.isLoading.value
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              title: const SubtitleWidget(label: 'Verify Code', fontSize: 16),
              backgroundColor: Colors.transparent,
            ),
            body: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                const SizedBox(height: 20),
                const SubtitleWidget(
                  label: 'Enter the code sent to your phone number',
                  fontSize: 12,
                ),
                const SizedBox(
                  height: 30,
                ),
                PinCodeTextField(
                  length: 6,
                  appContext: context,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(
                      RegExp(r'\D'),
                    ),
                  ],
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'GeneralFont',
                    color: Colors.white,
                  ),
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(10),
                    fieldHeight: 50,
                    fieldWidth: 50,
                    inactiveFillColor: Colors.white,
                    inactiveColor: Colors.grey,
                    activeFillColor: Colors.blueAccent,
                    selectedColor: Colors.blueAccent,
                    selectedFillColor: Colors.white,
                    activeColor: Colors.blueAccent,
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  backgroundColor: Colors.transparent,
                  enableActiveFill: true,
                  // errorAnimationController: errorController,
                  onChanged: (value) {
                    smsCode = value;
                  },
                  onCompleted: (smsCode) {
                    authController.verifyForgetPassword(smsCode: smsCode);
                  },
                  beforeTextPaste: (text) {
                    return true;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                // InkWell(
                //   onTap: () {
                //     resendOTPCounter = 60;
                //     Timer.periodic(const Duration(seconds: 1), (timer) {
                //       if (resendOTPCounter == 0) {
                //         timer.cancel();
                //       } else {
                //         resendOTPCounter--;
                //       }
                //     });
                //   },
                //   child: Row(
                //     children: [
                //       Container(
                //         padding: const EdgeInsets.symmetric(
                //             horizontal: 20, vertical: 10),
                //         decoration: BoxDecoration(
                //           color: Theme.of(context).colorScheme.secondary,
                //           borderRadius: BorderRadius.circular(50),
                //         ),
                //         child: SubtitleWidget(
                //           label:
                //           'I haven\'t received the code (0:$resendOTPCounter)',
                //           fontSize: 12,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: () {
                    authController.verifyForgetPassword(smsCode: smsCode);
                  },
                  child: Obx(
                    () => authController.isLoading.value
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const SubtitleWidget(
                            label: 'Verify',
                            fontSize: 16,
                          ),
                  ),
                ),
              ],
            ),
          );
  }
}
