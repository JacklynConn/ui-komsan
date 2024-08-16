import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../constants/global_variable.dart';
import '../models/hotel_fav_model.dart';

class HotelFavController extends GetxController {
  var isLoading = false.obs;
  var isFavorite = false.obs;
  final Dio _dio = Dio();
  final storage = GetStorage();
  var favHotel = <HotelFavModel>[].obs;

  void fetchFavoriteStatus(int hotelId) async {

    isLoading(true);
    try {
      var token = storage.read('access_token');
      var response = await _dio.get(
        '$baseApiUrl/hotels/get-favorite-status',
        queryParameters: {'hotel_id': hotelId},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.data['data'].isNotEmpty) {
        var isHotelFavorite = response.data['data'].any((favorite) =>
            favorite['hotel_id'] == hotelId && favorite['status'] == true);
        isFavorite(isHotelFavorite);
      } else {
        isFavorite(false);
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }

  void toggleFavorite(int hotelId) async {
    isLoading(true);
    try {
      var token = storage.read('access_token');
      var response = await _dio.post(
        '$baseApiUrl/hotels/add-favorite',
        data: {'hotel_id': hotelId},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      isFavorite(response.data['data']['is_favorite']);
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchHotelFav();
  }

  void fetchHotelFav() async {
    isLoading.value = true;
    try {
      var token = storage.read('access_token');
      final response = await _dio.get(
        '$baseApiUrl/hotels/get-favorite',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        var data = response.data['data'] as List;
        favHotel.value =
            data.map((json) => HotelFavModel.fromJson(json)).toList();
        print(favHotel);
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching hotels: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
