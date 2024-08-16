import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../constants/global_variable.dart';
import '../models/place_model.dart';
import '../models/category_place_model.dart';
import '../services/location_service.dart';

class SearchPlaceController extends GetxController {
  var places = <PlaceModel>[].obs;
  var nearbyPlaces = <PlaceModel>[].obs;
  var isLoading = false.obs;
  var text = ''.obs;

  final Dio _dio = Dio();

  Future<void> fetchPlaces(List<CategoryPlaceModel> catePlaces) async {
    isLoading.value = true;
    List<String> categories = [];
    for (var element in catePlaces) {
      if (element.isSelected) {
        categories.add(element.catPlaceName);
      }
    }
    var param = {
      'name': text.value,
      'categories': jsonEncode(categories),
    };
    try {
      final response = await _dio.post('$baseApiUrl/places/search', data: param);
      if (response.statusCode == 200) {
        var data = response.data['data'] as List;
        places.value = data.map((json) {
          return PlaceModel.fromJson(json);
        }).toList();
      } else {
        print('Failed to load places');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

class CategoryPlaceController extends GetxController {
  var catePlaces = <CategoryPlaceModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCatePlaces();
  }

  final Dio _dio = Dio();

  Future<void> fetchCatePlaces() async {
    isLoading.value = true;
    try {
      final response = await _dio.get('$baseApiUrl/alltypes');
      if (response.statusCode == 200) {
        var data = response.data['data'] as List;
        catePlaces.value = data.map((json) {
          return CategoryPlaceModel.fromJson(json);
        }).toList();
      } else {
        print('Failed to load places');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

}
