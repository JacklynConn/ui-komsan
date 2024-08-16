
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/global_variable.dart';
import '../../controllers/res_controller.dart';
import '../../widgets/global/card_horizontal.dart';
import '../../widgets/global/card_vertical.dart';
import '../restaurant/restaurant_detail_screen.dart';
import '../../widgets/title_text_widget.dart';

class PopularRestaurant extends StatelessWidget {
  PopularRestaurant({super.key});

  final RestaurantController _resController = Get.put(RestaurantController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: TitleTextWidget(
            label: 'Popular Restaurants'.tr,
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
                  _resController.changeView();
                },
                icon: Icon(
                  _resController.showGrid.value
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
            if (_resController.isLoading.value &&
                _resController.popularRes.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.blueAccent,
                ),
              );
            } else if (_resController.popularRes.isEmpty) {
              return const Center(
                child: Text('No data found'),
              );
            } else {
              return NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (!_resController.isLoading.value &&
                      scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent) {
                    _resController.fetchPopularRes();
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
                          child: _resController.showGrid.value
                              ? GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount:
                            _resController.popularRes.length,
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.7,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                            ),
                            itemBuilder: (context, index) {
                              var popRes = _resController.popularRes[index];
                              // var avgRating = hotels.averageRating?.toStringAsFixed(1);
                              return CardVertical(
                                  onTap: () async {
                                    var result = await
                                    Get.to(() => RestaurantDetailScreen(restaurant: popRes),
                                        transition: Transition.rightToLeft
                                    );
                                    if (result == true) {
                                      _resController.fetchPopularRes();
                                    }
                                  },
                                  image: '$resImageUrl${popRes.restaurantGallery?.first.image}',
                                  name: popRes.resName ?? 'Unknown',
                                  location: popRes.village?.province?.provinceNameen ?? 'Unknown',
                                  rating: '${popRes.averageRating}',
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
                            itemCount: _resController.popularRes.length ,
                            itemBuilder: (context, index) {
                              var popRes = _resController.popularRes[index];
                              return Column(
                                children: [
                                  CardHorizontal(
                                      onTap: () async {
                                        var result = await
                                        Get.to(() => RestaurantDetailScreen(restaurant: popRes),
                                            transition: Transition.rightToLeft
                                        );
                                        if (result == true) {
                                          _resController.fetchPopularRes();
                                        }
                                      },
                                      image: '$resImageUrl${popRes.restaurantGallery?.first.image}',
                                      name: popRes.resName ?? 'Unknown',
                                      location: popRes.village?.province?.provinceNameen ?? 'Unknown',
                                      rating: '${popRes.averageRating}',
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
