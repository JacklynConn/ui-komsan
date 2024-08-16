
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../constants/global_variable.dart';
import '../models/food_type_model.dart';

class FoodTypeController extends GetxController{
  var isLoading = false.obs;
  var foodType = <FoodTypeModel>[].obs;
  final Dio _dio = Dio();

  @override
  void onInit(){
    super.onInit();
    fetchFoodType();
  }

  Future<void> fetchFoodType() async {
    isLoading.value = true;
    try {
      final response = await _dio.get('$baseApiUrl/get-foodtype');
      if (response.statusCode == 200) {
        var data = response.data['data'] as List;
        foodType.value = data.map((json) => FoodTypeModel.fromJson(json)).toList();
      } else {
        print('Failed to load food types');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

}