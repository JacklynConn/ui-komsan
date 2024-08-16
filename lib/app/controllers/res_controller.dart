import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '/app/controllers/location_controller.dart';
import '/app/constants/global_variable.dart';
import '../models/restaurant_model.dart';

class RestaurantController extends GetxController {
  final LocationController locationController = Get.put(LocationController());
  var restaurants = <RestaurantModel>[].obs;
  var filteredRes = <RestaurantModel>[].obs;
  var popularRes = <RestaurantModel>[].obs;
  var nearbyRes = <RestaurantModel>[].obs;
  var distance = ''.obs;
  var isLoading = true.obs;
  var searchQuery = ''.obs;
  var selectedProvince = ''.obs;
  var selectedFood = ''.obs;
  var showGrid = false.obs;
  final Dio _dio = Dio();
  final box = GetStorage();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchRestaurant();
    fetchPopularRes();
    fetchNearbyRes();
  }

  void changeView() {
    showGrid.value = !showGrid.value;
  }

  void filterRes() {
    if (searchQuery.value.isEmpty &&
        selectedProvince.value.isEmpty &&
        selectedFood.value.isEmpty) {
      filteredRes.value = restaurants;
    } else {
      filteredRes.value = restaurants.where((restaurant) {
        final matchesQuery = restaurant.resName!
            .toLowerCase()
            .contains(searchQuery.value.toLowerCase());
        final matchesFood = selectedFood.value.isEmpty ||
            restaurant.foods!
                .any((type) => type.foodName == selectedFood.value);
        final resProvince = restaurant.village?.province?.provinceNameen;
        final matchesProvince = resProvince == selectedProvince.value ||
            selectedProvince.value.isEmpty;
        return matchesQuery && matchesFood && matchesProvince;
      }).toList();
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    filterRes();
  }

  void updateSelectedFood(String type) {
    selectedFood.value = type;
    filterRes();
  }

  void updateSelectedProvince(String province) {
    selectedProvince.value = province;
    filterRes();
  }

  void clearProvinceSelection() {
    selectedProvince.value = '';
    filterRes();
  }

  Future<void> fetchRestaurant() async {
    isLoading.value = true;
    try {
      final response = await _dio.get('$baseApiUrl/get-all-res');
      if (response.statusCode == 200) {
        var data = response.data['data'] as List;
        var resList =
        data.map((json) => RestaurantModel.fromJson(json)).toList();
        resList.sort((a, b) => b.averageRating!.compareTo(a.averageRating!));
        restaurants.value = resList;
        filterRes();
      }
      isLoading.value = false;
    } catch (e) {
      throw("Failed to load Restaurant $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchPopularRes() async {
    isLoading.value = true;
    try {
      final response = await _dio.get('$baseApiUrl/restaurant/popular');
      if (response.statusCode == 200) {
        var popRes = response.data['data'] as List;
        popularRes.value =
            popRes.map((json) => RestaurantModel.fromJson(json))
                .take(20)
                .toList();
        popularRes.refresh();
      }
      isLoading.value = false;
    } catch (e) {
      throw("Failed to load popular Restaurant $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchNearbyRes() async {
    isLoading.value = true;
    try {
      for (var res in restaurants) {
        var lat = double.tryParse(res.latitude ?? '') ?? 0;
        var long = double.tryParse(res.longitude ?? '') ?? 0;
        var distance = Geolocator.distanceBetween(
          locationController.currentPosition.value.latitude,
          locationController.currentPosition.value.longitude,
          lat,
          long,
        );
        res.distance = distance / 1000;
        if (res.distance! < 10) {
          nearbyRes.add(res);
        }
      }

      if (nearbyRes.isNotEmpty) {
        nearbyRes.sort((a, b) => a.distance!.compareTo(b.distance!));
      }

      var sortedRes = List<RestaurantModel>.from(restaurants)
        ..sort((a, b) => a.distance!.compareTo(b.distance!));

      nearbyRes.value = sortedRes.where((res) => res.distance! < 10).toList();
      nearbyRes.refresh();
    } catch (e) {
      throw Exception('Failed to load nearby restaurants: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchDistance(
    double currentLat,
    double currentLong,
    double destLat,
    double destLong,
  ) async {
    try {
      final response = await _dio.get(
        'https://maps.googleapis.com/maps/api/directions/json?origin=$currentLat,$currentLong&destination=$destLat,$destLong&key=$googleMapApi',
      );
      if (response.statusCode == 200) {
        distance.value =
            response.data['routes'][0]['legs'][0]['distance']['text'] as String;
        distance.refresh();
      }
    } catch (e) {
      throw('Failed to load distance: $e');
    }
  }
}
