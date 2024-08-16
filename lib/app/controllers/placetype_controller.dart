import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../constants/global_variable.dart';
import '../models/place_type_model.dart';

class PlaceTypesController {
  var placeTypes = <PlaceTypesModel>[].obs;
  var isLoading = true.obs;
  final Dio _dio = Dio();

  void onInit() {
    fetchPlaceTypes();
  }
  Future<void> fetchPlaceTypes() async {
    isLoading.value = true;
    try {
      final response = await _dio.get('$baseApiUrl/alltypes');
      if (response.statusCode == 200) {
        var data = response.data['data'] as List;
        placeTypes.value = data.map((json) => PlaceTypesModel.fromJson(json)).toList();
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
