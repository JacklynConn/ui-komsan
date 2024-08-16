import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../constants/global_variable.dart';
import '../models/province_model.dart';

class ProvinceController extends GetxController {
  var provinces = <ProvinceModel>[].obs;
  var isLoading = true.obs;
  var showGrid = false.obs;
  final Dio _dio = Dio();

  @override
  void onInit() {
    super.onInit();
    fetchProvince();
  }

  void changeView() {
    showGrid.value = !showGrid.value;
  }

  Future<void> fetchProvince() async {
    isLoading.value = true;
    try {
      final response = await _dio.get('$baseApiUrl/provinces');
      if (response.statusCode == 200) {
        var data = response.data['data'] as List;
        provinces.value = data.map((json) => ProvinceModel.fromJson(json)).toList();
      } else {
        //print('Failed to load provinces');
      }
    } catch (e) {
      //print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
