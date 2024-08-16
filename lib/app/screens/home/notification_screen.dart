import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '/app/constants/global_config.dart';
import '/app/screens/home/slider_detail.dart';
import '../../controllers/notification_controller.dart';
import '../../models/hotel_model.dart';
import '../../models/notification_model.dart';
import '../../models/place_model.dart';
import '../../models/restaurant_model.dart';
import '../../models/slider_model.dart';
import '../hotel/hotel_detail_screen.dart';
import '../place/place_detail_screen.dart';
import '../restaurant/restaurant_detail_screen.dart';
import '../../widgets/subtitle_widget.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatelessWidget {
  static const routeName = '/NotificationScreen';

  NotificationScreen({super.key});

  final NotificationController notificationController =
      Get.put(NotificationController());

  void navigateToAnotherPage(
      BuildContext context, Notifications notification) async {
    if (notification.notification!.type == 1) {
      var place = notification.relatedData as PlaceModel;
      await Get.to(() => PlaceDetailScreen(place: place),
          transition: Transition.cupertino);
    } else if (notification.notification!.type == 2) {
      var hotel = notification.relatedData as HotelModel;
      await Get.to(() => HotelDetailScreen(hotel: hotel),
          transition: Transition.cupertino);
    } else if (notification.notification!.type == 3) {
      var restaurant = notification.relatedData as RestaurantModel;
      await Get.to(() => RestaurantDetailScreen(restaurant: restaurant),
          transition: Transition.cupertino);
    } else if (notification.notification!.type == 4) {
      var slider = notification.relatedData as SliderModel;
      await Get.to(() => SliderDetailPage(slider: slider),
          transition: Transition.cupertino);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SubtitleWidget(
          label: 'Notifications'.tr,
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (notificationController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.blueAccent,
            ),
          );
        } else if (notificationController.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.notifications_off,
                  size: 100,
                  color: Colors.grey,
                ),
                SubtitleWidget(
                  label: 'No notifications'.tr,
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          backgroundColor: Theme.of(context).colorScheme.primary,
          color: Colors.blueAccent,
          onRefresh: () async {
            await notificationController.fetchNotifications();
            const CircularProgressIndicator(
              color: Colors.blueAccent,
            );
          },
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: GestureDetector(
                        onTap: () {
                          notificationController.deleteAllNotifications();
                        },
                        child: SubtitleWidget(
                          label: 'Clear all'.tr,
                          color: Colors.blueAccent,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: notificationController.notifications.length,
                  itemBuilder: (context, index) {
                    var notification =
                        notificationController.notifications[index];
                    return Slidable(
                      key: ValueKey(notification.id),
                      endActionPane: ActionPane(
                        extentRatio: 0.25,
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              notificationController.deleteNotification(
                                notification.id!,
                              );
                            },
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete'.tr,
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () {
                          notificationController.markAsRead(notification.id!);
                          navigateToAnotherPage(context, notification);
                        },
                        child: Stack(
                          children: [
                            Card(
                              elevation: 0,
                              color: notification.status == 0
                                  ? Theme.of(context).canvasColor
                                  : Theme.of(context).cardColor,
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    child: SizedBox(
                                      height: 70,
                                      width: 70,
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "$baseUrl${notification.notification!.image}",
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            const Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: 8,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SubtitleWidget(
                                            label:
                                                '${notification.notification!.title}',
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: notification.status == 0
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .inversePrimary
                                                : Colors.blueAccent,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            child: SubtitleWidget(
                                              label:
                                                  '${notification.notification!.body}',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          SubtitleWidget(
                                            label: notificationController
                                                .formatDateTimeWithTimeZone(
                                              notification
                                                  .notification!.createdAt!,
                                              '7',
                                            ),
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 15,
                              right: 15,
                              child: Icon(
                                notification.status == 1
                                    ? Icons.notifications_active
                                    : Icons.notifications_off,
                                color: notification.status == 1
                                    ? Colors.blueAccent
                                    : Colors.red,
                                size: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
