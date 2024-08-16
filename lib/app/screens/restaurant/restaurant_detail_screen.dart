import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:ui_komsan/app/controllers/location_controller.dart';
import '../../widgets/global/card_horizontal.dart';
import '../../widgets/global/page_detail_image.dart';
import '../../widgets/home/place_tag.dart';
import '/app/controllers/hotel_controller.dart';
import '/app/controllers/res_controller.dart';
import '/app/screens/restaurant/restaurant_map_screen.dart';
import '/app/screens/restaurant/restaurant_nearest_screen.dart';
import '../../controllers/place_controller.dart';
import '../hotel/hotel_nearest_screen.dart';
import '../place/place_nearest_screen.dart';
import '/app/constants/global_variable.dart';
import '/app/controllers/res_rating_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/subtitle_widget.dart';
import '../../widgets/title_text_widget.dart';
import '../../constants/alert_message.dart';
import '../../controllers/authentication_controller.dart';
import '../../controllers/res_fav_controller.dart';
import '../../models/restaurant_model.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final RestaurantModel restaurant;

  const RestaurantDetailScreen({super.key, required this.restaurant});

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  final PageController _imageController = PageController();
  final RestFavController _restFavController = Get.find<RestFavController>();
  final RestRatingController _restRatingController =
      Get.put(RestRatingController());
  final AuthenticationController _checkTokenController =
      Get.put(AuthenticationController());
  final RestaurantController restaurantController =
      Get.put(RestaurantController());
  final HotelController hotelController = Get.put(HotelController());
  final PlaceController placeController = Get.put(PlaceController());
  final LocationController locationController = Get.put(LocationController());
  bool refresh = false;

  @override
  void initState() {
    // TODO: implement initState
    var resLatitude = double.tryParse(widget.restaurant.latitude!);
    var resLongitude = double.tryParse(widget.restaurant.longitude!);
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _restFavController.fetchFavoriteStatus(widget.restaurant.resId!);
      _restRatingController.fetchUserRating(widget.restaurant.resId!);
      placeController.fetchNearbyPlace();
      hotelController.fetchNearbyHotels();
      restaurantController.fetchNearbyRes();
      restaurantController.fetchDistance(
        locationController.currentPosition.value.latitude,
        locationController.currentPosition.value.longitude,
        resLatitude!,
        resLongitude!,
      );
    });
  }

  // modify #IT-193 Mach 2024-06-12

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back(
              result: refresh
            );
          },
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(8.0),
        color: Colors.transparent,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Container(
              width: double.infinity,
              height: 240,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: widget.restaurant.restaurantGallery != null &&
                      widget.restaurant.restaurantGallery!.isNotEmpty
                  ? Stack(
                      children: [
                        PageView.builder(
                            controller: _imageController,
                            itemCount:
                                widget.restaurant.restaurantGallery!.length,
                            itemBuilder: (context, index) {
                              return PageDetailImage(
                                imageUrl: '$resImageUrl'
                                    '${widget.restaurant.restaurantGallery![index].image ?? ''}',
                                errorWidget: (p0, p1, p2) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.blueAccent,
                                    ),
                                  );
                                },
                              );
                            }),
                        Positioned(
                          bottom: 18,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: SmoothPageIndicator(
                              controller: _imageController,
                              count:
                                  widget.restaurant.restaurantGallery!.length,
                              effect: WormEffect(
                                strokeWidth: 2,
                                dotHeight: 8,
                                dotWidth: 8,
                                activeDotColor: Colors.blueAccent,
                                dotColor: Colors.grey.shade100,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : const Center(child: Text('No images available')),
            ),
            const SizedBox(height: 8.0),
            Container(
              margin: const EdgeInsets.only(left: 8.0, right: 8.0),
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 9,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleTextWidget(
                          label: widget.restaurant.resName!,
                          fontSize: 16,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 4.0),
                        SubtitleWidget(
                          label:
                              "Location: ${widget.restaurant.village?.province?.provinceNameen ?? "Unknown"}",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4.0),
                        SubtitleWidget(
                          label:
                              "Open time: ${widget.restaurant.openTime} - ${widget.restaurant.closeTime}",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4.0),
                        Row(
                          // modify IT-129-Pithak-2024-05-21
                          children: [
                            const SubtitleWidget(
                              label: "Website: ",
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            const SizedBox(width: 4.0),
                            GestureDetector(
                              // modify IT-144 Pithak 2024-05-21
                              onTap: () async {
                                String? url = widget.restaurant.resWeb?.trim();
                                if (url != null && url.isNotEmpty) {
                                  if (!url.startsWith('http://') &&
                                      !url.startsWith('https://')) {
                                    url = 'https://$url';
                                  }
                                  final uri = Uri.parse(url);
                                  final scaffoldMessenger =
                                      ScaffoldMessenger.of(context);
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(uri,
                                        mode: LaunchMode.externalApplication);
                                  } else {
                                    scaffoldMessenger.showSnackBar(
                                      SnackBar(
                                        content: Text('Could not launch $url'),
                                      ),
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: SubtitleWidget(
                                      label: 'Website URL not provided',
                                      fontSize: 12,
                                    )),
                                  );
                                }
                              },
                              child: SizedBox(
                                width: 200,
                                child: SubtitleWidget(
                                  // modify IT-144 Pithak 2024-05-21
                                  label: widget.restaurant.resWeb ?? "N/A",
                                  maxLines: 1,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.blueAccent,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          // modify IT-144 Pithak 2024-05-21
                          children: [
                            const SubtitleWidget(
                              label: "Foods:",
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            const SizedBox(width: 6.0),
                            SizedBox(
                              width: 200,
                              height: 40,
                              child: ListView.builder(
                                itemCount: widget.restaurant.foods?.length,
                                physics: const ClampingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  var food = widget.restaurant.foods?[index];
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      PlaceTag(tag: food?.foodName ?? ""),
                                      const SizedBox(width: 8.0)
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Obx(() {
                    return _restFavController.isLoading.value
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.blueAccent,
                              strokeWidth: 2,
                            ),
                          )
                        : IconButton(
                            onPressed: () {
                              if (_checkTokenController.hasToken()) {
                                _restFavController
                                    .toggleFavorite(widget.restaurant.resId!);
                                if(_restFavController.isFavorite.value){
                                  setState(() {
                                    refresh = true;
                                  });
                                }
                              } else {
                                alertMessage(
                                    context); // modify #IT-193 Mach 2024-06-12
                              }
                            },
                            icon: _restFavController.isFavorite.value
                                ? const Icon(
                                    Icons.favorite,
                                    size: 40,
                                    color: Colors.blueAccent,
                                  )
                                : const Icon(
                                    Icons.favorite_border,
                                    size: 40,
                                    color: Colors.blueAccent,
                                  ),
                          );
                  })
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Obx(() {
                var userRating =
                    _restRatingController.resRatingModel.value.rating != null
                        ? _restRatingController.resRatingModel.value.rating
                            ?.toStringAsFixed(1)
                        : "";
                return Row(
                  children: [
                    const SubtitleWidget(
                      label: "Rating:",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(width: 6.0),
                    RatingBar.builder(
                      initialRating:
                          _restRatingController.resRatingModel.value.rating ??
                              0,
                      minRating: 0.5,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 24,
                      updateOnDrag: true,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star_rounded,
                        color: Colors.blueAccent,
                      ),
                      onRatingUpdate: (rating) {
                        if (_checkTokenController.hasToken()) {
                          _restRatingController.userRating(
                              widget.restaurant.resId!, rating);
                          refresh = true;
                        } else {
                          // modify #IT-193 Mach 2024-06-12
                          alertMessage(context);
                        }
                      },
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: SubtitleWidget(
                        label:
                            _restRatingController.resRatingModel.value.rating !=
                                    null
                                ? '(You rated: $userRating )'
                                : '(Not rated yet)',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.blueAccent,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                );
              }),
            ),
            const SizedBox(height: 8.0),
            Obx(() {
              return Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  children: [
                    const SubtitleWidget(
                      label: "Distance:",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    SubtitleWidget(
                      label: " ${restaurantController.distance.value}",
                      fontSize: 14,
                      color: Colors.blueAccent,
                    ),
                    const SubtitleWidget(
                      label: " from your location",
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 8.0),
            SizedBox(
              height: 200,
              width: double.infinity,
              child: RestaurantMapScreen(
                restaurant: widget.restaurant,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(8.0),
              color: Colors.transparent,
              child: const Text(
                "About This Restaurant",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // Description details
            Container(
              margin: const EdgeInsets.only(left: 8.0, right: 8.0),
              alignment: Alignment.center,
              color: Colors.transparent,
              child: ReadMoreText(
                widget.restaurant.resDes!,
                trimMode: TrimMode.Line,
                trimLines: 2,
                trimCollapsedText: 'See more',
                trimExpandedText: 'See less',
                moreStyle: const TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
                lessStyle: const TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  Container(
                    color: Colors.transparent,
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TabBar(
                          // isScrollable: true,
                          labelColor: Colors.blueAccent,
                          dividerColor: Colors.transparent,
                          labelStyle: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GeneralFont',
                          ),
                          indicator: UnderlineTabIndicator(
                            borderSide: BorderSide(
                              width: 3,
                              color: Colors.blue,
                            ),
                          ),
                          tabs: [
                            Tab(
                              child: TitleTextWidget(
                                label: "Nearest Restaurant",
                                fontSize: 12,
                              ),
                            ),
                            Tab(
                              child: TitleTextWidget(
                                label: "Nearest Hotel",
                                fontSize: 12,
                              ),
                            ),
                            Tab(
                              child: TitleTextWidget(
                                label: "Nearest Place",
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.4,
                    color: Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TabBarView(
                      children: [
                        Obx(
                          () {
                            if (restaurantController.isLoading.value) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.blueAccent,
                                ),
                              );
                            } else if (restaurantController.nearbyRes.isEmpty) {
                              return const Center(
                                child: Text('No data found'),
                              );
                            } else {
                              return ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount:
                                    restaurantController.nearbyRes.length,
                                itemBuilder: (context, index) {
                                  var resNearest =
                                      restaurantController.nearbyRes[index];
                                  var userRating =
                                      resNearest.averageRating != null
                                          ? resNearest.averageRating!
                                              .toStringAsFixed(1)
                                          : "Not rated yet";
                                  return Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      CardHorizontal(
                                        onTap: () async {
                                          await Get.to(
                                            () => RestaurantNearestScreen(
                                              restaurant: resNearest,
                                            ),
                                          );
                                        },
                                        errorWidget: (p0, p1, p2) {
                                          return const Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.blueAccent,
                                            ),
                                          );
                                        },
                                        image:
                                            '$resImageUrl${resNearest.restaurantGallery![0].image}',
                                        name: resNearest.resName!,
                                        location: resNearest.village?.province
                                                ?.provinceNameen ??
                                            'Unknown',
                                        rating: userRating,
                                      ),
                                      const SizedBox(height: 8.0),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                        ),
                        Obx(
                          () {
                            if (hotelController.isLoading.value) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.blueAccent,
                                ),
                              );
                            } else if (hotelController.nearbyHotels.isEmpty) {
                              return const Center(
                                child: Text('No data found'),
                              );
                            }
                            return ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: hotelController.nearbyHotels.length,
                              itemBuilder: (context, index) {
                                var hotelNearest =
                                    hotelController.nearbyHotels[index];
                                var userRating =
                                    hotelNearest.averageRating != null
                                        ? hotelNearest.averageRating!
                                            .toStringAsFixed(1)
                                        : "Not rated yet";
                                return Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    CardHorizontal(
                                      onTap: () async {
                                        await Get.to(
                                          () => HotelNearestScreen(
                                            hotel: hotelNearest,
                                          ),
                                        );
                                      },
                                      errorWidget: (p0, p1, p2) {
                                        return const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.blueAccent,
                                          ),
                                        );
                                      },
                                      image:
                                          '$hotelImageUrl${hotelNearest.hotelGallery![0].image}',
                                      name: hotelNearest.hotelName!,
                                      location: hotelNearest.village?.province
                                              ?.provinceNameen ??
                                          'Unknown',
                                      rating: userRating,
                                    ),
                                    const SizedBox(height: 8.0)
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        Obx(
                          () {
                            if (placeController.isLoading.value) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.blueAccent,
                                ),
                              );
                            } else if (placeController.nearbyPlaces.isEmpty) {
                              return const Center(
                                child: Text('No data found'),
                              );
                            }
                            return ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: placeController.nearbyPlaces.length,
                              itemBuilder: (context, index) {
                                var placeNearest =
                                    placeController.nearbyPlaces[index];
                                var userRating =
                                    placeNearest.averageRating != null
                                        ? placeNearest.averageRating!
                                            .toStringAsFixed(1)
                                        : "Not rated yet";
                                return Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    CardHorizontal(
                                      onTap: () async {
                                        await Get.to(
                                          () => PlaceNearestScreen(
                                            place: placeNearest,
                                          ),
                                        );
                                      },
                                      errorWidget: (p0, p1, p2) {
                                        return const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.blueAccent,
                                          ),
                                        );
                                      },
                                      image:
                                          '$placeImageUrl${placeNearest.placeGallery![0].image}',
                                      name: placeNearest.placeName!,
                                      location: placeNearest.village?.province
                                              ?.provinceNameen ??
                                          'Unknown',
                                      rating: userRating,
                                    ),
                                    const SizedBox(height: 8.0),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
