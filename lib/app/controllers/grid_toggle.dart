import 'package:get/get.dart';

class GridToggleController extends GetxController {
  bool showGrid = true;

  void changeView() {
    showGrid = !showGrid;
    update();
  }
}
