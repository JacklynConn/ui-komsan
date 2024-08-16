import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

import '../constants/global_variable.dart';
import '../models/hotel_rating_model.dart';

class HotelRatingController extends GetxController {
  var hotelRatingModel = HotelRatingModel().obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  final storage = GetStorage();

  final Dio _dio = Dio(); // Create Dio instance

  Future<void> fetchUserRating(int hotelId) async {
    try {
      isLoading(true);
      errorMessage('');
      var token = storage.read('access_token');
      var response = await _dio.get(
        '$baseApiUrl/hotel/get-user-rating/$hotelId',
        queryParameters: {'hotel_id': hotelId},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        hotelRatingModel.value = HotelRatingModel.fromJson(response.data['userRating']);
      } else {
        errorMessage('Failed to load rating: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage('Error occurred: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> userRating (int hotelId, double rating) async {
    try {
      var token = storage.read('access_token');
      final response = await _dio.post('$baseApiUrl/hotel/rating',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
          data: {
            'hotel_id': hotelId,
            'rating': rating,
          });
      if (response.statusCode == 200) {
        fetchUserRating(hotelId);
      }
    } catch (e) {
      print(e);
    }
  }
}

