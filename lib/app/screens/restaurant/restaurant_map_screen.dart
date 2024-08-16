import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '/app/models/restaurant_model.dart';
import '../../models/location_model.dart';
import '../../controllers/location_controller.dart';
import 'restaurant_map_detail_screen.dart';

class RestaurantMapScreen extends StatelessWidget {
  final RestaurantModel restaurant;

  RestaurantMapScreen({super.key, required this.restaurant});

  final LocationController controller = Get.put(LocationController());
  GoogleMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    controller.getCurrentLocation();
    controller.placeIcon;
    return Obx(
      () => controller.currentPosition.value.latitude == 0 &&
              controller.currentPosition.value.longitude == 0
          ? const Center(child: CircularProgressIndicator())
          : Scaffold(
              body: GoogleMap(
                onMapCreated: (GoogleMapController mapController) {
                  _mapController = mapController;
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    double.parse(restaurant.latitude ?? '0.0'),
                    double.parse(restaurant.longitude ?? '0.0'),
                  ),
                  zoom: 20.0,
                ),
                markers: controller.locations.map((location) {
                  BitmapDescriptor? icon;
                  switch (location.type) {
                    case 'place':
                      icon = controller.placeIcon;
                      break;
                    case 'hotel':
                      icon = controller.hotelIcon;
                      break;
                    case 'restaurant':
                      icon = controller.restaurantIcon;
                      break;
                  }

                  return Marker(
                    markerId: MarkerId(location.name),
                    position: LatLng(location.latitude, location.longitude),
                    infoWindow: InfoWindow(
                      title: location.name,
                      snippet: location.type,
                    ),
                    icon: icon ?? BitmapDescriptor.defaultMarker,
                    onTap: () async {
                      final origin = controller.currentPosition.value;
                      final destination =
                          LatLng(location.latitude, location.longitude);
                      await controller.fetchDirectionsAndUpdate(origin, destination);
                      _moveCameraToLocation(destination);
                      Get.to(
                        () => RestaurantMapDetailScreen(
                          location: location,
                          origin: origin,
                          destination: destination,
                          icon: icon ?? BitmapDescriptor.defaultMarker,
                          restaurant: restaurant,
                        ),
                      );
                    },
                  );
                }).toSet(),
                polylines: Set<Polyline>.of(controller.polylines),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                scrollGesturesEnabled: true,
                padding: const EdgeInsets.only(bottom: 30.0),
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                  Factory<OneSequenceGestureRecognizer>(
                    () => EagerGestureRecognizer(),
                  ),
                },
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endContained,
              floatingActionButton: Stack(
                children: [
                  Positioned(
                    right: -5,
                    bottom: 0,
                    child: FloatingActionButton(
                      mini: true,
                      shape: const CircleBorder(
                        side: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        final origin = controller.currentPosition.value;
                        final destination = LatLng(
                          double.parse(restaurant.latitude ?? '0.0'),
                          double.parse(restaurant.longitude ?? '0.0'),
                        );
                        controller.fetchDirectionsAndUpdate(origin, destination);
                        _moveCameraToLocation(destination);
                        Get.to(
                          RestaurantMapDetailScreen(
                            location: LocationModel(
                              id: restaurant.resId ?? 0,
                              name: restaurant.resName ?? '',
                              latitude:
                                  double.parse(restaurant.latitude ?? '0.0'),
                              longitude:
                                  double.parse(restaurant.longitude ?? '0.0'),
                              type: 'restaurant',
                            ),
                            origin: origin,
                            destination: destination,
                            icon: controller.hotelIcon ??
                                BitmapDescriptor.defaultMarker,
                            restaurant: restaurant,
                          ),
                          curve: Curves.easeIn,
                          duration: const Duration(milliseconds: 500),
                          transition: Transition.zoom,
                        );
                      },
                      child: const Icon(
                        Icons.directions,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _moveCameraToLocation(LatLng location) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLng(location),
    );
  }
}
