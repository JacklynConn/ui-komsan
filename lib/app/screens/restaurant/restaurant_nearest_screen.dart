import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../widgets/global/page_detail_image.dart';
import '../../widgets/home/place_tag.dart';
import '/app/screens/restaurant/restaurant_map_screen.dart';
import '/app/controllers/res_controller.dart';
import '/app/constants/global_variable.dart';
import '/app/controllers/res_rating_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/subtitle_widget.dart';
import '../../widgets/title_text_widget.dart';
import '../../constants/alert_message.dart';
import '../../controllers/authentication_controller.dart';
import '../../controllers/res_fav_controller.dart';
import '../../models/restaurant_model.dart';

class RestaurantNearestScreen extends StatefulWidget {
  final RestaurantModel restaurant;

  const RestaurantNearestScreen({super.key, required this.restaurant});

  @override
  State<RestaurantNearestScreen> createState() =>
      _RestaurantNearestScreenState();
}

class _RestaurantNearestScreenState extends State<RestaurantNearestScreen> {
  final PageController _imageController = PageController();
  final RestFavController _restFavController = Get.find<RestFavController>();
  final RestRatingController _restRatingController =
      Get.put(RestRatingController());
  final AuthenticationController _checkTokenController =
      Get.put(AuthenticationController());
  final RestaurantController _resController = Get.put(RestaurantController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _restFavController.fetchFavoriteStatus(widget.restaurant.resId!);
      _restRatingController.fetchUserRating(widget.restaurant.resId!);
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
            Get.back(result: true);
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
            const SizedBox(
              height: 8.0,
            ),
            Container(
              margin: const EdgeInsets.only(left: 8.0, right: 8.0),
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
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
                        const SizedBox(
                          height: 4.0,
                        ),
                        SubtitleWidget(
                          label:
                              "Location: ${widget.restaurant.village?.province?.provinceNameen ?? "Unknown"}",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
                        SubtitleWidget(
                          label:
                              "Open time: ${widget.restaurant.openTime} - ${widget.restaurant.closeTime}",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
                        Row(
                          // modify IT-129-Pithak-2024-05-21
                          children: [
                            const SubtitleWidget(
                              label: "Website: ",
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            const SizedBox(
                              width: 4.0,
                            ),
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
                                width: 180,
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
                            const SizedBox(
                              width: 6.0,
                            ),
                            SizedBox(
                              width: 120,
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
                                  }),
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
                    const SizedBox(
                      width: 6.0,
                    ),
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
            const SizedBox(
              height: 8.0,
            ),
            SizedBox(
              height: 200,
              width: double.infinity,
              child: RestaurantMapScreen(
                restaurant: widget.restaurant,
              ),
            ),
            // About label
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
              child: SubtitleWidget(
                label: widget.restaurant.resDes ?? "No description available",
                fontSize: 14,
                fontWeight: FontWeight.w300,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
          ],
        ),
      ),
    );
  }
}
