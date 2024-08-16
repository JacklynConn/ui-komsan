import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/search_place_controller.dart';
import '../../widgets/global/card_horizontal.dart';
import '../../widgets/home/place_card_vertical.dart';
import '../../widgets/home/place_tag.dart';
import '/app/constants/global_variable.dart';
import '/app/models/province_model.dart';
import '/app/screens/place/place_detail_screen.dart';
import '../../widgets/title_text_widget.dart';
import '../../widgets/subtitle_widget.dart';
import '../../controllers/place_in_province_controller.dart';

class PlaceInProvinceScreen extends StatefulWidget {
  final ProvinceModel province;

  const PlaceInProvinceScreen({super.key, required this.province});

  @override
  _PlaceInProvinceScreenState createState() => _PlaceInProvinceScreenState();
}

class _PlaceInProvinceScreenState extends State<PlaceInProvinceScreen> {
  final _placeInProvinceController = Get.put(ControllerPlaceInProvince());
  final _categoryPlaceController = Get.put(CategoryPlaceController());

  @override
  void initState() {
    super.initState();
    _placeInProvinceController.provinceId.value =
        widget.province.provinceCode ?? 0;
    _placeInProvinceController.fetchPlace(_categoryPlaceController.catePlaces);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TitleTextWidget(
          label: widget.province.provinceNameen ?? '',
          color: Colors.blueAccent,
          fontSize: 20,
        ),
      ),
      body: Obx(() {
        if (_placeInProvinceController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.blueAccent,
            ),
          );
        }

        // Sort places by averageRating in descending order
        _placeInProvinceController.places.sort((a, b) {
          if (a.averageRating == null && b.averageRating == null) {
            return 0;
          } else if (a.averageRating == null) {
            return 1; // nulls last
          } else if (b.averageRating == null) {
            return -1; // nulls last
          } else {
            return b.averageRating!.compareTo(a.averageRating!);
          }
        });

        return RefreshIndicator(
          onRefresh: () async {
            _placeInProvinceController.fetchPlace(_categoryPlaceController.catePlaces);
          },
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SubtitleWidget(
                        label: 'Recommended place'.tr,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                      Row(
                        children: [
                          if (_categoryPlaceController
                              .catePlaces.isNotEmpty) ...[
                            IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(
                                      builder: (context, setState) {
                                        return Container(
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(8.0),
                                            ),
                                          ),
                                          padding: const EdgeInsets.all(16.0),
                                          width: double.infinity,
                                          height: 500,
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Row(
                                                children: [
                                                  Icon(Icons.filter_list,),
                                                  SizedBox(width: 8.0,),
                                                  TitleTextWidget(
                                                    label: "Filter",
                                                    fontSize: 18,
                                                  )
                                                ],
                                              ),
                                              const SizedBox(height: 16.0),
                                              const TitleTextWidget(
                                                label: 'Select Tags',
                                                fontSize: 15,
                                              ),
                                              const SizedBox(height: 8.0),
                                              Expanded(
                                                child: SingleChildScrollView(
                                                  child: Wrap(
                                                    spacing: 16.0,
                                                    children: [
                                                      for (int i = 0;
                                                      i <
                                                          _categoryPlaceController
                                                              .catePlaces
                                                              .length;
                                                      i++)
                                                        TextButton(
                                                          style:
                                                          TextButton.styleFrom(
                                                            backgroundColor:
                                                            _categoryPlaceController
                                                                .catePlaces[
                                                            i]
                                                                .isSelected
                                                                ? Colors.blue
                                                                : Colors.white,
                                                            shape:
                                                            const RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                      8)),
                                                            ),
                                                            side: BorderSide(
                                                              color: _categoryPlaceController
                                                                  .catePlaces[i]
                                                                  .isSelected
                                                                  ? Colors.blue
                                                                  : Colors
                                                                  .blue,
                                                              width: 1.0,
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            setState(() {
                                                              _categoryPlaceController
                                                                  .catePlaces[i]
                                                                  .isSelected =
                                                              !_categoryPlaceController
                                                                  .catePlaces[i]
                                                                  .isSelected;
                                                            });
                                                          },
                                                          child: Text(
                                                            _categoryPlaceController
                                                                .catePlaces[i]
                                                                .catPlaceName,
                                                            style: const TextStyle(
                                                                color:
                                                                Colors.black),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 24.0),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.end,
                                                children: [
                                                  TextButton(
                                                    style: TextButton.styleFrom(
                                                      backgroundColor:
                                                      Colors.blueAccent,
                                                      shape:
                                                      const RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8)),
                                                        side: BorderSide(
                                                          color:
                                                          Colors.blueAccent,
                                                          width: 4.0,
                                                        ),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      for (var element
                                                      in _categoryPlaceController
                                                          .catePlaces) {
                                                        element.isSelected =
                                                        false;
                                                      }
                                                      setState(() {});
                                                    },
                                                    child: const Text('Reset'),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ).then((_) {
                                  List<int> placeCateIds = [];
                                  for (var element
                                  in _categoryPlaceController.catePlaces) {
                                    if (element.isSelected) {
                                      placeCateIds.add(element.catPlaceId);
                                    }
                                  }
                                  _placeInProvinceController
                                      .placeTypeIds.value = placeCateIds;
                                  _placeInProvinceController.fetchPlace(_categoryPlaceController.catePlaces);
                                });
                              },
                              icon: const Icon(
                                Icons.filter_list,
                                color: Colors.blueAccent,
                              ),
                            ),
                            const SizedBox(width: 4.0),
                          ],
                          IconButton(
                            onPressed: () {
                              _placeInProvinceController.changeView();
                            },
                            icon: Icon(
                              _placeInProvinceController.showGrid.value
                                  ? Icons.view_list_outlined
                                  : Icons.grid_view_outlined,
                              size: 20,
                            ),
                            color: Colors.blueAccent,
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (_placeInProvinceController.places.isEmpty) ...[
                    SizedBox(height: 150),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                  Theme.of(context).colorScheme.background,
                                  offset: const Offset(2, 2),
                                  spreadRadius: 0.5,
                                  blurRadius: 2.0,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                "assets/images/sorry.gif",
                                width: 140,
                                height: 140,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          const SizedBox(
                            width: 320,
                            child: SubtitleWidget(
                              label: "No data for this province at the moment.",
                              fontSize: 14,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    )
                  ] else ...[
                    const SizedBox(height: 10),
                    SizedBox(
                      child: _placeInProvinceController.showGrid.value
                          ? GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                        _placeInProvinceController.places.length,
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 2,
                        ),
                        itemBuilder: (context, index) {
                          var place =
                          _placeInProvinceController.places[index];
                          var avgRating = place.averageRating != null
                              ? place.averageRating.toString()
                              : 'Not rated yet';
                          return PlaceCardVertical(
                            onTap: () async {
                              var result = await Get.to(
                                      () => PlaceDetailScreen(
                                    place: place,
                                  ),
                                  transition: Transition.rightToLeft);
                              if (result == true) {
                                _placeInProvinceController.fetchPlace(_categoryPlaceController.catePlaces);
                              }
                            },
                            image:
                            '$placeImageUrl${place.placeGallery?.first.image ?? 'unknown'}',
                            name: place.placeName ?? 'unknown',
                            location:
                            place.village?.villageNameen ?? 'Unknown',
                            rating: avgRating,
                            child: ListView.builder(
                              itemCount: place.placeTypes?.length ?? 0,
                              physics: const ClampingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Row(
                                  children: [
                                    PlaceTag(
                                        tag: place.placeTypes?[index]
                                            .placeTypeName ??
                                            'Unknown'),
                                    const SizedBox(width: 8.0),
                                  ],
                                );
                              },
                            ),
                          );
                        },
                      )
                          : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                        _placeInProvinceController.places.length,
                        itemBuilder: (context, index) {
                          var place =
                          _placeInProvinceController.places[index];
                          var avgRating = place.averageRating != null
                              ? place.averageRating.toString()
                              : 'Not rated yet';
                          return Column(
                            children: [
                              CardHorizontal(
                                onTap: () async {
                                  var result = await Get.to(
                                          () => PlaceDetailScreen(
                                        place: place,
                                      ),
                                      transition: Transition.rightToLeft);
                                  if (result == true) {
                                    _placeInProvinceController
                                        .fetchPlace(_categoryPlaceController.catePlaces);
                                  }
                                },
                                image:
                                '$placeImageUrl${place.placeGallery?.first.image ?? 'unknown'}',
                                name: place.placeName ?? 'unknown',
                                location: place.village?.villageNameen ??
                                    'Unknown',
                                rating: avgRating,
                                errorWidget: (p0, p1, p2) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.blueAccent,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 8.0),
                            ],
                          );
                        },
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
