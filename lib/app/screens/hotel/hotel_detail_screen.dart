import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:readmore/readmore.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../widgets/global/card_horizontal.dart';
import '../../widgets/global/page_detail_image.dart';
import '../../widgets/home/place_tag.dart';
import '/app/controllers/location_controller.dart';
import '/app/constants/alert_message.dart';
import '/app/controllers/place_controller.dart';
import '/app/controllers/res_controller.dart';
import '/app/screens/restaurant/restaurant_nearest_screen.dart';
import '../place/place_nearest_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/subtitle_widget.dart';
import '../../widgets/title_text_widget.dart';
import '../../constants/global_variable.dart';
import '../../controllers/authentication_controller.dart';
import '../../controllers/hotel_controller.dart';
import '../../controllers/hotel_fav_controller.dart';
import '../../controllers/hotel_rating_controller.dart';
import '../../models/hotel_model.dart';
import 'hotel_map_screen.dart';
import 'hotel_nearest_screen.dart';

class HotelDetailScreen extends StatefulWidget {
  final HotelModel hotel;

  const HotelDetailScreen({super.key, required this.hotel});

  @override
  State<HotelDetailScreen> createState() => _HotelDetailScreenState();
}

class _HotelDetailScreenState extends State<HotelDetailScreen> {
  final PageController _imageController = PageController();
  final HotelFavController _hotelFavController = Get.find<HotelFavController>();
  final HotelRatingController _hotelRatingController =
      Get.put(HotelRatingController());
  final AuthenticationController _checkTokenController =
      Get.put(AuthenticationController());
  final HotelController hotelController = Get.put(HotelController());
  final RestaurantController restaurantController =
      Get.put(RestaurantController());
  final PlaceController placeController = Get.put(PlaceController());
  final LocationController locationController = Get.put(LocationController());
  bool refresh = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var latHotel = double.tryParse(widget.hotel.latitude!) ?? 0.0;
    var longHotel = double.tryParse(widget.hotel.longitude!) ?? 0.0;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _hotelFavController.fetchFavoriteStatus(widget.hotel.hotelId!);
      _hotelRatingController.fetchUserRating(widget.hotel.hotelId!);
      hotelController.fetchNearbyHotels();
      restaurantController.fetchNearbyRes();
      placeController.fetchNearbyPlace();
      hotelController.fetchDistance(
        locationController.currentPosition.value.latitude,
        locationController.currentPosition.value.longitude,
        latHotel,
        longHotel,
      );
    });
  }

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
              height: 260,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: widget.hotel.hotelGallery != null &&
                      widget.hotel.hotelGallery!.isNotEmpty
                  ? Stack(
                      // modify IT-139-Pithak-2024-05-21
                      children: [
                        PageView.builder(
                            controller: _imageController,
                            itemCount: widget.hotel.hotelGallery!.length,
                            itemBuilder: (context, index) {
                              return PageDetailImage(
                                imageUrl:
                                    '$hotelImageUrl${widget.hotel.hotelGallery![index].image ?? ''}',
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
                              count: widget.hotel.hotelGallery!.length,
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
                          label: widget.hotel.hotelName!,
                          fontSize: 16,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
                        SubtitleWidget(
                          label:
                              "Location: ${widget.hotel.village?.province?.provinceNameen ?? 'Unknown'}",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4.0),
                        Row(
                          children: [
                            const SubtitleWidget(
                              label: "Website: ",
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            GestureDetector(
                              onTap: () async {
                                String? url = widget.hotel.website?.trim();
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
                                  label: widget.hotel.website ?? "N/A",
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
                          children: [
                            // Container for Tag01
                            const SubtitleWidget(
                              label: "Type:",
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            const SizedBox(width: 4.0),
                            SizedBox(
                              width: 120,
                              height: 40,
                              child: ListView.builder(
                                  itemCount: widget.hotel.hotelTypes?.length,
                                  physics: const ClampingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        PlaceTag(
                                          tag: widget.hotel.hotelTypes?.first
                                                  .hotelTypeName ??
                                              'Unknown',
                                        ),
                                        const SizedBox(width: 8.0)
                                      ],
                                    );
                                  }),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Obx(
                    () {
                      return _hotelFavController.isLoading.value
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.blueAccent,
                                strokeWidth: 2,
                              ),
                            )
                          : IconButton(
                              onPressed: () {
                                if (_checkTokenController.hasToken()) {
                                  _hotelFavController
                                      .toggleFavorite(widget.hotel.hotelId!);
                                  if (_hotelFavController.isFavorite.value) {
                                    setState(() {
                                      refresh = true;
                                    });
                                  }
                                } else {
                                  alertMessage(context);
                                }
                              },
                              icon: _hotelFavController.isFavorite.value
                                  ? const Icon(Icons.favorite,
                                      size: 40, color: Colors.blueAccent)
                                  : const Icon(Icons.favorite_border,
                                      size: 40, color: Colors.blueAccent),
                            );
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Obx(() {
                var userRating =
                    _hotelRatingController.hotelRatingModel.value.rating != null
                        ? _hotelRatingController.hotelRatingModel.value.rating
                            ?.toStringAsFixed(1)
                        : "";
                return Row(
                  children: [
                    const SubtitleWidget(
                      label: "Rating:",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(
                      width: 6.0,
                    ),
                    RatingBar.builder(
                      initialRating: _hotelRatingController
                              .hotelRatingModel.value.rating ??
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
                          _hotelRatingController.userRating(
                              widget.hotel.hotelId!, rating);
                          refresh = true;
                        } else {
                          alertMessage(context);
                        }
                      },
                    ),
                    const SizedBox(width: 4.0),
                    Expanded(
                      child: SubtitleWidget(
                        label: _hotelRatingController
                                    .hotelRatingModel.value.rating !=
                                null
                            ? '(You rated: $userRating)'
                            : '(Not rated yet)',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                );
              }),
            ),
            const SizedBox(height: 8.0),
            Obx(() {
              return Container(
                margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                color: Colors.transparent,
                child: Row(
                  children: [
                    const SubtitleWidget(
                      label: "Distance:",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    SubtitleWidget(
                      label: " ${hotelController.distance.value}",
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
              child: HotelMapScreen(
                hotel: widget.hotel,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(8.0),
              color: Colors.transparent,
              child: const Text(
                "About This Place",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 8.0, right: 8.0),
              alignment: Alignment.center,
              color: Colors.transparent,
              child: ReadMoreText(
                widget.hotel.hotelDes!,
                trimMode: TrimMode.Line,
                trimLines: 5,
                trimCollapsedText: 'See more',
                trimExpandedText: 'See less',
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'GeneralFont'),
                moreStyle: const TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'GeneralFont'),
                lessStyle: const TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'GeneralFont',
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
                            Tab(
                              child: TitleTextWidget(
                                label: "Nearest Restaurant",
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
                            if (hotelController.isLoading.value) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.blueAccent,
                                ),
                              );
                            } else if (hotelController.nearbyHotels.isEmpty) {
                              return const Center(
                                child: Text("No data"),
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
                        Obx(
                          () {
                            return ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: restaurantController.nearbyRes.length,
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
