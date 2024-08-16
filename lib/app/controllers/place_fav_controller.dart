import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../constants/global_variable.dart';
import '../models/place_fav_model.dart';

class PlaceFavController extends GetxController {
  var isLoading = false.obs;
  var isFavorite = false.obs;
  final Dio _dio = Dio();
  final storage = GetStorage();
  var favPlace = <PlaceFavModel>[].obs;

  void fetchFavoriteStatus(int placeId) async {
    isLoading(true);
    try {
      var token = storage.read('access_token');
      var response = await _dio.get(
        '$baseApiUrl/places/get-favorite-status',
        queryParameters: {'place_id': placeId},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.data['data'].isNotEmpty) {
        var isPlaceFavorite = response.data['data'].any((favorite) =>
        favorite['place_id'] == placeId && favorite['status'] == true);
        isFavorite(isPlaceFavorite);
      } else {
        isFavorite(false);
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }

  void toggleFavorite(int placeId) async {
    isLoading(true);
    try {
      var token = storage.read('access_token');
      var response = await _dio.post(
        '$baseApiUrl/places/add-favorite',
        data: {'place_id': placeId},
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
    fetchPlaceFav();
  }

  void fetchPlaceFav() async {
    isLoading.value = true;
    try {
      var token = storage.read('access_token');
      final response = await _dio.get(
        '$baseApiUrl/places/get-favorite',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        var data = response.data['data'] as List;
        favPlace.value =
            data.map((json) => PlaceFavModel.fromJson(json)).toList();
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching places: $e');
    } finally {
      isLoading.value = false;
    }
  }

}