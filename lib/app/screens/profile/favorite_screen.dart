import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../widgets/favorite/favorite_card.dart';
import '../../widgets/favorite/favorite_tab.dart';
import '../../widgets/subtitle_widget.dart';
import '../../constants/global_variable.dart';
import '../../controllers/hotel_controller.dart';
import '../../controllers/hotel_fav_controller.dart';
import '../../controllers/place_fav_controller.dart';
import '../../controllers/res_controller.dart';
import '../../controllers/res_fav_controller.dart';
import '../hotel/hotel_detail_screen.dart';
import '../place/place_detail_screen.dart';
import '../restaurant/restaurant_detail_screen.dart';
import '../../widgets/title_text_widget.dart';


class FavoriteScreen extends StatefulWidget {

  FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final PlaceFavController _placeFavController = Get.put(PlaceFavController());

  final HotelFavController _hotelFavController = Get.put(HotelFavController());

  final RestFavController _restFavController = Get.put(RestFavController());

  final HotelController _hotelController = Get.put(HotelController());

  final RestaurantController _restaurantController = Get.put(RestaurantController());

  final storage = GetStorage();

  @override
  void initState() {
    super.initState();
    _placeFavController.fetchPlaceFav();
    _hotelFavController.fetchHotelFav();
    _restFavController.fetchResFav();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TitleTextWidget(
          label: "Favorite".tr,
          fontSize: 20,
          color: Colors.blueAccent,
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
            _hotelController.filteredHotels();
            _restaurantController.fetchRestaurant();
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            size: 24,
            color: Colors.blueAccent,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Expanded(
                child: DefaultTabController(
                    length: 3,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            color: Colors.transparent,
                            child: TabBar(
                                isScrollable: true,
                                labelColor: Colors.blueAccent,
                                dividerColor: Colors.transparent,
                                labelStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'GeneralFont'),
                                indicator: UnderlineTabIndicator(
                                  borderSide: const BorderSide(
                                    width: 3,
                                    color: Colors.blueAccent,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                tabs: [
                                  Tab(
                                      child: FavoriteTab(
                                    tabLabel: "Places".tr,
                                  )),
                                  Tab(
                                      child: FavoriteTab(
                                    tabLabel: "Hotels".tr,
                                  )),
                                  Tab(
                                      child: FavoriteTab(
                                    tabLabel: "Restaurants".tr,
                                  )),
                                ]),
                          ),
                        ),
                        const SizedBox(height: 4.0,),
                        Expanded(
                            flex: 11,
                            child: SizedBox(
                              width: double.infinity,
                              height: double.infinity,
                              child: TabBarView(
                                children: [
                                  Obx(() {
                                    if (_placeFavController.isLoading.value){
                                          return const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.blueAccent,
                                          strokeWidth: 3,
                                        ),
                                      );
                                    } else if (_placeFavController.favPlace.isEmpty){
                                      return Center(
                                        child: SubtitleWidget(
                                          label: "Your favorite place is empty".tr,
                                          fontSize: 14,
                                        ),
                                      );
                                    } return Container(
                                      alignment: Alignment.center,
                                      color: Colors.transparent,
                                      child: ListView.builder(
                                        physics:
                                        const BouncingScrollPhysics(),
                                        itemCount: _placeFavController.favPlace.length,
                                        itemBuilder: (context, index) {
                                          var favPlaces = _placeFavController.favPlace[index];
                                          var place = favPlaces.place!;
                                          return Column(
                                            children: [
                                              FavoriteCard(
                                                onTap: () async {
                                                  var result = await Get.to(() =>
                                                      PlaceDetailScreen(place: place,));
                                                  if (result == true) {
                                                    _placeFavController.fetchPlaceFav();
                                                  }
                                                },
                                                image: '$placeImageUrl${place.placeGallery?.first.image ?? ''}',
                                                name: place.placeName ?? "Unknown",
                                                location: place.village?.province?.provinceNameen ?? "unknown",
                                                rating: place.averageRating?.toString() ?? "Not rated yet",
                                                onPress: () {
                                                  _placeFavController.toggleFavorite(place.placeId!);
                                                  _placeFavController.favPlace.removeAt(index);
                                                  setState(() {
                                                    _placeFavController.favPlace = _placeFavController.favPlace;
                                                  });
                                                },
                                              ),
                                              const SizedBox(height: 8.0,),
                                            ],
                                          );
                                        },
                                      ),
                                    );
                                  }),
                                  Obx(() {
                                    if (_hotelFavController.isLoading.value){
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.blueAccent,
                                          strokeWidth: 3,
                                        ),
                                      );
                                    } else if (_hotelFavController.favHotel.isEmpty){
                                      return Center(
                                        child: SubtitleWidget(
                                          label: 'Your favorite hotel is empty'.tr,
                                          fontSize: 14,
                                        ),
                                      );
                                    }
                                    return Container(
                                            alignment: Alignment.center,
                                            color: Colors.transparent,
                                            child: ListView.builder(
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              itemCount: _hotelFavController
                                                  .favHotel.length,
                                              itemBuilder: (context, index) {
                                                var favHotels =
                                                    _hotelFavController
                                                        .favHotel[index];
                                                return Column(
                                                  children: [
                                                    FavoriteCard(
                                                      onTap: () async {
                                                        var result = await Get.to(() =>
                                                                HotelDetailScreen(hotel: favHotels.hotel!,));
                                                        if (result == true) {
                                                          _hotelFavController.fetchHotelFav();
                                                        }},
                                                      image: '$hotelImageUrl${favHotels.hotel?.hotelGallery?.first.image ?? ''}',
                                                      name: favHotels.hotel?.hotelName ?? "Unknown",
                                                      location: favHotels.hotel?.village?.province?.provinceNameen ?? "unknown",
                                                      rating: favHotels.hotel?.averageRating?.toString() ?? "Not rated yet",
                                                      onPress: () {
                                                        _hotelFavController.toggleFavorite(favHotels.hotelId!);
                                                        _hotelFavController.favHotel.removeAt(index);
                                                        setState(() {
                                                          _hotelFavController.favHotel = _hotelFavController.favHotel;
                                                        });
                                                      },
                                                    ),
                                                    const SizedBox(height: 8.0,),
                                                  ],
                                                );
                                              },
                                            ),
                                          );
                                  }),
                                  Obx(() {
                                    if (_restFavController.isLoading.value){
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.blueAccent,
                                          strokeWidth: 3,
                                        ),
                                      );
                                    } else if (_restFavController.favRes.isEmpty) {
                                      return Center(
                                        child: SubtitleWidget(
                                          label: 'Your favorite restaurant is empty'.tr,
                                          fontSize: 14,
                                        ),
                                      );
                                    } return Container(
                                            alignment: Alignment.center,
                                            color: Colors.transparent,
                                            child: ListView.builder(
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              itemCount: _restFavController.favRes.length,
                                              itemBuilder: (context, index) {
                                                var favRes = _restFavController.favRes[index];
                                                return Column(
                                                  children: [
                                                    FavoriteCard(
                                                      onTap: () async {
                                                        var result = await Get.to(() =>
                                                                RestaurantDetailScreen(
                                                                  restaurant: favRes.restaurant!,));
                                                        if (result == true) {
                                                          _restFavController.fetchResFav();
                                                        }},
                                                      image: '$resImageUrl${favRes.restaurant?.restaurantGallery?.first.image ?? ''}',
                                                      name: favRes.restaurant?.resName ?? "Unknown",
                                                      location: favRes.restaurant?.village?.province?.provinceNameen ?? "unknown",
                                                      rating: favRes.restaurant?.averageRating?.toString() ?? "Not rated yet",
                                                      onPress: () {
                                                        _restFavController.toggleFavorite(favRes.resId!);
                                                        _restFavController.favRes.removeAt(index);
                                                        setState(() {
                                                          _restFavController.favRes = _restFavController.favRes;
                                                        });
                                                      },
                                                    ),
                                                    const SizedBox(
                                                      height: 8.0,
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          );
                                  }),
                                ],
                              ),
                            )),
                      ],
                    )))
          ],
        ),
      ),
    );
  }
}
