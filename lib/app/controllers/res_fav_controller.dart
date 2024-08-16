import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import '../constants/global_variable.dart';
import '../models/restaurant_fav_model.dart';

class RestFavController extends GetxController {
  var isLoading = false.obs;
  var isFavorite = false.obs;
  final Dio _dio = Dio();
  final storage = GetStorage();
  var favRes = <ResFavModel>[].obs;

  void fetchFavoriteStatus(int resId) async {
    isLoading(true);
    try {
      var token = storage.read('access_token');
      var response = await _dio.get(
        '$baseApiUrl/restaurants/get-favorite-status',
        queryParameters: {'res_id': resId},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.data['data'].isNotEmpty) {
        var isResFavorite = response.data['data'].any((favorite) =>
        favorite['res_id'] == resId && favorite['status'] == true);
        isFavorite(isResFavorite);
      } else {
        isFavorite(false);
      }
    } catch (e) {
      print('Error fetching favorite status: $e');
    } finally {
      isLoading(false);
    }
  }

  void toggleFavorite(int resId) async {
    isLoading(true);
    try {
      var token = storage.read('access_token');
      var response = await _dio.post(
        '$baseApiUrl/restaurants/add-favorite',
        data: {'res_id': resId},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      isFavorite(response.data['data']['is_favorite']);
    } catch (e) {
      print('Error toggling favorite: $e');
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchResFav();
  }

  void fetchResFav() async {
    isLoading.value = true;
    try {
      var token = storage.read('access_token');
      final response = await _dio.get(
        '$baseApiUrl/restaurants/get-favorite',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        var data = response.data['data'] as List;
        favRes.value = data.map((json) => ResFavModel.fromJson(json)).toList();
        print(favRes);
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching restaurants: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
