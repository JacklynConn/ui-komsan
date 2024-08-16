import 'dart:convert';

import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../models/category_place_model.dart';
import '../models/place_type_model.dart';
import '/app/models/place_model.dart';
import '../constants/global_variable.dart';

class ControllerPlaceInProvince extends GetxController {
  var places = <PlaceModel>[].obs;
  var placeTypes = <PlaceTypesModel>[].obs;
  var nearbyPlaces = <PlaceModel>[].obs;
  var isLoading = true.obs;
  var showGrid = false.obs;
  var provinceId = 0.obs;
  var placeTypeIds = <int>[].obs;
  final Dio _dio = Dio();

  void changeView() {
    showGrid.value = !showGrid.value;
  }

  Future<void> fetchPlace(List<CategoryPlaceModel> catePlaces) async {
    isLoading.value = true;
    List<String> categories = [];
    for (var element in catePlaces) {
      if (element.isSelected) {
        categories.add(element.catPlaceName);
      }
    }
    var param = {
      'province_code': provinceId.toString(),
      'place_type_ids': jsonEncode(placeTypeIds),
      'categories': jsonEncode(categories),
    };
    try {
      final response = await _dio.post(
        '$baseApiUrl/showPlaceInProvince',
        data: param,
      );
      if (response.statusCode == 200) {
        var data = response.data['data'] as List;
        places.value = data.map((json) => PlaceModel.fromJson(json)).toList();
      } else {
        print('Failed to load places');
      }
    } catch (e) {
      print('Error: ${e}');
      places.value = [];
    } finally {
      isLoading.value = false;
    }
  }
}
