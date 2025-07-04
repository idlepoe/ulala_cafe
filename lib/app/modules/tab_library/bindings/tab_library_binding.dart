import 'package:get/get.dart';

import '../controllers/tab_library_controller.dart';

class TabLibraryBinding extends Bindings {
  @override
  void dependencies() {
    // 이미 MainBinding에서 등록되므로 여기서는 제거
    // Get.lazyPut<TabLibraryController>(() => TabLibraryController());
  }
}
