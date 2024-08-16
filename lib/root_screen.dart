import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/app/controllers/root_controller.dart';

class RootScreen extends StatelessWidget {
  static const String routeName = '/RootScreen';

  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RootController());
    return GetBuilder<RootController>(
      builder: (_) {
        return Scaffold(
          body: IndexedStack(
            index: controller.currentIndex,
            children: controller.lstScreens,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: controller.currentIndex,
            onTap: controller.bottomNavigationTap,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.hotel),
                label: 'Hotel',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.restaurant),
                label: 'Restaurant',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}
