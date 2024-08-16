import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/hotel_model.dart';
import '../../models/location_model.dart';
import '../../controllers/location_controller.dart';
import 'hotel_detail_map_screen.dart';

class HotelMapScreen extends StatelessWidget {
  final HotelModel hotel;

  HotelMapScreen({super.key, required this.hotel});

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
                    double.parse(hotel.latitude ?? '0.0'),
                    double.parse(hotel.longitude ?? '0.0'),
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
                        HotelMapDetailScreen(
                          location: location,
                          origin: origin,
                          destination: destination,
                          icon: icon ?? BitmapDescriptor.defaultMarker,
                          hotel: hotel,
                        ),
                        curve: Curves.easeIn,
                        duration: const Duration(milliseconds: 500),
                        transition: Transition.zoom,
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
                          double.parse(hotel.latitude ?? '0.0'),
                          double.parse(hotel.longitude ?? '0.0'),
                        );
                        controller.fetchDirectionsAndUpdate(origin, destination);
                        _moveCameraToLocation(destination);
                        Get.to(
                          HotelMapDetailScreen(
                            location: LocationModel(
                              id: hotel.hotelId ?? 0,
                              name: hotel.hotelName ?? '',
                              latitude: double.parse(hotel.latitude ?? '0.0'),
                              longitude: double.parse(hotel.longitude ?? '0.0'),
                              type: 'hotel',
                            ),
                            origin: origin,
                            destination: destination,
                            icon: controller.hotelIcon ??
                                BitmapDescriptor.defaultMarker,
                            hotel: hotel,
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
