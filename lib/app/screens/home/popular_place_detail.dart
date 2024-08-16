import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/title_text_widget.dart';
import '../../widgets/subtitle_widget.dart';
import '../hotel/hotel_map_screen.dart';

class PopularPlaceDetail extends StatelessWidget {
  const PopularPlaceDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // modify #IT-130 Mak Mach 2024-05-19
        title: const TitleTextWidget(
          label: "Popular Place Detail",
        ),
      ),
      // modify #IT-130 Mak Mach 2024-05-19
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Container(
          color: Theme.of(context).colorScheme.background,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Container(
                width: double.infinity,
                height: 240,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: CachedNetworkImageProvider(
                      "https://th.bing.com/th/id/OIP.UuDi5y057jpnfrbTEfHYlgHaEK?rs=1&pid=ImgDetMain",
                    ),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TitleTextWidget(
                            label: "Battambang Temple".tr,
                            color: Colors.blueAccent,
                            fontSize: 18,
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.favorite_border))
                        ],
                      ),
                      const Row(
                        children: [
                          SubtitleWidget(
                            label: "Rating: ",
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          Icon(
                            Icons.star,
                            size: 20,
                            color: Colors.amber,
                          ),
                          SubtitleWidget(
                            label: "4.5",
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  const Row(
                    children: [
                      SubtitleWidget(
                        label: "Location: ",
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      SubtitleWidget(
                        label: "Battambang, Cambodia",
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    children: [
                      const SubtitleWidget(
                        label: "Category: ",
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      Container(
                        padding: const EdgeInsets.all(3.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.withOpacity(0.3),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            bottomRight: Radius.circular(8.0),
                          ),
                        ),
                        child: const SubtitleWidget(
                          label: "Mountain",
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      Container(
                        padding: const EdgeInsets.all(3.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.withOpacity(0.3),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            bottomRight: Radius.circular(8.0),
                          ),
                        ),
                        child: const SubtitleWidget(
                          label: "Historical",
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              GestureDetector(
                onTap: () {
                  Get.toNamed("/map");
                },
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: CachedNetworkImageProvider(
                        "https://th.bing.com/th/id/OIP.UuDi5y057jpnfrbTEfHYlgHaEK?rs=1&pid=ImgDetMain",
                      ),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  // child: GestureDetector(
                  //   onTap: () {
                  //     Get.toNamed("/map");
                  //   },
                  //   child: MapScreen(),
                  // ),
                ),
              ),
              const SizedBox(height: 8.0),
              const SubtitleWidget(
                label: "Description",
                fontSize: 20,
                color: Colors.blueAccent,
              ),
              Container(
                alignment: Alignment.center,
                child: const SubtitleWidget(
                  label:
                      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. "
                      "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, "
                      "when an unknown printer took a galley of type and scrambled it to make a ",
                  fontSize: 14,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 8.0),
              const SubtitleWidget(
                label: "Nearby Places",
                fontSize: 18,
                color: Colors.blueAccent,
                fontWeight: FontWeight.w500,
              ),
              DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    const Column(
                      children: [
                        TabBar(
                            labelColor: Colors.blueAccent,
                            dividerColor: Colors.transparent,
                            labelStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            indicator: UnderlineTabIndicator(
                              borderSide: BorderSide(
                                width: 3,
                                color: Colors.blue,
                              ),
                            ),
                            tabs: [
                              Tab(
                                child: SubtitleWidget(
                                  label: "Places",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Tab(
                                child: Text("Hotels"),
                              ),
                              Tab(
                                child: Text(
                                  "Restaurant",
                                ),
                              ),
                            ]),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.transparent,
                      child: TabBarView(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 100,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: const DecorationImage(
                                image: CachedNetworkImageProvider(
                                  "https://th.bing.com/th/id/OIP.UuDi5y057jpnfrbTEfHYlgHaEK?rs=1&pid=ImgDetMain",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: const DecorationImage(
                                image: CachedNetworkImageProvider(
                                  "https://th.bing.com/th/id/OIP.Zis2cXdglxbZemS3QNsdZQHaE8?rs=1&pid=ImgDetMain",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: const DecorationImage(
                                image: CachedNetworkImageProvider(
                                  "https://th.bing.com/th/id/R.45307e3f41cb5ed6742ef88527513ace?rik=zE3%2bbW7BgzTd8w&riu=http%3a%2f%2fstatic5.businessinsider.com%2fimage%2f52602781ecad04a762aaec49%2fa-food-critic-shares-his-best-tips-for-dining-at-fancy-restaurants.jpg&ehk=513CEQchm4UADq3NZmeyxoYiX9EZQgRNWHJdwmEzP60%3d&risl=&pid=ImgRaw&r=0",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      // modify #IT-130 Mak Mach 2024-05-19
    );
  }
}
