import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../models/location_model.dart';
import 'dart:ui' as ui;
import '../services/location_service.dart';

class LocationController extends GetxController {
  var locations = <LocationModel>[].obs;
  var polylines = <Polyline>[].obs;
  var currentPosition = const LatLng(0, 0).obs;
  final LocationService _networkService = LocationService();
  var userLocation = Rx<Position?>(null);
  var routeDistance = ''.obs;
  var routeDuration = ''.obs;
  var selectedLocationName = ''.obs;
  var selectedLocationType = ''.obs;


  BitmapDescriptor? placeIcon;
  BitmapDescriptor? hotelIcon;
  BitmapDescriptor? restaurantIcon;

  @override
  void onInit() {
    super.onInit();
    loadIcons();
    fetchLocations();
    getCurrentLocation();
  }

  void clearDirections() {
    polylines.clear();
    update();
  }

  void updateSelectedLocationName(String name) {
    selectedLocationName.value = name;
  }

  void updateSelectedLocationType(String type) {
    selectedLocationType.value = type;
  }

  Future<void> fetchLocations() async {
    try {
      locations.value = await _networkService.fetchLocations();
    } catch (e) {
      throw Exception('Failed to load locations: $e');
    }
  }

  Future<void> updateRouteInfo(LatLng origin, LatLng destination) async {
  try {
    final result = await _networkService.fetchDirections(origin, destination);
    final duration = result['duration'] as String;
    final distance = result['distance'] as String;

    routeDuration.value = duration;
    routeDistance.value = distance;
    update(); // Notify listeners to update UI
  } catch (e) {
    print('Failed to fetch route info: $e');
  }
}

  Future<void> fetchDirectionsAndUpdate(
      LatLng origin, LatLng destination) async {
    try {
      final result = await _networkService.fetchDirections(origin, destination);
      final polylineCoordinates = result['polylineCoordinates'] as List<LatLng>;
      final duration = result['duration'] as String;
      final distance = result['distance'] as String;

      routeDistance.value = distance;
      routeDuration.value = duration;
      polylines.clear();
      polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: polylineCoordinates,
          color: Colors.blueAccent,
          width: 8,
          visible: true,
          geodesic: true,
          consumeTapEvents: true,
          jointType: JointType.round,
          endCap: Cap.roundCap,
          startCap: Cap.roundCap,
          zIndex: 1,
        ),
      );
      update(); // Notify listeners to update UI
    } catch (e) {
      throw Exception('Failed to fetch directions: $e');
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      userLocation.value = await LocationService().determinePosition();
      currentPosition.value = LatLng(
        userLocation.value!.latitude,
        userLocation.value!.longitude,
      );
    } catch (e) {
      throw Exception('Failed to get current location: $e');
    }
  }

  Future<void> loadIcons() async {
    placeIcon = await getBitmapDescriptorFromAsset('assets/icons/places.png');
    hotelIcon = await getBitmapDescriptorFromAsset('assets/icons/hotel.png');
    restaurantIcon =
        await getBitmapDescriptorFromAsset('assets/icons/restaurant.png');
  }

  Future<BitmapDescriptor> getBitmapDescriptorFromAsset(String path) async {
    final ByteData data = await rootBundle.load(path);
    final ui.Codec codec = await ui
        .instantiateImageCodec(data.buffer.asUint8List(), targetWidth: 75);
    final ui.FrameInfo fi = await codec.getNextFrame();
    final ByteData? byteData =
        await fi.image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List resizedImage = byteData!.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(resizedImage);
  }

  void handleMapTap(LatLng tappedPosition) {
    // Find the nearest hotel within a certain threshold distance
    const double thresholdDistance = 0.01; // Adjust this value as needed
    for (var location in locations) {
      if (location.type == 'hotel') {
        final double distance = Geolocator.distanceBetween(
          tappedPosition.latitude,
          tappedPosition.longitude,
          location.latitude,
          location.longitude,
        );
        if (distance < thresholdDistance) {
          print(
              'Hotel found: ${location.name} at ${location.latitude}, ${location.longitude}');
          // Handle the found hotel (e.g., show a dialog or fetch directions)
          break;
        }
      }
    }
  }
}
