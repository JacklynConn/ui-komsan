import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '/app/screens/profile/profile_screen.dart';
import '/app/screens/restaurant/restaurant_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/hotel/hotel_screen.dart';

class RootController extends GetxController {
  int currentIndex = 0;

  final List<Widget> lstScreens = [
    const HomeScreen(),
     HotelScreen(),
     RestaurantScreen(),
    ProfileScreen(),
  ];

  void bottomNavigationTap(int index) {
    currentIndex = index;
    update();
  }
}
