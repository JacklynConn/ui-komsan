import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../widgets/global/page_detail_image.dart';
import '../../widgets/home/place_tag.dart';
import '/app/constants/alert_message.dart';
import '/app/screens/place/place_map_screen.dart';
import '/app/constants/global_variable.dart';
import '/app/controllers/place_fav_controller.dart';
import '/app/controllers/place_rating_controller.dart';
import '../../widgets/subtitle_widget.dart';
import '../../widgets/title_text_widget.dart';
import '../../controllers/authentication_controller.dart';
import '../../models/place_model.dart';

class PlaceNearestScreen extends StatefulWidget {
  final PlaceModel place;

  const PlaceNearestScreen({super.key, required this.place});

  @override
  State<PlaceNearestScreen> createState() => _PlaceNearestScreenState();
}

class _PlaceNearestScreenState extends State<PlaceNearestScreen> {
  final PageController _imageController = PageController();
  final PlaceFavController _placeFavController = Get.find<PlaceFavController>();
  final PlaceRatingController _placeRatingController =
      Get.put(PlaceRatingController());
  final AuthenticationController _checkTokenController =
      Get.put(AuthenticationController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _placeFavController.fetchFavoriteStatus(widget.place.placeId!);
      _placeRatingController.fetchUserRating(widget.place.placeId!);
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
              height: 260,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: widget.place.placeGallery != null &&
                      widget.place.placeGallery != []
                  ? Stack(
                      children: [
                        PageView.builder(
                            controller: _imageController,
                            itemCount: (widget.place.placeGallery != null)
                                ? widget.place.placeGallery!.length
                                : 0,
                            itemBuilder: (context, index) {
                              return PageDetailImage(
                                imageUrl:
                                    '$placeImageUrl${widget.place.placeGallery![index].image ?? ''}',
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
                              count: widget.place.placeGallery!.length ?? 0,
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
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleTextWidget(
                        label: widget.place.placeName ?? '',
                        fontSize: 16,
                      ),
                      const SizedBox(
                        width: 4.0,
                      ),
                      SubtitleWidget(
                        label:
                            "Location: ${widget.place.village?.province?.provinceNameen ?? 'Unknown'}",
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(
                        width: 4.0,
                      ),
                      Row(
                        children: [
                          // Container for Tag01
                          const SubtitleWidget(
                            label: "Type:",
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          const SizedBox(
                            width: 4.0,
                          ),
                          SizedBox(
                            width: 200,
                            height: 40,
                            child: ListView.builder(
                                itemCount: widget.place.placeTypes?.length,
                                physics: const ClampingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      PlaceTag(
                                        tag: widget.place.placeTypes?[index]
                                                .placeTypeName ??
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
                  Obx(() {
                    return _placeFavController.isLoading.value
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.blueAccent,
                              strokeWidth: 2,
                            ),
                          )
                        : IconButton(
                            onPressed: () {
                              if (_checkTokenController.hasToken()) {
                                _placeFavController
                                    .toggleFavorite(widget.place.placeId!);
                              } else {
                                alertMessage(context);
                              }
                            },
                            icon: _placeFavController.isFavorite.value
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
                    _placeRatingController.placeRatingModel.value.rating != null
                        ? _placeRatingController.placeRatingModel.value.rating
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
                      initialRating: _placeRatingController
                              .placeRatingModel.value.rating ??
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
                          _placeRatingController.userRating(
                              widget.place.placeId!, rating);
                        } else {
                          alertMessage(context);
                        }
                      },
                    ),
                    const SizedBox(
                      width: 4.0,
                    ),
                    Expanded(
                      child: SubtitleWidget(
                        label: _placeRatingController
                                    .placeRatingModel.value.rating !=
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
            const SizedBox(
              height: 8.0,
            ),
            SizedBox(
              height: 200,
              width: double.infinity,
              child: PlaceMapScreen(
                place: widget.place,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(8.0),
              color: Colors.transparent,
              child: const Text(
                "About This Place",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 8.0, right: 8.0),
              alignment: Alignment.center,
              color: Colors.transparent,
              child: SubtitleWidget(
                label: widget.place.placeDes ?? 'No description available',
                fontSize: 14,
                fontWeight: FontWeight.w300,
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
