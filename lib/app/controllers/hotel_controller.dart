//thak 17-05-2024

import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '/app/controllers/location_controller.dart';
import '../constants/global_config.dart';
import '../constants/global_variable.dart';
import '../models/hotel_model.dart';

class HotelController extends GetxController {
  final LocationController locationController = Get.put(LocationController());
  var hotels = <HotelModel>[].obs;
  var popularHotels = <HotelModel>[].obs;
  var filteredHotels = <HotelModel>[].obs;
  var nearbyHotels = <HotelModel>[].obs;
  final distance = ''.obs;
  var isLoading = true.obs;
  var showGrid = false.obs;
  var searchQuery = ''.obs;
  var selectedProvince = ''.obs;
  var selectedType = ''.obs;
  final Dio _dio = Dio();
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    fetchHotel();
    fetchPopularHotels();
    fetchNearbyHotels();
  }

  void changeView() {
    showGrid.value = !showGrid.value;
  }

  void filterHotel() {
    if (searchQuery.value.isEmpty &&
        selectedProvince.value.isEmpty &&
        selectedType.value.isEmpty) {
      filteredHotels.value = hotels;
    } else {
      filteredHotels.value = hotels.where((hotel) {
        final matchesQuery = hotel.hotelName!
            .toLowerCase()
            .contains(searchQuery.value.toLowerCase());
        final matchesType = selectedType.value.isEmpty ||
            hotel.hotelTypes!
                .any((type) => type.hotelTypeName == selectedType.value);
        final hotelProvince = hotel.village?.province?.provinceNameen;
        final matchesProvince = hotelProvince == selectedProvince.value ||
            selectedProvince.value.isEmpty;
        return matchesQuery && matchesType && matchesProvince;
      }).toList();
    }
    //print('Filtered Hotels: ${filteredHotels.length}');
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    filterHotel();
  }

  void updateSelectedType(String type) {
    selectedType.value = type;
    filterHotel();
  }

  void updateSelectedProvince(String province) {
    selectedProvince.value = province;
    filterHotel();
  }

  void clearProvinceSelection() {
    selectedProvince.value = '';
    selectedType.value = '';
    filterHotel();
  }

  Future<void> fetchHotel() async {
    isLoading.value = true;
    try {
      final response = await _dio.get('$baseUrl/api/get-all-hotel');
      if (response.statusCode == 200) {
        var data = response.data['data'] as List;
        var hotelList = data.map((json) => HotelModel.fromJson(json)).toList();
        hotelList.sort((a, b) => b.averageRating!.compareTo(a.averageRating!));
        hotels.value = hotelList;
        filterHotel();
      }
    } catch (e) {
      throw('Failed to load hotels: $e');
    } finally {
      isLoading.value = false;
    }
  }

//thak 17-05-2024

  Future<void> fetchPopularHotels() async {
    isLoading.value = true;
    try {
      final response = await _dio.get(
        '$baseApiUrl/hotel/popular',
      );
      if (response.statusCode == 200) {
        var popHotels = response.data['data'] as List;
        popularHotels.value =
            popHotels.map((hotel) => HotelModel.fromJson(hotel))
                .take(20)
                .toList();
        popularHotels.refresh();
      }
    } catch (e) {
      throw('Failed to load popular hotels $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchNearbyHotels() async {
    isLoading.value = true;
    try {
      for (var hotel in hotels) {
        var lat = double.tryParse(hotel.latitude ?? '') ?? 0;
        var long = double.tryParse(hotel.longitude ?? '') ?? 0;
        var distance = Geolocator.distanceBetween(
          locationController.currentPosition.value.latitude,
          locationController.currentPosition.value.longitude,
          lat,
          long,
        );
        hotel.distance = distance / 1000;
        if (hotel.distance! < 10) {
          nearbyHotels.add(hotel);
        }
      }

      if (nearbyHotels.isNotEmpty) {
        nearbyHotels.sort((a, b) => a.distance!.compareTo(b.distance!));
      }

      var sortedHotels = List<HotelModel>.from(hotels)
        ..sort((a, b) => a.distance!.compareTo(b.distance!));

      nearbyHotels.value =
          sortedHotels.where((hotel) => hotel.distance! < 10).toList();

      nearbyHotels.value = sortedHotels.take(5).toList();
      nearbyHotels.refresh();
    } catch (e) {
      //print('Failed to load nearby hotels $e');
      throw Exception('Failed to load nearby hotels $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchDistance(
    double curLat,
    double curLong,
    double destLat,
    double destLong,
  ) async {
    try {
      final response = await _dio.get(
        'https://maps.googleapis.com/maps/api/directions/json?origin=$curLat,$curLong&destination=$destLat,$destLong&key=$googleMapApi',
      );
      if (response.statusCode == 200) {
        distance.value =
            response.data['routes'][0]['legs'][0]['distance']['text'] as String;
        distance.refresh();
      }
    } catch (e) {
      throw('Failed to load distance $e');
    }
  }
}
