import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../constants/global_config.dart';
import '../constants/global_variable.dart';
import '../models/location_model.dart';

class LocationService extends GetxService {
  final Dio _dio = Dio();

  // static Future<bool> requestLocationPermission() async {
  //   var status = await Permission.location.request();
  //
  //   if (status.isGranted) {
  //     return true;
  //   } else if (status.isPermanentlyDenied) {
  //     openAppSettings();
  //   }
  //
  //   return false;
  // }
  //
  // static Future<Position?> getCurrentPosition() async {
  //   bool hasPermission = await requestLocationPermission();
  //
  //   if (!hasPermission) {
  //     return null;
  //   }
  //
  //   return await Geolocator.getCurrentPosition(
  //     desiredAccuracy: LocationAccuracy.high,
  //     forceAndroidLocationManager: true,
  //   );
  // }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<List<LocationModel>> fetchLocations() async {
    try {
      final response = await _dio.get('$baseApiUrl/locations');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((location) => LocationModel.fromJson(location))
            .toList();
      } else {
        throw Exception('Failed to load locations');
      }
    } catch (e) {
      throw Exception('Failed to load locations: $e');
    }
  }

  Future<Map<String, dynamic>> fetchDirections(
      LatLng origin, LatLng destination) async {
    const String apiKey = apiGoogleMap;
    final directionsApiUrl =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey';
    final response = await _dio.get(directionsApiUrl);

    if (response.statusCode == 200) {
      final jsonResponse = response.data;
      final points = PolylinePoints().decodePolyline(
          jsonResponse['routes'][0]['overview_polyline']['points']);
      final List<LatLng> polylineCoordinates = points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();
      final distance = jsonResponse['routes'][0]['legs'][0]['distance']['text'];
      final duration = jsonResponse['routes'][0]['legs'][0]['duration']['text'];
      return {
        'polylineCoordinates': polylineCoordinates,
        'distance': distance,
        'duration': duration,
      };
    } else {
      throw Exception('Failed to fetch directions');
    }
  }
}
