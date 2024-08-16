import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../screens/auth/reset_pasword_screen.dart';
import '../screens/auth/verify_forget_code_screen.dart';
import '/root_screen.dart';
import '../services/auth_service.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/verify_code_screen.dart';

class AuthController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  File? profileImage;
  final imagePicker = ImagePicker();
  final _authService = AuthService();
  final box = GetStorage();
  final isLoading = false.obs;
  final isHiddenPassword = true.obs;

  final _firebaseAuth = FirebaseAuth.instance;
  String? _verificationId;

  String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.startsWith('0')) {
      phoneNumber = phoneNumber.substring(1);
    }
    return '+855$phoneNumber';
  }

  void togglePasswordVisibility() {
    isHiddenPassword.value = !isHiddenPassword.value;
  }

  Future<void> selectProfileImage() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      update();
    }
  }

  Future<void> checkPhone() async {
    String phone = formatPhoneNumber(phoneController.text);
    try {
      final response = await _authService.checkPhone(phone: phone);
      if (response.data['status'] == 'exists') {
        print(response.data['message']);
        Get.snackbar('Error', 'Phone number already registered');
      } else {
        signup(
          name: nameController.text,
          phone: phone.trim(),
          password: passwordController.text.trim(),
        );
      }
    } catch (e) {
      print(e.toString());
      QuickAlert.show(
        context: Get.context!,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: e.toString(),
      );
    }
  }

  Future<void> signup({
    required String name,
    required String phone,
    required String password,
  }) async {
    isLoading.value = true;
    try {
      await _authService.signup(
        name: name,
        phone: phone,
        password: password,
        profileImg: profileImage,
      );
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: formatPhoneNumber(phoneController.text),
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          print('Error: ${e.message}');
          QuickAlert.show(
            context: Get.context!,
            type: QuickAlertType.error,
            title: 'Oops...',
            text: e.message!,
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          Get.to(() => const VerifyCode());
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          QuickAlert.show(
            context: Get.context!,
            type: QuickAlertType.error,
            title: 'Oops...',
            text: 'Timeout: $verificationId',
          );
        },
      );
    } catch (e) {
      print('Error: $e');
      QuickAlert.show(
        context: Get.context!,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOTP(String smsCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);

      var response = await _authService.verify(
        phone: formatPhoneNumber(phoneController.text),
        verification_code: smsCode,
      );

      if (response.success == true) {
        box.write('access_token', response.accessToken);
        Get.offAll(() => const RootScreen());
      } else {
        QuickAlert.show(
          context: Get.context!,
          type: QuickAlertType.error,
          title: 'Oops...',
          text: response.message!,
        );
      }
    } catch (e) {
      print('Error: $e');
      QuickAlert.show(
        context: Get.context!,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: e.toString(),
      );
    }
  }

  Future<void> login({
    required String phone,
    required String password,
  }) async {
    isLoading.value = true;
    try {
      final response = await _authService.login(
        phone: formatPhoneNumber(phone),
        password: password,
      );
      if (response.success == true) {
        box.write('access_token', response.accessToken);
        Get.offAll(() => const RootScreen());
      } else {
        QuickAlert.show(
          context: Get.context!,
          type: QuickAlertType.error,
          title: 'Oops...',
          text: response.message!,
        );
      }
    } catch (e) {
      print('Error: $e');
      QuickAlert.show(
        context: Get.context!,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> forgetPassword() async {
    isLoading.value = true;
    try {
      var response = await _authService.post('/forgot-password', {
        'phone': formatPhoneNumber(phoneController.text),
      });
      if (response.statusCode == 200) {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: formatPhoneNumber(phoneController.text),
          timeout: const Duration(seconds: 60),
          verificationCompleted: (PhoneAuthCredential credential) {
            // _firebaseAuth.signInWithCredential(credential);
          },
          verificationFailed: (FirebaseAuthException e) {
            print('Error: ${e.message}');
            QuickAlert.show(
              context: Get.context!,
              type: QuickAlertType.error,
              title: 'Oops...',
              text: e.message!,
            );
          },
          codeSent: (String verificationId, int? resendToken) {
            _verificationId = verificationId;
            Get.to(() => VerifyCodeForgetPassword());
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            QuickAlert.show(
              context: Get.context!,
              type: QuickAlertType.error,
              title: 'Oops...',
              text: 'Timeout: $verificationId',
            );
          },
        );
      } else {
        QuickAlert.show(
          context: Get.context!,
          type: QuickAlertType.error,
          title: 'Oops...',
          text: response.data['message'],
        );
      }
    } catch (e) {
      print(e);
      QuickAlert.show(
        context: Get.context!,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyForgetPassword({required String smsCode}) async {
    isLoading.value = true;
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);

      var response = await _authService.post('/verify-reset-password', {
        'phone': formatPhoneNumber(phoneController.text),
        'verification_code': smsCode,
      });

      if (response.statusCode == 200) {
        Get.to(() => ResetPasswordScreen());
      } else {
        QuickAlert.show(
          context: Get.context!,
          type: QuickAlertType.error,
          title: 'Oops...',
          text: response.data['message'],
        );
      }
    } catch (e) {
      print(e);
      QuickAlert.show(
        context: Get.context!,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword({
    required String phone,
    required String password,
  }) async {
    isLoading.value = true;
    try {
      var response = await _authService.post('/reset-password', {
        'phone': formatPhoneNumber(phone),
        'password': password,
      });

      if (response.statusCode == 200) {
        Get.offAll(() => LoginScreen());
      } else {
        QuickAlert.show(
          context: Get.context!,
          type: QuickAlertType.error,
          title: 'Oops...',
          text: response.data['message'],
        );
      }
    } catch (e) {
      print(e);
      QuickAlert.show(
        context: Get.context!,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
