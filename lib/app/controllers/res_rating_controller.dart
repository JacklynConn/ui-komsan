import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

import '../constants/global_variable.dart';
import '../models/restaurant_rating_model.dart';

class RestRatingController extends GetxController {
  var resRatingModel = ResRatingModel().obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  final storage = GetStorage();

  final Dio _dio = Dio(); // Create Dio instance

  Future<void> fetchUserRating(int resId) async {
    try {
      isLoading(true);
      errorMessage('');
      var token = storage.read('access_token');
      var response = await _dio.get(
        '$baseApiUrl/restaurant/get-user-rating/$resId',
        queryParameters: {'res_id': resId},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        resRatingModel.value = ResRatingModel.fromJson(response.data['userRating']);
      } else {
        errorMessage('Failed to load rating: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage('Error occurred: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> userRating (int resId, double rating) async {
    try {
      var token = storage.read('access_token');
      final response = await _dio.post('$baseApiUrl/restaurant/rating',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
          data: {
            'res_id': resId,
            'rating': rating,
          });
      if (response.statusCode == 200) {
        fetchUserRating(resId);
      }
    } catch (e) {
      print(e);
    }
  }
}
