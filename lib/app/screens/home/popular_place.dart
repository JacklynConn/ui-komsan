import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/global_variable.dart';
import '../../controllers/place_controller.dart';
import '../../widgets/global/card_horizontal.dart';
import '../../widgets/global/card_vertical.dart';
import '../place/place_detail_screen.dart';
import '../../widgets/title_text_widget.dart';

class PopularPlaces extends StatelessWidget {
  PopularPlaces({super.key});

  final _placeController = Get.put(PlaceController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: TitleTextWidget(
            label: 'Popular Places'.tr,
            fontSize: 18,
            color: Colors.blueAccent,
          ),
          leading: IconButton(
            onPressed: (){
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_rounded,size: 20,),
            color: Colors.blueAccent,
          ),
          actions: [
            Obx(() {
              return IconButton(
                onPressed: () {
                  _placeController.changeView();
                },
                icon: Icon(
                  _placeController.showGrid.value
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
            if (_placeController.isLoading.value &&
                _placeController.popularPlace.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.blueAccent,
                ),
              );
            } else if (_placeController.popularPlace.isEmpty) {
              return const Center(
                child: Text('No data found'),
              );
            } else {
              return NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (!_placeController.isLoading.value &&
                      scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent) {
                    _placeController.fetchPopularPlace();
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
                          child: _placeController.showGrid.value
                              ? GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _placeController.popularPlace.length,
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.7,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                            ),
                            itemBuilder: (context, index) {
                              var popPlace = _placeController.popularPlace[index];
                              return CardVertical(
                                onTap: (){
                                  Get.to(() => PlaceDetailScreen(place: popPlace),
                                      transition: Transition.rightToLeft
                                  );
                                },
                                image: '$placeImageUrl${popPlace.placeGallery?.first.image}',
                                name: popPlace.placeName ?? 'Unknown',
                                location: popPlace.village?.province?.provinceNameen ?? 'Unknown',
                                rating: '${popPlace.averageRating}',
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
                            itemCount: _placeController.popularPlace.length,
                            itemBuilder: (context, index) {
                              var popPlace = _placeController.popularPlace[index];
                              return Column(
                                children: [
                                  CardHorizontal(
                                    onTap: (){
                                      Get.to(() => PlaceDetailScreen(place: popPlace),
                                          transition: Transition.rightToLeft
                                      );
                                    },
                                    image: '$placeImageUrl${popPlace.placeGallery?.first.image}',
                                    name: popPlace.placeName ?? 'Unknown',
                                    location: popPlace.village?.province?.provinceNameen ?? 'Unknown',
                                    rating: '${popPlace.averageRating}',
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
