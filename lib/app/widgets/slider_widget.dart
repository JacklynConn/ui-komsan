import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/app/screens/hotel/hotel_detail_screen.dart';
import '../constants/global_config.dart';
import '../models/hotel_model.dart';
import '../models/place_model.dart';
import '../models/restaurant_model.dart';
import '../models/slider_model.dart';
import '../screens/home/slider_detail.dart';
import '../screens/place/place_detail_screen.dart';
import '../screens/restaurant/restaurant_detail_screen.dart';

class SliderWidget extends StatelessWidget {
  final List<SliderModel> sliders;

  const SliderWidget({
    super.key,
    required this.sliders,
  });

  void navigateToAnotherPage(BuildContext context, SliderModel slider) async {
    if (slider.type == 1) {
      // place
      Get.to(() => PlaceDetailScreen(place: slider.relatedData as PlaceModel),
          transition: Transition.rightToLeft);
    } else if (slider.type == 2) {
      // hotel
      Get.to(
        () => HotelDetailScreen(hotel: slider.relatedData as HotelModel),
        transition: Transition.rightToLeft,
      );
    } else if (slider.type == 3) {
      // restaurant
      var result = await Get.to(
        () => RestaurantDetailScreen(
            restaurant: slider.relatedData as RestaurantModel),
        transition: Transition.rightToLeft,
      );
    } else {
      // Null
      var result = await Get.to(
        () => SliderDetailPage(slider: slider),
        transition: Transition.rightToLeft,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: CarouselSlider.builder(
          itemCount: sliders.length,
          itemBuilder: (context, index, realIndex) => GestureDetector(
            onTap: () => navigateToAnotherPage(context, sliders[index]),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Stack(
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: '$baseUrl${sliders[index].image}',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(200, 0, 0, 0),
                            Color.fromARGB(0, 0, 0, 0)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 20.0,
                      ),
                      child: Text(
                        '${sliders[index].title}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          options: CarouselOptions(
            height: 210,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 6),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            viewportFraction: 1.0,
          ),
        ),
      ),
    );
  }
}
