import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '/app/models/hotel_model.dart';
import '../../widgets/subtitle_widget.dart';
import '../../controllers/location_controller.dart';
import '../../models/location_model.dart';

class HotelMapDetailScreen extends StatefulWidget {
  const HotelMapDetailScreen({
    super.key,
    required this.location,
    required this.origin,
    required this.destination,
    required this.icon,
    required this.hotel,
  });

  final LocationModel location;
  final LatLng origin;
  final LatLng destination;
  final BitmapDescriptor icon;
  final HotelModel hotel;

  @override
  State<HotelMapDetailScreen> createState() => _HotelMapDetailScreenState();
}

class _HotelMapDetailScreenState extends State<HotelMapDetailScreen> {
  final LocationController controller = Get.put(LocationController());
  GoogleMapController? _mapController;
  var isNavigating = true.obs;
  var showDirectionButton = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Obx(() {
                  if (controller.currentPosition.value.latitude == 0 &&
                      controller.currentPosition.value.longitude == 0) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      GoogleMap(
                        onMapCreated: (GoogleMapController mapController) {
                          _mapController = mapController;
                        },
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            double.parse(widget.hotel.latitude ?? '0.0'),
                            double.parse(widget.hotel.longitude ?? '0.0'),
                          ),
                          zoom: 14.0,
                          bearing: 90.0,
                          tilt: 45.0,
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
                            position:
                                LatLng(location.latitude, location.longitude),
                            infoWindow: InfoWindow(
                              title: location.name,
                              snippet: location.type,
                            ),
                            icon: icon ?? BitmapDescriptor.defaultMarker,
                            onTap: () async {
                              controller
                                  .updateSelectedLocationName(location.name);
                              controller
                                  .updateSelectedLocationType(location.type);
                              _showDirectionButton(
                                LatLng(location.latitude, location.longitude),
                              );
                              LatLng origin = controller.currentPosition.value;
                              LatLng destination = LatLng(
                                  location.latitude,
                                  location
                                      .longitude); // Selected marker location
                              controller.updateRouteInfo(origin, destination);
                              setState(() {
                                showDirectionButton = false;
                              });
                            },
                          );
                        }).toSet(),
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        rotateGesturesEnabled: true,
                        trafficEnabled: true,
                        liteModeEnabled: false,
                        mapToolbarEnabled: true,
                        scrollGesturesEnabled: true,
                        cameraTargetBounds: CameraTargetBounds.unbounded,
                        gestureRecognizers: <Factory<
                            OneSequenceGestureRecognizer>>{
                          Factory<OneSequenceGestureRecognizer>(
                            () => EagerGestureRecognizer(),
                          ),
                        },
                        minMaxZoomPreference: MinMaxZoomPreference.unbounded,
                        zoomGesturesEnabled: true,
                        tiltGesturesEnabled: true,
                        padding: const EdgeInsets.only(top: 70.0),
                        onCameraMove: (CameraPosition position) {
                          controller.currentPosition.value = position.target;
                        },
                        polylines: controller.polylines.map((polyline) {
                          return Polyline(
                            polylineId: const PolylineId('route'),
                            color: Colors.blueAccent,
                            width: 8,
                            points: polyline.points,
                          );
                        }).toSet(),
                      ),
                      if (controller.polylines.isNotEmpty)
                        Positioned(
                          top: 84.0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10.0,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.directions,
                                  color: Colors.blueAccent,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                SubtitleWidget(
                                  label: controller.routeDuration.value,
                                  color: Colors.black,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w500,
                                ),
                                const SizedBox(width: 8),
                                SubtitleWidget(
                                  label: controller.routeDistance.value,
                                  color: Colors.black,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  );
                }),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 35,
                        height: 35,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10.0,
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                            size: 18,
                          ),
                          onPressed: () {
                            Get.back();
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          height: 35,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10.0,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Obx(
                              () => Row(
                                children: [
                                  Icon(
                                    controller.selectedLocationType.value ==
                                            'hotel'
                                        ? Icons.hotel
                                        : controller.selectedLocationType
                                                    .value ==
                                                'restaurant'
                                            ? Icons.restaurant
                                            : Icons.place,
                                    color: Colors.blueAccent,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: SubtitleWidget(
                                      label: controller.selectedLocationName
                                              .value.isEmpty
                                          ? widget.location.name
                                          : controller
                                              .selectedLocationName.value,
                                      color: Colors.black,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 150.0,
            right: -5.0,
            child: showDirectionButton
                ? FloatingActionButton(
                    heroTag: 'direction',
                    mini: true,
                    onPressed: () {
                      final origin = widget.origin;
                      final destination = widget.destination;
                      controller.fetchDirectionsAndUpdate(origin, destination);
                      _moveCameraToLocation(destination);
                      setState(() {
                        showDirectionButton = true;
                      });
                    },
                    child: const Icon(
                      Icons.directions,
                      color: Colors.blueAccent,
                    ),
                  )
                : const SizedBox(),
          ),
          Positioned(
            bottom: 100.0,
            right: -5.0,
            child: Obx(
              () => FloatingActionButton(
                mini: true,
                onPressed: isNavigating.value ? _startNavigation : null,
                child: Icon(
                  Icons.navigation,
                  color: Colors.blueAccent.withOpacity(
                    isNavigating.value ? 1.0 : 0.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _moveCameraToLocation(LatLng location) {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: location,
          zoom: 18.0,
          bearing: 360,
          tilt: 45.0,
        ),
      ),
    );
  }

  void _startNavigation() {
    LatLng userLocation = controller.currentPosition.value;
    LatLng nextDirectionPoint = controller.polylines.first.points.first;

    double bearing = calculateBearing(userLocation, nextDirectionPoint);
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: nextDirectionPoint,
          zoom: 18.0,
          bearing: bearing,
          tilt: 45.0,
        ),
      ),
    );
  }

  double calculateBearing(LatLng start, LatLng end) {
    double startLat = degreesToRadians(start.latitude);
    double startLong = degreesToRadians(start.longitude);
    double endLat = degreesToRadians(end.latitude);
    double endLong = degreesToRadians(end.longitude);

    double dLong = endLong - startLong;

    double dPhi = log(
      tan(endLat / 2.0 + pi / 4.0) / tan(startLat / 2.0 + pi / 4.0),
    );

    if (dLong.abs() > pi) {
      dLong = dLong > 0 ? -(2 * pi - dLong) : (2 * pi + dLong);
    }

    return (radiansToDegrees(atan2(dLong, dPhi)) + 360.0) % 360.0;
  }

  double degreesToRadians(double degrees) {
    return degrees * pi / 180.0;
  }

  double radiansToDegrees(double radians) {
    return radians * 180.0 / pi;
  }

  void _showDirectionButton(LatLng destination) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 80,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 0.0,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.directions,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8.0),
                    SubtitleWidget(
                      label: 'Get Directions',
                      color: Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                onPressed: () {
                  final origin = widget.origin;
                  controller.fetchDirectionsAndUpdate(origin, destination);
                  _moveCameraToLocation(destination);
                  Get.back();
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
