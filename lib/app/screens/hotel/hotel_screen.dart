
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/global/card_horizontal.dart';
import '../../widgets/global/card_vertical.dart';
import '/app/controllers/hotel_category_controller.dart';
import '/app/controllers/province_controller.dart';
import '../../constants/global_variable.dart';
import '../../controllers/hotel_controller.dart';
import '../../widgets/subtitle_widget.dart';
import '../../widgets/title_text_widget.dart';
import '../hotel/hotel_detail_screen.dart';

class HotelScreen extends StatelessWidget {
  HotelScreen({super.key});

  final _hotelController = Get.put(HotelController());
  final _provController = Get.put(ProvinceController());
  final _catController = Get.put(HotelCatController());
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  void _filterSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(height: 10,),
              Flexible(
                child: ListView(
                  children: [
                    const TitleTextWidget(
                      label: 'Select Type',
                      fontSize: 15,
                    ),
                    const SizedBox(height: 8.0),
                    Obx((){
                      if (_catController.isLoading.value){
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.blueAccent,
                          ),
                        );
                      } else {
                        return  Wrap(
                          spacing: 8.0,
                          alignment: WrapAlignment.center,
                          children: _catController.hotelCategory.map((type) {
                            return Obx(() {
                              return ChoiceChip(
                                label: Text(type.catHotelName ?? 'Unknown'),
                                selected: _hotelController.selectedType.value == type.catHotelName!,
                                onSelected: (bool selected) {
                                  _hotelController.updateSelectedType(type.catHotelName!);
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: const BorderSide(
                                      color: Colors.blueAccent,
                                      width: 1,
                                    )
                                ),
                                selectedColor: Colors.blueAccent,
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                showCheckmark: false,
                                labelStyle: TextStyle(
                                  color: _hotelController.selectedType.value == type.catHotelName
                                      ? Colors.white
                                      : Theme.of(context).colorScheme.inversePrimary,
                                  fontFamily: 'GeneralFont'
                                ),
                              );
                            });
                          }).toList(),
                        );
                      }
                    }),
                    const SizedBox(height: 10,),
                    const TitleTextWidget(
                      label: 'Select Province',
                      fontSize: 15,
                    ),
                    const SizedBox(height: 8.0),
                    Obx(() {
                      if (_provController.isLoading.value) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.blueAccent,
                          ),
                        );
                      } else {
                        return  Wrap(
                          spacing: 8.0,
                          alignment: WrapAlignment.center,
                          children: _provController.provinces.map((province) {
                            return Obx(() {
                              return ChoiceChip(
                                label: Text(province.provinceNameen ?? 'Unknown'),
                                selected: _hotelController.selectedProvince.value == province.provinceNameen!,
                                onSelected: (bool selected) {
                                  _hotelController.updateSelectedProvince(province.provinceNameen!);
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: const BorderSide(
                                      color: Colors.blueAccent,
                                      width: 1,
                                    )
                                ),
                                selectedColor: Colors.blueAccent,
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                showCheckmark: false,
                                labelStyle: TextStyle(
                                  color: _hotelController.selectedProvince.value == province.provinceNameen
                                      ? Colors.white
                                      : Theme.of(context).colorScheme.inversePrimary,
                                  fontFamily: 'GeneralFont'
                                ),
                              );
                            });
                          }).toList(),
                        );
                      }
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 14, right: 14,
                          top: 6, bottom: 6 ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blueAccent, width: 1.5),
                      ),
                      child: SubtitleWidget(
                        label: 'Cancel',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 14, right: 14,
                          top: 6, bottom: 6 ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.redAccent,
                      ),
                      child: const SubtitleWidget(
                        label: 'Reset',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      _hotelController.clearProvinceSelection();
                    },
                  ),
                  // TextButton(
                  //   child: Container(
                  //     padding: const EdgeInsets.only(
                  //         left: 14, right: 14,
                  //         top: 8, bottom: 8 ),
                  //     decoration: BoxDecoration(
                  //       color: Colors.blueAccent,
                  //       borderRadius: BorderRadius.circular(8),
                  //     ),
                  //     child: const SubtitleWidget(
                  //       label: 'Ok',
                  //       fontSize: 14,
                  //       fontWeight: FontWeight.bold,
                  //       color: Colors.white,
                  //     ),
                  //   ),
                  //   onPressed: () {
                  //     Navigator.of(context).pop();
                  //   },
                  // ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: TitleTextWidget(
            label: 'Hotel'.tr,
            fontSize: 20,
            color: Colors.blueAccent,
          ),
          centerTitle: true,
        ),
        body: Obx(() {
          if (_hotelController.isLoading.value) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.blueAccent,
            ));
          } else {
            return RefreshIndicator(
              backgroundColor: Theme.of(context).colorScheme.primary,
              color: Colors.blueAccent,
              onRefresh: () async {
                _hotelController.fetchHotel();
                const CircularProgressIndicator(
                  color: Colors.blueAccent,
                );
              },
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      TextField(
                        onChanged: (query) {
                          _hotelController.updateSearchQuery(query);
                        },
                        controller: _searchController,
                        focusNode: _focusNode,
                        cursorColor: Colors.blueAccent,
                        style: const TextStyle(
                          fontFamily: 'GeneralFont',
                          color: Colors.blueAccent,
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search'.tr,
                          focusColor: Colors.blueAccent,
                          hintStyle: const TextStyle(
                              fontSize: 14,
                          ),
                          prefixIcon: _focusNode.hasFocus
                              ? null
                              : const Icon(
                                  Icons.search_rounded,
                                  size: 20,
                                ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              width: 1.5,
                              color: Theme.of(context).colorScheme.inversePrimary
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              width: 1.5,
                              color: Colors.blueAccent)
                          ),
                          isDense: true,
                          suffixIcon: _focusNode.hasFocus
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.clear_rounded,
                                    size: 20,
                                    color: Colors.blueAccent,),
                                  onPressed: () {
                                    _searchController.clear();
                                    _hotelController.updateSearchQuery('');
                                  },
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SubtitleWidget(
                                label: 'Recommendation'.tr,
                                color: Colors.blueAccent,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              // IconButton(
                              //   onPressed: () {},
                              //   icon: const Icon(
                              //     Icons.keyboard_arrow_down_outlined,
                              //     color: Colors.blueAccent,
                              //     size: 24,
                              //   ),
                              // ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  _filterSelection(context);
                                },
                                icon: const Icon(Icons.sort_outlined,size: 24,),
                                color: Colors.blueAccent,
                              ),
                              IconButton(
                                onPressed: () {
                                  _hotelController.changeView();
                                },
                                icon: Icon(
                                  _hotelController.showGrid.value
                                      ? Icons.view_list_outlined
                                      : Icons.grid_view_outlined,
                                  color: Colors.blueAccent,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      if (_hotelController.filteredHotels.isEmpty)
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 40,),
                              Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(context).colorScheme.background,
                                        offset: const Offset(2, 2),
                                        spreadRadius: 0.5,
                                        blurRadius: 2.0,
                                      ),
                                    ]),
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
                                  label: "There is no hotel found.",
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
                      else
                        SizedBox(
                          child: _hotelController.showGrid.value
                              ? GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount:
                                      _hotelController.filteredHotels.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.7,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 2,
                                  ),
                                  itemBuilder: (context, index) {
                                    var hotel =
                                        _hotelController.filteredHotels[index];
                                    var avgRating = hotel.averageRating != null
                                        ? hotel.averageRating!.toString()
                                        : 'Not rated yet';
                                    return CardVertical(
                                      // modify IT-129-Pithak-2024-05-21
                                      onTap: () async {
                                        var result = await Get.to(
                                          () => HotelDetailScreen(hotel: hotel),
                                          transition: Transition.rightToLeft,
                                        );
                                        if (result == true) {
                                          _hotelController.fetchHotel();
                                        }
                                      },
                                      errorWidget: (p0, p1, p2) {
                                        return const Center(
                                            child: CircularProgressIndicator(
                                          color: Colors.blueAccent,
                                        ));
                                      },
                                      image:
                                          '$hotelImageUrl${hotel.hotelGallery?.first.image}',
                                      name: hotel.hotelName ?? 'unknown',
                                      location: hotel.village?.province
                                              ?.provinceNameen ??
                                          'Unknown',
                                      rating: avgRating,
                                    );
                                  },
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount:
                                      _hotelController.filteredHotels.length,
                                  itemBuilder: (context, index) {
                                    var hotel =
                                        _hotelController.filteredHotels[index];
                                    var avgRating = hotel.averageRating != null
                                        ? hotel.averageRating!.toString()
                                        : 'Not rated yet';
                                    return Column(
                                      // modify IT-129-Pithak-2024-05-21
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        CardHorizontal(
                                          onTap: () async {
                                            var result = await Get.to(
                                              () => HotelDetailScreen(
                                                hotel: hotel,
                                              ),
                                              transition:
                                                  Transition.rightToLeft,
                                            );
                                            if (result == true) {
                                              _hotelController.fetchHotel();
                                            }
                                          },
                                          errorWidget: (p0, p1, p2) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator(
                                              color: Colors.blueAccent,
                                            ));
                                          },
                                          image:
                                              "$hotelImageUrl${hotel.hotelGallery?.first.image}",
                                          name: hotel.hotelName ?? 'unknown',
                                          location: hotel.village?.province
                                                  ?.provinceNameen ??
                                              'Unknown',
                                          rating: avgRating,
                                        ),
                                        const SizedBox(
                                          height: 8.0,
                                        )
                                      ],
                                    );
                                  },
                                ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }
        }),
      ),
    );
  }
}
