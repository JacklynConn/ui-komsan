import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../constants/global_config.dart';
import '../models/slider_model.dart';

class SliderController extends GetxController{
  var sliders = <SliderModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSlider();
  }

  Future<void> fetchSlider() async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/slidersdata'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'] as List;
        sliders.value = data.map((json) {
          return SliderModel.fromJson(json);
        }).toList();

      }
      else {
        isLoading.value = false;
      }
    } catch (e) {
      print('Failed to load sliders $e');
      throw Exception('Failed to load sliders $e');
    } finally {
      isLoading.value = false;
    }
  }
}

