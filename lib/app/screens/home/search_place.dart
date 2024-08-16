import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/global/card_horizontal.dart';
import '../../widgets/subtitle_widget.dart';
import '../../widgets/title_text_widget.dart';
import '../../constants/global_variable.dart';
import '../../controllers/search_place_controller.dart';
import '../../models/place_model.dart';
import '../place/place_detail_screen.dart';

class SearchPlaceDelegate extends SearchDelegate<String> {
  final SearchPlaceController _searchController = Get.put(SearchPlaceController());
  final CategoryPlaceController _categoryPlaceController = Get.put(CategoryPlaceController());

  // Fetch places based on the search word
  void _getSearchPlace(String word) async {
    _searchController.text.value = word;
    _searchController.places.clear(); // Clear previous search results
    await _searchController.fetchPlaces(_categoryPlaceController.catePlaces);
  }

  // Reset all filter selections
  void _resetFilters() {
    for (var element in _categoryPlaceController.catePlaces) {
      element.isSelected = false;
    }
    _searchController.places.clear(); // Clear search results
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          onPressed: () {
            query = '';
            _resetFilters();
          },
          icon: const Icon(Icons.clear),
        ),
      IconButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (_) => StatefulBuilder(
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
                    mainAxisAlignment: MainAxisAlignment.start,
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
                      const SizedBox(height: 16.0),
                      const TitleTextWidget(
                        label: 'Select Tags',
                        fontSize: 15,
                      ),
                      const SizedBox(height: 8.0),
                      Expanded(
                        child: SingleChildScrollView(
                          child:Wrap(
                            spacing: 16.0,
                            children: [
                              for (int i = 0; i < _categoryPlaceController.catePlaces.length; i++) ...[
                                TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: _categoryPlaceController.catePlaces[i].isSelected
                                        ? Colors.blueAccent
                                        : Colors.white,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                    ),
                                    side: BorderSide(
                                      color: _categoryPlaceController.catePlaces[i].isSelected
                                          ? Colors.blue
                                          : Colors.blue,
                                      width: 1.0,
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _categoryPlaceController.catePlaces[i].isSelected = !_categoryPlaceController.catePlaces[i].isSelected;
                                    });
                                  },
                                  child: Text(
                                    _categoryPlaceController.catePlaces[i].catPlaceName,
                                    style: TextStyle(
                                      color: _categoryPlaceController.catePlaces[i].isSelected
                                          ?Colors.white
                                          :Colors.black,
                                      fontFamily: "GeneralFont",
                                    ),
                                  ),
                                ),
                              ]
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                side: BorderSide(
                                  color: Colors.blueAccent,
                                  width: 4.0,
                                ),
                              ),
                            ),
                            onPressed: () {
                              for (var element in _categoryPlaceController.catePlaces) {
                                element.isSelected = false;
                              }
                              setState(() {});
                            },
                            child: const SubtitleWidget(
                              label: 'Reset',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            )
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ).then((_) {
            _getSearchPlace(query); // Update search results after closing the bottom sheet
          });
        },
        icon: const Icon(Icons.filter_list),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, '');
        _resetFilters();
      },
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
        color: Colors.blueAccent,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    _getSearchPlace(query); // Fetch search results based on query and filters

    return Obx(() {
      if (_searchController.isLoading.value) {
        // Show loading indicator while fetching data
        return const Center(
          child: CircularProgressIndicator(

          ),
        );
      } else if (_searchController.places.isEmpty || query.isEmpty) {
        // Show "No place found!" message if no data is available
        return const Center(
          child: Text('No place found!'),
        );
      } else {
        // Show the list of places if data is available
        return Container(
          margin: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: _searchController.places.length,
            itemBuilder: (context, index) {
              PlaceModel place = _searchController.places[index];
              var avgRating = place.averageRating != null ? place.averageRating.toString() : 'Not rated yet';
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CardHorizontal(
                    onTap: () {
                      Get.to(
                            () => PlaceDetailScreen(place: place),
                        transition: Transition.rightToLeft,
                      );
                    },
                    image: '$placeImageUrl${place.placeGallery?.first.image ?? ''}',
                    name: place.placeName ?? 'unknown',
                    location: place.village?.province?.provinceNameen ?? 'Unknown',
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
        );
      }
    });

  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _getSearchPlace(query); // Fetch suggestions based on query and filters

    return Obx(() {
      if (_searchController.isLoading.value) {
        // Show loading indicator while data is being fetched
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.blueAccent,
          ),
        );
      } else if (_searchController.places.isEmpty) {
        // Show "No place found!" message if there are no results
        return const Center(
          child: Text('No place found!'),
        );
      } else {
        List<PlaceModel> ratedPlaces = [];
        List<PlaceModel> unratedPlaces = [];

        for (var place in _searchController.places) {
          if (place.averageRating != null) {
            ratedPlaces.add(place);
          } else {
            unratedPlaces.add(place);
          }
        }
        ratedPlaces.sort((a, b) {
          return b.averageRating!.compareTo(a.averageRating!);
        });
        List<PlaceModel> sortedPlaces = [...ratedPlaces, ...unratedPlaces];
        return Container(
          margin: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: sortedPlaces.length,
            itemBuilder: (context, index) {
              PlaceModel place = sortedPlaces[index];
              var avgRating = place.averageRating != null
                  ? place.averageRating.toString()
                  : 'Not rated yet';
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CardHorizontal(
                    onTap: () async {
                      var result = await Get.to(
                            () => PlaceDetailScreen(place: place),
                        transition: Transition.rightToLeft,
                      );
                      if (result == true) {
                        _searchController.fetchPlaces(_categoryPlaceController.catePlaces);
                      }
                    },
                    image: '$placeImageUrl${place.placeGallery?.first.image ?? ''}',
                    name: place.placeName ?? 'Unknown',
                    location: place.village?.province?.provinceNameen ?? 'Unknown',
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
        );
      }
    });



  }

  @override
  InputDecorationTheme? get searchFieldDecorationTheme => const InputDecorationTheme(
    hintStyle: TextStyle(color: Colors.grey),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black26),
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blueAccent),
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blueAccent),
    ),
    contentPadding: EdgeInsets.all(8.0),
    filled: true,
    fillColor: Colors.white,
  );

  // Override the text style for the search field
  @override
  TextStyle? get searchFieldStyle => const TextStyle(
    color: Colors.black,
  );

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      inputDecorationTheme: searchFieldDecorationTheme,
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.blueAccent, // Set the cursor color here
      ),
    );
  }
}
