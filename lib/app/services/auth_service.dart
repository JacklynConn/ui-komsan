import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import '../models/user_res_model.dart';
import '../constants/global_variable.dart';

class AuthService {
  final box = GetStorage();

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: baseApiUrl,
      followRedirects: false,
      validateStatus: (status) {
        return status! < 500;
      },
      headers: {
        Headers.acceptHeader: 'application/json',
        Headers.contentTypeHeader: 'application/json',
      },
    ),
  );

  Future signup({
    required String name,
    required String phone,
    required String password,
    required File? profileImg,
  }) async {
    final formData = FormData.fromMap({
      'name': name,
      'phone': phone,
      'password': password,
      'profile_img': profileImg != null
          ? await MultipartFile.fromFile(profileImg.path)
          : null,
    });
    try {
      final response = await dio.post(
        '/register',
        data: formData,
      );
      if (response.statusCode == 200) {
        UserResModel user = UserResModel.fromJson(response.data);
        return user;
      } else {
        return response.data['message'];
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<UserResModel> verify({
    required String phone,
    required String verification_code,
  }) async {
    try {
      final response = await dio.post(
        '/verify',
        data: {
          'phone': phone,
          'verification_code': verification_code,
        },
      );
      if (response.statusCode == 200) {
        return UserResModel.fromJson(response.data);
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Response> checkPhone({
    required String phone,
  }) async {
    return await dio.post(
      '/check-phone',
      data: {
        'phone': phone,
      },
    );
  }

  Future<UserResModel> login({
    required String phone,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        '/login',
        data: {
          'phone': phone,
          'password': password,
        },
      );
      if (response.statusCode == 200) {
        UserResModel user = UserResModel.fromJson(response.data);
        return user;
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<UserResModel> me() async {
    try {
      final token = box.read('access_token');
      final response = await dio.get(
        "/me",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );
      if (response.statusCode == 200) {
        return UserResModel.fromJson(response.data);
      } else {
        throw Exception(response.data["message"]);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> logout() async {
    try {
      final response = await dio.get(
        '/logout',
        options: Options(headers: {
          "Authorization": "Bearer ${UserResModel().accessToken}",
        }),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Response> post(String path, Map<String, dynamic> data) async {
    try {
      final response = await dio.post(path, data: data);
      return response;
    } on DioError catch (e) {
      if (e.response != null) {
        return e.response!;
      } else {
        throw Exception('Network error');
      }
    }
  }
}
