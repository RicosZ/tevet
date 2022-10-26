import 'package:get/state_manager.dart';

class BottomNavigationController extends GetxController {
  var selectedIndex = 0.obs;

  changeindex(int index) {
    selectedIndex.value = index;
  }
}
