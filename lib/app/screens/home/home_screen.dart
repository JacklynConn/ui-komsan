import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/app/controllers/app_version_controller.dart';
import '/app/controllers/notification_controller.dart';
import '../../widgets/home/place_card_vertical.dart';
import '../../widgets/home/place_tag.dart';
import '../../widgets/home/province_category.dart';
import '../../widgets/home/province_widget.dart';
import '/app/screens/home/notification_screen.dart';
import '../../widgets/global/card_vertical.dart';
import '/app/controllers/hotel_controller.dart';
import '/app/controllers/slider_controller.dart';
import '../../controllers/place_controller.dart';
import '../../models/place_model.dart';
import '../hotel/hotel_detail_screen.dart';
import '../place/place_detail_screen.dart';
import '/app/controllers/res_controller.dart';
import '/app/models/province_model.dart';
import '../../widgets/slider_widget.dart';
import '../../constants/global_config.dart';
import '../../constants/global_variable.dart';
import '../../controllers/province_controller.dart';
import '../place/place_in_province_screen.dart';
import '../restaurant/restaurant_detail_screen.dart';
import '/app/screens/home/popular_restaurant.dart';
import '/app/screens/home/popular_hotel.dart';
import '/app/screens/home/popular_place.dart';
import '../../widgets/subtitle_widget.dart';
import '../../widgets/app_name_widget.dart';
import 'search_place.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/HomeScreen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AppVersionController _appVersionController =
      Get.put(AppVersionController());
  List<ProvinceModel> provinces = [];
  final ProvinceController _provinceController = Get.put(ProvinceController());
  final RestaurantController _resController = Get.put(RestaurantController());
  final HotelController _hotelController = Get.put(HotelController());
  final PlaceController _placeController = Get.put(PlaceController());
  final SliderController _sliderController = Get.put(SliderController());
  final NotificationController _notificationController =
      Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: RefreshIndicator(
        onRefresh: () async {
          _provinceController.fetchProvince();
          _hotelController.fetchPopularHotels();
          _placeController.fetchPopularPlace();
          _resController.fetchPopularRes();
          _sliderController.fetchSlider();
        },
        child: Scaffold(
          appBar: AppBar(
            title: const AppNameTextWidget(),
            actions: [
              IconButton(
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: SearchPlaceDelegate(),
                  );
                },
                icon: const Icon(CupertinoIcons.search),
                color: Colors.blueAccent,
              ),
              Stack(
                children: [
                  IconButton(
                    onPressed: () {
                      Get.toNamed(NotificationScreen.routeName);
                    },
                    icon: const Icon(
                      CupertinoIcons.bell,
                      color: Colors.blueAccent,
                    ),
                  ),
                  Positioned(
                    top: 2,
                    right: 8,
                    child: Obx(() {
                      if (_notificationController.unreadCount.value == 0) {
                        return const SizedBox();
                      }
                      return CircleAvatar(
                        radius: 7,
                        backgroundColor: Colors.red,
                        child: SubtitleWidget(
                          label: '${_notificationController.unreadCount.value}',
                          fontSize: 8,
                          color: Colors.white,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ],
          ),
          body: Obx(() {
            if (_provinceController.isLoading.value ||
                _resController.isLoading.value ||
                _hotelController.isLoading.value ||
                _sliderController.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.blueAccent,
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      if(_sliderController.sliders.isNotEmpty) ...[
                        SliderWidget(sliders: _sliderController.sliders),
                      ],
                      const ProvinceWidget(),
                      SizedBox(
                        width: double.infinity,
                        height: 280,
                        child: GridView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _provinceController.provinces.length,
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            childAspectRatio: 1,
                            mainAxisSpacing: 8.0,
                          ),
                          itemBuilder: (context, index) {
                            var province = _provinceController.provinces[index];
                            return ProvinceCategory(
                              onTap: () {
                                Get.to(
                                  () =>
                                      PlaceInProvinceScreen(province: province),
                                );
                              },
                              image: '$baseUrl${province.provinceImage}',
                              name: '${province.provinceNameen}',
                              errorWidget: (p0, p1, p2) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.blueAccent,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: SubtitleWidget(
                              label: 'Popular Places'.tr,
                              fontSize: 16,
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              Get.to(
                                () => PopularPlaces(),
                                transition: Transition.rightToLeft,
                              );
                            },
                            icon: const Icon(
                              Icons.arrow_forward_ios,
                              size: 15,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 240,
                        // color: Colors.grey,
                        child: GridView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _placeController.popularPlace.length > 5
                              ? 5
                              : _placeController.popularPlace.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            mainAxisSpacing: 8,
                            childAspectRatio: 1.4,
                          ),
                          itemBuilder: (context, index) {
                            PlaceModel popularPlace =
                                _placeController.popularPlace[index];
                            return PlaceCardVertical(
                              onTap: () {
                                Get.to(
                                    () =>
                                        PlaceDetailScreen(place: popularPlace),
                                    transition: Transition.rightToLeft);
                              },
                              image:
                                  "$placeImageUrl${popularPlace.placeGallery?.first.image}",
                              name: popularPlace.placeName ?? 'Unknown',
                              location: popularPlace
                                      .village?.province?.provinceNameen ??
                                  'Unknown',
                              rating: '${popularPlace.averageRating ?? '0.0'}',
                              child: ListView.builder(
                                itemCount: popularPlace.placeTypes?.length,
                                physics: const ClampingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      PlaceTag(
                                        tag: popularPlace.placeTypes?[index]
                                                .placeTypeName ??
                                            'Unknown',
                                      ),
                                      const SizedBox(width: 8.0)
                                    ],
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: SubtitleWidget(
                              label: 'Popular Hotels'.tr,
                              fontSize: 16,
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              Get.to(
                                () => PopularHotel(),
                                transition: Transition.rightToLeft,
                              );
                            },
                            icon: const Icon(
                              Icons.arrow_forward_ios,
                              size: 15,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 240,
                        width: double.infinity,
                        // color: Colors.grey,
                        child: GridView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _hotelController.popularHotels.length > 5
                              ? 5
                              : _hotelController.popularHotels.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            mainAxisSpacing: 8,
                            childAspectRatio: 1.4,
                          ),
                          itemBuilder: (context, index) {
                            var popularHotels =
                                _hotelController.popularHotels[index];
                            return CardVertical(
                              onTap: () {
                                Get.to(
                                  () => HotelDetailScreen(
                                    hotel: popularHotels,
                                  ),
                                  transition: Transition.rightToLeft,
                                );
                              },
                              image:
                                  '$hotelImageUrl${popularHotels.hotelGallery?.first.image}',
                              name: popularHotels.hotelName ?? 'Unknown',
                              location: popularHotels
                                      .village?.province?.provinceNameen ??
                                  "Unknown",
                              rating: '${popularHotels.averageRating ?? '0.0'}',
                            );
                          },
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: SubtitleWidget(
                              label: 'Popular Restaurants'.tr,
                              fontSize: 16,
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              Get.to(
                                () => PopularRestaurant(),
                                transition: Transition.rightToLeft,
                              );
                            },
                            icon: const Icon(
                              Icons.arrow_forward_ios,
                              size: 15,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 240,
                        width: double.infinity,
                        child: GridView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _resController.popularRes.length > 5
                              ? 5
                              : _resController.popularRes.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            mainAxisSpacing: 8,
                            childAspectRatio: 1.4,
                          ),
                          itemBuilder: (context, index) {
                            var popularRes = _resController.popularRes[index];
                            return CardVertical(
                              onTap: () {
                                Get.to(
                                  () => RestaurantDetailScreen(
                                      restaurant: popularRes),
                                  transition: Transition.rightToLeft,
                                );
                              },
                              image:
                                  '$resImageUrl${popularRes.restaurantGallery?.first.image}',
                              name: popularRes.resName ?? 'Unknown',
                              location: popularRes
                                      .village?.province?.provinceNameen ??
                                  'Unknown',
                              rating: '${popularRes.averageRating ?? '0.0'}',
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
        ),
      ),
    );
  }
}
