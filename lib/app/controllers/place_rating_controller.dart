import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';
import 'package:ui_komsan/app/models/place_rating_model.dart';

import '../constants/global_variable.dart';

class PlaceRatingController extends GetxController {
  final placeRatingModel = PlaceRatingModel().obs;
  final isLoading = false.obs;
  var errorMessage = ''.obs;
  final storage = GetStorage();
  final Dio _dio = Dio();

  Future<void> fetchUserRating(int placeId) async {
    try {
      isLoading(true);
      errorMessage('');
      var token = storage.read('access_token');
      var response = await _dio.get(
        '$baseApiUrl/place/get-user-rating/$placeId',
        queryParameters: {'place_id': placeId},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        placeRatingModel.value = PlaceRatingModel.fromJson(response.data['userRating']);
      } else {
        errorMessage('Failed to load rating: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage('Error occurred: $e');
    } finally {
      isLoading(false);
    }
  }

  Future <void> userRating (int placeId, double rating) async {
    try {
      var token = storage.read('access_token');
      final response = await _dio.post('$baseApiUrl/place/rating',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
          data: {
            'place_id': placeId,
            'rating': rating,
          });
      if (response.statusCode == 200) {
        fetchUserRating(placeId);
      }
    } catch (e) {
      print(e);
    }
  }
}