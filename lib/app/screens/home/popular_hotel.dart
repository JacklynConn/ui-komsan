import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/global/card_horizontal.dart';
import '../../widgets/global/card_vertical.dart';
import '/app/constants/global_variable.dart';
import '/app/controllers/hotel_controller.dart';
import '../hotel/hotel_detail_screen.dart';
import '../../widgets/title_text_widget.dart';

class PopularHotel extends StatelessWidget {
  PopularHotel({super.key});

  final HotelController _hotelController = Get.put(HotelController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: TitleTextWidget(
            label: 'Popular Hotels'.tr,
            fontSize: 18,
            color: Colors.blueAccent,
          ),
          leading: IconButton(
            onPressed: (){
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_rounded,size: 24,),
            color: Colors.blueAccent,
          ),
          actions: [
            Obx(() {
              return IconButton(
                onPressed: () {
                  _hotelController.changeView();
                },
                icon: Icon(
                  _hotelController.showGrid.value
                      ? Icons.view_list_outlined
                      : Icons.grid_view_outlined,
                ),
                color: Colors.blueAccent,
              );
            }),
            const SizedBox(width: 8.0,),
          ],
        ),
        body: Obx(
          () {
            if (_hotelController.isLoading.value &&
                _hotelController.popularHotels.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.blueAccent,
                ),
              );
            } else if (_hotelController.popularHotels.isEmpty) {
              return const Center(
                child: Text('No data found'),
              );
            } else {
              return NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (!_hotelController.isLoading.value &&
                      scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent) {
                    _hotelController.fetchPopularHotels();
                    return true;
                  }
                  return false;
                },
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        const SizedBox(height: 8.0),
                        SizedBox(
                          child: _hotelController.showGrid.value
                              ? GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount:
                                      _hotelController.popularHotels.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.7,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 5,
                                  ),
                                  itemBuilder: (context, index) {
                                    var popHotels = _hotelController.popularHotels[index];
                                   // var avgRating = hotels.averageRating?.toStringAsFixed(1);
                                    return CardVertical(
                                        onTap: () async {
                                          var result  = await Get.to(
                                                  () => HotelDetailScreen(hotel: popHotels),
                                              transition: Transition.rightToLeft
                                          );
                                          if (result == true) {
                                            _hotelController.fetchPopularHotels();
                                          }
                                        },
                                        image: '$hotelImageUrl${popHotels.hotelGallery?.first.image}',
                                        name: popHotels.hotelName ?? 'Unknown',
                                        location: popHotels.village?.province?.provinceNameen ?? 'Unknown',
                                        rating: '${popHotels.averageRating}',
                                        errorWidget: (p0, p1, p2) {
                                          return const Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.blueAccent,
                                            ),
                                          );
                                        },
                                    );
                                  },
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _hotelController.popularHotels.length,
                                  itemBuilder: (context, index) {
                                    var popHotels = _hotelController.popularHotels[index];
                                    return Column(
                                      children: [
                                        CardHorizontal(
                                            onTap: () async {
                                              var result  = await Get.to(
                                                      () => HotelDetailScreen(hotel: popHotels),
                                                  transition: Transition.rightToLeft
                                              );
                                              if (result == true) {
                                                _hotelController.fetchPopularHotels();
                                              }
                                            },
                                            image: '$hotelImageUrl${popHotels.hotelGallery?.first.image}',
                                            name: popHotels.hotelName ?? 'Unknown',
                                            location: popHotels.village?.province?.provinceNameen ?? 'Unknown',
                                            rating: '${popHotels.averageRating}',
                                            errorWidget: (p0, p1, p2) {
                                              return const Center(
                                                child: CircularProgressIndicator(
                                                  color: Colors.blueAccent,
                                                ),
                                              );
                                            },
                                        ),
                                        const SizedBox(height: 8.0,),
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
          },
        ),
      ),
    );
  }
}
