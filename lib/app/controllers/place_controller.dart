import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import '/app/controllers/location_controller.dart';
import '../constants/global_variable.dart';
import '../models/place_model.dart';

class PlaceController extends GetxController {
  final LocationController locationController = Get.put(LocationController());
  var popularPlace = <PlaceModel>[].obs;
  var nearbyPlaces = <PlaceModel>[].obs;
  var isLoading = false.obs;
  var showGrid = false.obs;
  var userLocation = Rx<Position?>(null);
  var distance = ''.obs;
  final Dio dio = Dio();

  @override
  void onInit() {
    super.onInit();
    fetchPopularPlace();
    fetchNearbyPlace();
  }

  void changeView() {
    showGrid.value = !showGrid.value;
  }

  void fetchPopularPlace() async {
    isLoading.value = true;
    try {
      var response = await Dio().get('$baseApiUrl/place/popular');
      if (response.statusCode == 200) {
        var popPlace = response.data['data'] as List;
        popularPlace.value =
            popPlace.map((place) => PlaceModel.fromJson(place))
                .take(20)
                .toList();
        popularPlace.refresh();
      }
    } catch (e) {
      //print('Failed to load popular places $e');
      throw Exception('Failed to load popular places $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchNearbyPlace() async {
    isLoading.value = true;
    try {
      for (var place in popularPlace) {
        var lat = double.tryParse(place.latitude ?? '') ?? 0;
        var long = double.tryParse(place.longitude ?? '') ?? 0;
        var distance = Geolocator.distanceBetween(
          locationController.currentPosition.value.latitude,
          locationController.currentPosition.value.longitude,
          lat,
          long,
        );
        place.distance = distance / 1000;
        if (place.distance! < 10) {
          nearbyPlaces.add(place);
        }
      }

      if (nearbyPlaces.isNotEmpty) {
        nearbyPlaces.sort((a, b) => a.distance!.compareTo(b.distance!));
      }

      var sortedHotels = List<PlaceModel>.from(popularPlace)
        ..sort((a, b) => a.distance!.compareTo(b.distance!));

      nearbyPlaces.value =
          sortedHotels.where((hotel) => hotel.distance! < 10).toList();

      nearbyPlaces.value = sortedHotels.take(5).toList();
      nearbyPlaces.refresh();
    } catch (e) {
      //print('Failed to load nearby hotels $e');
      throw Exception('Failed to load nearby places $e');
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
      final response = await dio.get(
        'https://maps.googleapis.com/maps/api/directions/json?origin=$curLat,$curLong&destination=$destLat,$destLong&key=$googleMapApi',
      );
      if (response.statusCode == 200) {
        distance.value =
        response.data['routes'][0]['legs'][0]['distance']['text'] as String;
        distance.refresh();
      }
    } catch (e) {
      //print('Failed to load distance $e');
      throw Exception('Failed to load distance $e');
    }
  }
}
