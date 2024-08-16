
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:ui_komsan/app/models/hotel_category_model.dart';

import '../constants/global_variable.dart';

class HotelCatController extends GetxController{
  var isLoading = false.obs;
  var hotelCategory = <HotelCatModel>[].obs;
  final Dio _dio = Dio();

  @override
  void onInit(){
    super.onInit();
    fetchCategory();
  }

  Future<void> fetchCategory() async {
    isLoading.value = true;
    try {
      final response = await _dio.get('$baseApiUrl/hotel/category');
      if (response.statusCode == 200) {
        var data = response.data['data'] as List;
        hotelCategory.value = data.map((json) => HotelCatModel.fromJson(json)).toList();
      } else {
        print('Failed to load provinces');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

}