import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../widgets/global/page_detail_image.dart';
import '../../widgets/home/place_tag.dart';
import '/app/screens/auth/login_screen.dart';
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

class HotelNearestScreen extends StatefulWidget {
  const HotelNearestScreen({super.key, required this.hotel});

  final HotelModel hotel;

  @override
  State<HotelNearestScreen> createState() => _HotelNearestScreenState();
}

class _HotelNearestScreenState extends State<HotelNearestScreen> {
  final PageController _imageController = PageController();
  final HotelFavController _hotelFavController = Get.find<HotelFavController>();
  final HotelRatingController _hotelRatingController =
      Get.put(HotelRatingController());
  final AuthenticationController _checkTokenController =
      Get.put(AuthenticationController());
  final HotelController hotelController = Get.put(HotelController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _hotelFavController.fetchFavoriteStatus(widget.hotel.hotelId!);
      _hotelRatingController.fetchUserRating(widget.hotel.hotelId!);
    });
  }

  void _showLoginAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const TitleTextWidget(
            label: "Login Required",
            fontSize: 20,
          ),
          content: const SubtitleWidget(
            label: "You need to log in to use this function.",
            fontSize: 14,
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          actions: <Widget>[
            TextButton(
              child: SubtitleWidget(
                label: "Cancel",
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const SubtitleWidget(
                label: "Login",
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Get.to(() => LoginScreen());
              },
            ),
          ],
        );
      },
    );
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
        child: ListView(physics: const BouncingScrollPhysics(), children: [
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
                Column(
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
                    ),
                    const SizedBox(
                      height: 4.0,
                    ),
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
                                      content: Text('Could not launch $url')),
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
                        const SizedBox(
                          width: 4.0,
                        ),
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
                Obx(() {
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
                            } else {
                              _showLoginAlert(context);
                            }
                          },
                          icon: _hotelFavController.isFavorite.value
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
                    initialRating:
                        _hotelRatingController.hotelRatingModel.value.rating ??
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
                      } else {
                        _showLoginAlert(context);
                      }
                    },
                  ),
                  const SizedBox(
                    width: 4.0,
                  ),
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
          const SizedBox(
            height: 8.0,
          ),
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
            child: Text(
              widget.hotel.hotelDes ?? 'No description available',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
        ]),
      ),
    );
  }
}
